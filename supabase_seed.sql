-- ================================================================
-- SEED: 10 preguntas español + 10 inglés (20 total)
-- Usa placehold.co para imágenes — 100% confiable, sin APIs
-- Ejecutar LUEGO de iniciar sesión en la app
-- ================================================================
do $$
declare
  seed_user uuid;
begin
  select id into seed_user from vote_profiles limit 1;
  if seed_user is null then
    raise exception 'No hay usuarios en vote_profiles. Iniciá sesión en la app primero y volvé a ejecutar este script.';
  end if;

  -- ============================================================
  -- 10 PREGUNTAS EN ESPAÑOL
  -- ============================================================
  insert into vote_questions (user_id, text, category, lang, image_url) values

  (seed_user,
   '¿La pizza con ananá es aceptable?',
   'Comida', 'es',
   'https://placehold.co/600x400/b45309/fef9c3?text=🍕+Pizza'),

  (seed_user,
   '¿El trabajo remoto debería ser un derecho universal?',
   'Trabajo', 'es',
   'https://placehold.co/600x400/1e40af/dbeafe?text=🏠+Home+Office'),

  (seed_user,
   '¿Los perros son mejores mascotas que los gatos?',
   'General', 'es',
   'https://placehold.co/600x400/166534/dcfce7?text=🐶+Perros+vs+Gatos'),

  (seed_user,
   '¿La inteligencia artificial va a reemplazar la mayoría de los empleos en 20 años?',
   'Tech', 'es',
   'https://placehold.co/600x400/4c1d95/ede9fe?text=🤖+Inteligencia+Artificial'),

  (seed_user,
   '¿Preferís playa antes que montaña?',
   'General', 'es',
   'https://placehold.co/600x400/0369a1/e0f2fe?text=🏖️+Playa+vs+Montaña'),

  (seed_user,
   '¿El cambio climático es la amenaza más urgente del siglo?',
   'General', 'es',
   'https://placehold.co/600x400/14532d/dcfce7?text=🌍+Clima'),

  (seed_user,
   '¿Las redes sociales hacen más daño que bien?',
   'General', 'es',
   'https://placehold.co/600x400/7f1d1d/fee2e2?text=📱+Redes+Sociales'),

  (seed_user,
   '¿El mate es superior al café?',
   'Comida', 'es',
   'https://placehold.co/600x400/78350f/fef3c7?text=🧉+Mate+vs+Café'),

  (seed_user,
   '¿Los videojuegos son una forma de arte legítima?',
   'General', 'es',
   'https://placehold.co/600x400/1e1b4b/e0e7ff?text=🎮+Videojuegos'),

  (seed_user,
   '¿Debería ser obligatorio recyclar en los hogares?',
   'General', 'es',
   'https://placehold.co/600x400/065f46/d1fae5?text=♻️+Reciclaje');


  -- ============================================================
  -- 10 PREGUNTAS EN INGLÉS
  -- ============================================================
  insert into vote_questions (user_id, text, category, lang, image_url) values

  (seed_user,
   'Is pineapple on pizza acceptable?',
   'Comida', 'en',
   'https://placehold.co/600x400/b45309/fef9c3?text=🍕+Pineapple+Pizza'),

  (seed_user,
   'Should the 4-day work week be the global standard?',
   'Trabajo', 'en',
   'https://placehold.co/600x400/1e40af/dbeafe?text=💼+4-Day+Week'),

  (seed_user,
   'Are dogs better pets than cats?',
   'General', 'en',
   'https://placehold.co/600x400/166534/dcfce7?text=🐶+Dogs+vs+Cats'),

  (seed_user,
   'Will AI replace most jobs in the next 20 years?',
   'Tech', 'en',
   'https://placehold.co/600x400/4c1d95/ede9fe?text=🤖+AI+%26+Jobs'),

  (seed_user,
   'Do you prefer beach over mountains?',
   'General', 'en',
   'https://placehold.co/600x400/0369a1/e0f2fe?text=🏖️+Beach+vs+Mountains'),

  (seed_user,
   'Is climate change the most urgent threat of this century?',
   'General', 'en',
   'https://placehold.co/600x400/14532d/dcfce7?text=🌍+Climate+Change'),

  (seed_user,
   'Are social media platforms doing more harm than good?',
   'General', 'en',
   'https://placehold.co/600x400/7f1d1d/fee2e2?text=📱+Social+Media'),

  (seed_user,
   'Is coffee better than tea?',
   'Comida', 'en',
   'https://placehold.co/600x400/78350f/fef3c7?text=☕+Coffee+vs+Tea'),

  (seed_user,
   'Are video games a legitimate art form?',
   'General', 'en',
   'https://placehold.co/600x400/1e1b4b/e0e7ff?text=🎮+Video+Games'),

  (seed_user,
   'Should recycling be mandatory in every household?',
   'General', 'en',
   'https://placehold.co/600x400/065f46/d1fae5?text=♻️+Recycling');


  raise notice '✅ Seed OK: 20 preguntas insertadas para el usuario %', seed_user;
end;
$$;
