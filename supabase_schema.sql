
-- 1. Tabla de Perfiles (Extiende los datos de Auth)
create table vote_profiles (
  id uuid references auth.users on delete cascade primary key,
  updated_at timestamp with time zone,
  full_name text,
  avatar_url text,
  email text
);

-- 2. Tabla de Preguntas
create table vote_questions (
  id uuid default gen_random_uuid() primary key,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  user_id uuid references auth.users not null,
  text text not null,
  image_url text,
  category text default 'General',
  yes_count int default 0,
  no_count int default 0
);

-- 3. Tabla de Votos (Para evitar votos duplicados)
create table vote_votes (
  id uuid default gen_random_uuid() primary key,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  user_id uuid references auth.users not null,
  question_id uuid references vote_questions on delete cascade not null,
  vote_type text check (vote_type in ('yes', 'no')),
  unique(user_id, question_id) -- Regla de oro: un voto por usuario por pregunta
);

-- 4. Habilitar Row Level Security (RLS)
alter table vote_profiles enable row level security;
alter table vote_questions enable row level security;
alter table vote_votes enable row level security;

-- 5. Políticas de seguridad
-- Perfiles
create policy "Público puede ver perfiles" on vote_profiles for select using (true);
create policy "Usuarios pueden editar su propio perfil" on vote_profiles for update using (auth.uid() = id);

-- Preguntas
create policy "Público puede ver preguntas" on vote_questions for select using (true);
create policy "Usuarios autenticados pueden crear preguntas" on vote_questions for insert with check (auth.role() = 'authenticated');
-- Permitir actualizar contadores de votos
create policy "Sistema puede actualizar contadores" on vote_questions for update using (true);

-- Votos
create policy "Usuarios pueden ver sus propios votos" on vote_votes for select using (auth.uid() = user_id);
create policy "Usuarios autenticados pueden votar" on vote_votes for insert with check (auth.role() = 'authenticated');

-- 6. Función RPC para incrementar contadores atómicamente (evita condiciones de carrera)
-- Ejecuta en el SQL Editor de Supabase DESPUES de crear las tablas
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
