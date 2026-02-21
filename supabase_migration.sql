-- =============================================================
-- MIGRACION: Solo ejecutar si las tablas ya existen
-- Agrega la política de UPDATE y la función RPC para votos
-- =============================================================

-- Permitir que usuarios autenticados actualicen contadores de votos
create policy "Sistema puede actualizar contadores"
  on vote_questions for update
  using (true);

-- Función RPC para incrementar contadores de forma atómica
-- (evita que dos votos simultáneos se pisen entre sí)
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
