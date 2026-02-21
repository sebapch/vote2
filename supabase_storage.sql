-- Crear bucket para imagenes de preguntas (publico)
insert into storage.buckets (id, name, public)
values ('vote-images', 'vote-images', true);

-- Política: usuarios autenticados pueden subir
create policy "Auth users can upload images"
  on storage.objects for insert
  with check (bucket_id = 'vote-images' AND auth.role() = 'authenticated');

-- Política: cualquiera puede ver las imagenes
create policy "Public can view images"
  on storage.objects for select
  using (bucket_id = 'vote-images');
