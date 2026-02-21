-- ================================================================
-- RESET COMPLETO — Ejecutar en SQL Editor de Supabase
-- Borra y recrea todo desde cero, incluyendo trigger para perfiles
-- ================================================================

-- 1. BORRAR TODO (en orden por dependencias)
drop trigger if exists on_auth_user_created on auth.users;
drop function if exists public.handle_new_user();
drop function if exists public.vote_increment(uuid, text);

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
  no_count int default 0
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


-- 3. ROW LEVEL SECURITY
alter table vote_profiles enable row level security;
alter table vote_questions enable row level security;
alter table vote_votes enable row level security;

-- Perfiles: lectura pública, edición propia
create policy "Perfiles visibles públicamente" on vote_profiles for select using (true);
create policy "Usuarios editan su perfil" on vote_profiles for update using (auth.uid() = id);
create policy "Insertar perfil propio" on vote_profiles for insert with check (auth.uid() = id);

-- Preguntas: lectura pública, inserción autenticada, update para contadores
create policy "Preguntas públicas" on vote_questions for select using (true);
create policy "Crear preguntas autenticado" on vote_questions for insert with check (auth.role() = 'authenticated');
create policy "Actualizar contadores" on vote_questions for update using (true);

-- Votos: cada usuario ve los suyos
create policy "Ver propios votos" on vote_votes for select using (auth.uid() = user_id);
create policy "Votar autenticado" on vote_votes for insert with check (auth.role() = 'authenticated');


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
