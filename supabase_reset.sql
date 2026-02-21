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


-- 7. SEED: 10 preguntas en español y 10 en inglés con imágenes
insert into vote_questions (text, category, lang, image_url, user_id) values
  -- Español (10)
  ('¿Debería el teletrabajo ser un derecho universal?', 'Trabajo', 'es', 'https://images.unsplash.com/photo-1586281380349-632531db7ed4?w=800&q=80', (select id from vote_profiles limit 1)),
  ('¿Pagarías más impuestos por una mejor salud pública?', 'Sociedad', 'es', 'https://images.unsplash.com/photo-1505751172107-1bc32c38ed3d?w=800&q=80', (select id from vote_profiles limit 1)),
  ('¿El dinero realmente da la felicidad?', 'Vida', 'es', 'https://images.unsplash.com/photo-1518458028785-8fbcd101ebb9?w=800&q=80', (select id from vote_profiles limit 1)),
  ('¿Las redes sociales hacen más daño que bien?', 'Tech', 'es', 'https://images.unsplash.com/photo-1611162617474-5b21e879e113?w=800&q=80', (select id from vote_profiles limit 1)),
  ('¿Preferirías vivir en el campo que en la ciudad?', 'Vida', 'es', 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800&q=80', (select id from vote_profiles limit 1)),
  ('¿La IA reemplazará la mayoría de los trabajos?', 'Tech', 'es', 'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=800&q=80', (select id from vote_profiles limit 1)),
  ('¿Comerías carne cultivada en laboratorio?', 'Comida', 'es', 'https://images.unsplash.com/photo-1587593817642-599961aee2fc?w=800&q=80', (select id from vote_profiles limit 1)),
  ('¿La semana laboral debería ser de 4 días?', 'Trabajo', 'es', 'https://images.unsplash.com/photo-1506784919141-93ac348c081d?w=800&q=80', (select id from vote_profiles limit 1)),
  ('¿El café es mejor que el té?', 'Comida', 'es', 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800&q=80', (select id from vote_profiles limit 1)),
  ('¿Las criptomonedas son el futuro del dinero?', 'Tech', 'es', 'https://images.unsplash.com/photo-1518546305927-5a555bb7020d?w=800&q=80', (select id from vote_profiles limit 1)),

  -- English (10)
  ('Should remote work be a universal right?', 'Work', 'en', 'https://images.unsplash.com/photo-1521791136064-7986c2923216?w=800&q=80', (select id from vote_profiles limit 1)),
  ('Would you pay more taxes for better healthcare?', 'Society', 'en', 'https://images.unsplash.com/photo-1538108149393-fdfd818d59ae?w=800&q=80', (select id from vote_profiles limit 1)),
  ('Does money truly bring happiness?', 'Life', 'en', 'https://images.unsplash.com/photo-1526304640581-d334cdbbf45e?w=800&q=80', (select id from vote_profiles limit 1)),
  ('Is social media more harmful than helpful?', 'Tech', 'en', 'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=800&q=80', (select id from vote_profiles limit 1)),
  ('Would you choose country life over city life?', 'Life', 'en', 'https://images.unsplash.com/photo-1444333509404-c20d9cb52f86?w=800&q=80', (select id from vote_profiles limit 1)),
  ('Will AI replace most human jobs?', 'Tech', 'en', 'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=800&q=80', (select id from vote_profiles limit 1)),
  ('Would you eat lab-grown cultivated meat?', 'Food', 'en', 'https://images.unsplash.com/photo-1514327605112-b887c0e61c0a?w=800&q=80', (select id from vote_profiles limit 1)),
  ('Should the work week be 4 days instead of 5?', 'Work', 'en', 'https://images.unsplash.com/photo-1454165833767-027508492025?w=800&q=80', (select id from vote_profiles limit 1)),
  ('Is coffee superior to tea?', 'Food', 'en', 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800&q=80', (select id from vote_profiles limit 1)),
  ('Are cryptocurrencies the future of finance?', 'Tech', 'en', 'https://images.unsplash.com/photo-1621761191319-c6fb620040bc?w=800&q=80', (select id from vote_profiles limit 1));
