-- ================================================================
-- FIX IMAGENES: Asigna imágenes confiables a las preguntas
-- del seed (las que NO vienen de Supabase Storage)
-- Usamos picsum.photos/id/{n} — garantizado que funciona
-- ================================================================

WITH numbered AS (
  SELECT id, ROW_NUMBER() OVER (ORDER BY created_at) AS rn
  FROM vote_questions
  WHERE image_url IS NOT NULL
    AND image_url NOT LIKE '%supabase%'
)
UPDATE vote_questions AS q
SET image_url = 'https://picsum.photos/id/' || ((n.rn % 80) + 10)::text || '/600/400'
FROM numbered n
WHERE q.id = n.id;
