-- =============================================
-- RESET + SEED: Limpiar votos y cargar preguntas
-- Ejecutar en el SQL Editor de Supabase
-- =============================================

-- 1. Borrar todos los votos
TRUNCATE TABLE vote_votes;

-- 2. Borrar todas las preguntas existentes
TRUNCATE TABLE vote_questions CASCADE;

-- 3. Insertar 30 preguntas de prueba (user_id ficticio para seed)
-- IMPORTANTE: reemplaza 'TU_USER_ID' con tu UUID real de auth.users
-- Para obtenerlo: SELECT id FROM auth.users LIMIT 1;

INSERT INTO vote_questions (text, category, yes_count, no_count, user_id) VALUES
  ('¿Debería el teletrabajo ser un derecho universal?', 'Trabajo', 0, 0, (SELECT id FROM auth.users LIMIT 1)),
  ('¿Pagarías más impuestos si eso mejorara la salud pública?', 'Sociedad', 0, 0, (SELECT id FROM auth.users LIMIT 1)),
  ('¿El dinero da la felicidad?', 'Vida', 0, 0, (SELECT id FROM auth.users LIMIT 1)),
  ('¿Las redes sociales hacen más daño que bien?', 'Tech', 0, 0, (SELECT id FROM auth.users LIMIT 1)),
  ('¿Preferirías vivir en el campo antes que en la ciudad?', 'Vida', 0, 0, (SELECT id FROM auth.users LIMIT 1)),
  ('¿La inteligencia artificial va a reemplazar tu trabajo?', 'Tech', 0, 0, (SELECT id FROM auth.users LIMIT 1)),
  ('¿Comerías carne cultivada en laboratorio?', 'Comida', 0, 0, (SELECT id FROM auth.users LIMIT 1)),
  ('¿Crees que la semana laboral debería ser de 4 días?', 'Trabajo', 0, 0, (SELECT id FROM auth.users LIMIT 1)),
  ('¿El fútbol es el deporte más aburrido del mundo?', 'Deporte', 0, 0, (SELECT id FROM auth.users LIMIT 1)),
  ('¿Usarías un chip cerebral si te hiciera más inteligente?', 'Tech', 0, 0, (SELECT id FROM auth.users LIMIT 1)),
  ('¿El matrimonio es una institución obsoleta?', 'Sociedad', 0, 0, (SELECT id FROM auth.users LIMIT 1)),
  ('¿Deberían prohibirse los autos de combustión para 2030?', 'Sociedad', 0, 0, (SELECT id FROM auth.users LIMIT 1)),
  ('¿Dormirías 8 horas aunque eso te costara un ascenso?', 'Vida', 0, 0, (SELECT id FROM auth.users LIMIT 1)),
  ('¿El café es mejor que el mate?', 'Comida', 0, 0, (SELECT id FROM auth.users LIMIT 1)),
  ('¿Crees que los humanos llegarán a Marte antes de 2040?', 'Tech', 0, 0, (SELECT id FROM auth.users LIMIT 1)),
  ('¿Es ético tener animales domésticos?', 'Sociedad', 0, 0, (SELECT id FROM auth.users LIMIT 1)),
  ('¿Preferirías ser muy inteligente o muy creativo?', 'Vida', 0, 0, (SELECT id FROM auth.users LIMIT 1)),
  ('¿Las criptomonedas son el futuro del dinero?', 'Tech', 0, 0, (SELECT id FROM auth.users LIMIT 1)),
  ('¿Votarías por un presidente robot si tomara mejores decisiones?', 'Sociedad', 0, 0, (SELECT id FROM auth.users LIMIT 1)),
  ('¿La pizza con piña debería estar prohibida por ley?', 'Comida', 0, 0, (SELECT id FROM auth.users LIMIT 1)),
  ('¿Harías ejercicio todos los días si te pagaran por eso?', 'Deporte', 0, 0, (SELECT id FROM auth.users LIMIT 1)),
  ('¿El trabajo remoto destruye la cultura de empresa?', 'Trabajo', 0, 0, (SELECT id FROM auth.users LIMIT 1)),
  ('¿Crees que existe vida inteligente fuera de la Tierra?', 'General', 0, 0, (SELECT id FROM auth.users LIMIT 1)),
  ('¿Pagarías por una app si no tuviera publicidad?', 'Tech', 0, 0, (SELECT id FROM auth.users LIMIT 1)),
  ('¿Es posible ser amigo de tu ex pareja?', 'Vida', 0, 0, (SELECT id FROM auth.users LIMIT 1)),
  ('¿Preferirías leer un libro que ver una serie?', 'Cultura', 0, 0, (SELECT id FROM auth.users LIMIT 1)),
  ('¿La educación universitaria debería ser gratuita?', 'Sociedad', 0, 0, (SELECT id FROM auth.users LIMIT 1)),
  ('¿Usarías ropa generada por IA si fuera más barata?', 'Tech', 0, 0, (SELECT id FROM auth.users LIMIT 1)),
  ('¿Crees que el veganismo debería ser la norma global?', 'Comida', 0, 0, (SELECT id FROM auth.users LIMIT 1)),
  ('¿Trabajarías gratis en algo que te apasionara?', 'Trabajo', 0, 0, (SELECT id FROM auth.users LIMIT 1));
