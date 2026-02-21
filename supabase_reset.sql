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


-- 7. SEED: 30 preguntas de prueba
insert into vote_questions (text, category, yes_count, no_count, user_id) values
  ('¿Debería el teletrabajo ser un derecho universal?', 'Trabajo', 0, 0, (select id from vote_profiles limit 1)),
  ('¿Pagarías más impuestos si eso mejorara la salud pública?', 'Sociedad', 0, 0, (select id from vote_profiles limit 1)),
  ('¿El dinero da la felicidad?', 'Vida', 0, 0, (select id from vote_profiles limit 1)),
  ('¿Las redes sociales hacen más daño que bien?', 'Tech', 0, 0, (select id from vote_profiles limit 1)),
  ('¿Preferirías vivir en el campo antes que en la ciudad?', 'Vida', 0, 0, (select id from vote_profiles limit 1)),
  ('¿La inteligencia artificial va a reemplazar tu trabajo?', 'Tech', 0, 0, (select id from vote_profiles limit 1)),
  ('¿Comerías carne cultivada en laboratorio?', 'Comida', 0, 0, (select id from vote_profiles limit 1)),
  ('¿Crees que la semana laboral debería ser de 4 días?', 'Trabajo', 0, 0, (select id from vote_profiles limit 1)),
  ('¿El fútbol es el deporte más aburrido del mundo?', 'Deporte', 0, 0, (select id from vote_profiles limit 1)),
  ('¿Usarías un chip cerebral si te hiciera más inteligente?', 'Tech', 0, 0, (select id from vote_profiles limit 1)),
  ('¿El matrimonio es una institución obsoleta?', 'Sociedad', 0, 0, (select id from vote_profiles limit 1)),
  ('¿Deberían prohibirse los autos de combustión para 2030?', 'Sociedad', 0, 0, (select id from vote_profiles limit 1)),
  ('¿Dormirías 8 horas aunque eso te costara un ascenso?', 'Vida', 0, 0, (select id from vote_profiles limit 1)),
  ('¿El café es mejor que el mate?', 'Comida', 0, 0, (select id from vote_profiles limit 1)),
  ('¿Crees que los humanos llegarán a Marte antes de 2040?', 'Tech', 0, 0, (select id from vote_profiles limit 1)),
  ('¿Es ético tener animales domésticos?', 'Sociedad', 0, 0, (select id from vote_profiles limit 1)),
  ('¿Preferirías ser muy inteligente antes que muy creativo?', 'Vida', 0, 0, (select id from vote_profiles limit 1)),
  ('¿Las criptomonedas son el futuro del dinero?', 'Tech', 0, 0, (select id from vote_profiles limit 1)),
  ('¿Votarías por un presidente robot si tomara mejores decisiones?', 'Sociedad', 0, 0, (select id from vote_profiles limit 1)),
  ('¿La pizza con piña debería estar prohibida por ley?', 'Comida', 0, 0, (select id from vote_profiles limit 1)),
  ('¿Harías ejercicio todos los días si te pagaran por eso?', 'Deporte', 0, 0, (select id from vote_profiles limit 1)),
  ('¿El trabajo remoto destruye la cultura de empresa?', 'Trabajo', 0, 0, (select id from vote_profiles limit 1)),
  ('¿Crees que existe vida inteligente fuera de la Tierra?', 'General', 0, 0, (select id from vote_profiles limit 1)),
  ('¿Pagarías por una app si no tuviera publicidad?', 'Tech', 0, 0, (select id from vote_profiles limit 1)),
  ('¿Es posible ser amigo de tu ex pareja?', 'Vida', 0, 0, (select id from vote_profiles limit 1)),
  ('¿Preferirías leer un libro antes que ver una serie?', 'Cultura', 0, 0, (select id from vote_profiles limit 1)),
  ('¿La educación universitaria debería ser gratuita?', 'Sociedad', 0, 0, (select id from vote_profiles limit 1)),
  ('¿Usarías ropa generada por IA si fuera más barata?', 'Tech', 0, 0, (select id from vote_profiles limit 1)),
  ('¿Crees que el veganismo debería ser la norma global?', 'Comida', 0, 0, (select id from vote_profiles limit 1)),
  ('¿Trabajarías gratis en algo que te apasionara?', 'Trabajo', 0, 0, (select id from vote_profiles limit 1));
