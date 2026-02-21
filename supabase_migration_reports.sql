-- ================================================================
-- MIGRATION: Agregar sistema de denuncias
-- Ejecutar en SQL Editor de Supabase (en lugar del reset completo)
-- ================================================================

-- 1. Agregar columna reports_count a vote_questions
alter table vote_questions
  add column if not exists reports_count int default 0;

-- 2. Crear tabla vote_reports
create table if not exists vote_reports (
  id uuid default gen_random_uuid() primary key,
  created_at timestamptz default now() not null,
  user_id uuid references vote_profiles(id) on delete cascade not null,
  question_id uuid references vote_questions(id) on delete cascade not null,
  unique(user_id, question_id)
);

-- 3. Habilitar RLS en vote_reports
alter table vote_reports enable row level security;

-- 4. Policies para vote_reports
drop policy if exists "Ver propias denuncias" on vote_reports;
create policy "Ver propias denuncias" on vote_reports
  for select using (auth.uid() = user_id);

drop policy if exists "Denunciar autenticado" on vote_reports;
create policy "Denunciar autenticado" on vote_reports
  for insert with check (auth.role() = 'authenticated');

-- 5. Reemplazar la policy de SELECT en vote_questions
--    para ocultar las preguntas con 3+ denuncias
drop policy if exists "Preguntas públicas" on vote_questions;
drop policy if exists "Preguntas visibles" on vote_questions;
create policy "Preguntas visibles" on vote_questions
  for select using (reports_count < 3);

-- 6. RPC: report_question
drop function if exists public.report_question(uuid);
create or replace function report_question(p_question_id uuid)
returns json language plpgsql security definer as $$
declare
  v_already boolean;
begin
  -- Verificar si el usuario ya denunció esta pregunta
  select exists(
    select 1 from vote_reports
    where user_id = auth.uid() and question_id = p_question_id
  ) into v_already;

  if v_already then
    return json_build_object('success', false, 'reason', 'already_reported');
  end if;

  -- Registrar la denuncia
  insert into vote_reports (user_id, question_id)
  values (auth.uid(), p_question_id);

  -- Incrementar el contador
  update vote_questions
  set reports_count = reports_count + 1
  where id = p_question_id;

  return json_build_object('success', true);
end;
$$;
