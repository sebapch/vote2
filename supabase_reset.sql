-- ================================================================
-- RESET COMPLETO — Ejecutar en SQL Editor de Supabase
-- Borra y recrea todo desde cero, incluyendo trigger para perfiles
-- ================================================================

-- 1. BORRAR TODO (en orden por dependencias)
drop trigger if exists on_auth_user_created on auth.users;
drop function if exists public.handle_new_user();
drop function if exists public.vote_increment(uuid, text);
drop function if exists public.report_question(uuid);

drop table if exists vote_reports cascade;
drop table if exists vote_votes cascade;
drop table if exists vote_questions cascade;
drop table if exists vote_profiles cascade;


-- 2. CREAR TABLAS

-- Perfiles (espejo de auth.users con datos públicos)
create table vote_profiles (
  id uuid references auth.users on delete cascade primary key,
  full_name text,
  avatar_url text,
  email text,
  onboarding_completed boolean default false,
  updated_at timestamptz default now()
);

-- Preguntas
create table vote_questions (
  id uuid default gen_random_uuid() primary key,
  created_at timestamptz default now() not null,
  user_id uuid references vote_profiles(id) on delete cascade not null,
  text text not null,
  image_url text,
  category text default 'General',
  lang text default 'es' check (lang in ('es', 'en')),
  yes_count int default 0,
  no_count int default 0,
  reports_count int default 0
);

-- Votos (un voto por usuario por pregunta)
create table vote_votes (
  id uuid default gen_random_uuid() primary key,
  created_at timestamptz default now() not null,
  user_id uuid references vote_profiles(id) on delete cascade not null,
  question_id uuid references vote_questions(id) on delete cascade not null,
  vote_type text check (vote_type in ('yes', 'no')),
  unique(user_id, question_id)
);

-- Denuncias (una por usuario por pregunta)
create table vote_reports (
  id uuid default gen_random_uuid() primary key,
  created_at timestamptz default now() not null,
  user_id uuid references vote_profiles(id) on delete cascade not null,
  question_id uuid references vote_questions(id) on delete cascade not null,
  unique(user_id, question_id)
);


-- 3. ROW LEVEL SECURITY
alter table vote_profiles enable row level security;
alter table vote_questions enable row level security;
alter table vote_votes enable row level security;
alter table vote_reports enable row level security;

-- Perfiles: lectura pública, edición propia
create policy "Perfiles visibles públicamente" on vote_profiles for select using (true);
create policy "Usuarios editan su perfil" on vote_profiles for update using (auth.uid() = id);
create policy "Insertar perfil propio" on vote_profiles for insert with check (auth.uid() = id);

-- Preguntas: ocultar las denunciadas 3 veces, inserción autenticada, update para contadores
create policy "Preguntas visibles" on vote_questions for select using (reports_count < 3);
create policy "Crear preguntas autenticado" on vote_questions for insert with check (auth.role() = 'authenticated');
create policy "Actualizar contadores" on vote_questions for update using (true);

-- Votos: cada usuario ve los suyos
create policy "Ver propios votos" on vote_votes for select using (auth.uid() = user_id);
create policy "Votar autenticado" on vote_votes for insert with check (auth.role() = 'authenticated');

-- Denuncias: usuarios ven las suyas, pueden insertar una vez por pregunta
create policy "Ver propias denuncias" on vote_reports for select using (auth.uid() = user_id);
create policy "Denunciar autenticado" on vote_reports for insert with check (auth.role() = 'authenticated');


-- 4. RPC: Incremento atómico de contadores
create or replace function vote_increment(question_id uuid, vote_col text)
returns void language plpgsql security definer as $$
begin
  if vote_col = 'yes' then
    update vote_questions set yes_count = yes_count + 1 where id = question_id;
  elsif vote_col = 'no' then
    update vote_questions set no_count = no_count + 1 where id = question_id;
  end if;
end;
$$;


-- 4b. RPC: Denunciar pregunta (incrementa contador, oculta al llegar a 3)
create or replace function report_question(p_question_id uuid)
returns json language plpgsql security definer as $$
declare
  v_already boolean;
begin
  -- Check if user already reported this question
  select exists(
    select 1 from vote_reports
    where user_id = auth.uid() and question_id = p_question_id
  ) into v_already;

  if v_already then
    return json_build_object('success', false, 'reason', 'already_reported');
  end if;

  -- Insert the report
  insert into vote_reports (user_id, question_id)
  values (auth.uid(), p_question_id);

  -- Increment reports_count
  update vote_questions
  set reports_count = reports_count + 1
  where id = p_question_id;

  return json_build_object('success', true);
end;
$$;


-- 5. TRIGGER: Crear perfil automáticamente al registrarse con Google
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.vote_profiles (id, full_name, avatar_url, email)
  values (
    new.id,
    new.raw_user_meta_data->>'full_name',
    new.raw_user_meta_data->>'avatar_url',
    new.email
  )
  on conflict (id) do update
    set full_name  = excluded.full_name,
        avatar_url = excluded.avatar_url,
        email      = excluded.email,
        updated_at = now();
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();


-- 6. POBLAR PERFIL DE USUARIOS YA EXISTENTES
-- (Por si ya iniciaste sesión antes del trigger)
insert into vote_profiles (id, full_name, avatar_url, email)
select
  id,
  raw_user_meta_data->>'full_name',
  raw_user_meta_data->>'avatar_url',
  email
from auth.users
on conflict (id) do update
  set full_name  = excluded.full_name,
      avatar_url = excluded.avatar_url,
      email      = excluded.email,
      updated_at = now();
