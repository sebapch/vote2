-- ================================================================
-- SEED: 100 preguntas en español + 100 en inglés, con imagenes
-- Script dinámico: usa el primer usuario de vote_profiles
-- ================================================================
do $$
declare
  seed_user uuid;
begin
  select id into seed_user from vote_profiles limit 1;
  if seed_user is null then
    raise exception 'No hay usuarios en vote_profiles. Iniciá sesión primero.';
  end if;

  -- ============================================================
  -- 100 PREGUNTAS EN ESPAÑOL
  -- ============================================================
  insert into vote_questions (user_id, text, category, lang, image_url) values

  -- Polémica / Sociedad
  (seed_user, '¿Debería el aborto ser legal en toda América Latina?', 'General', 'es', 'https://images.unsplash.com/photo-1529107386315-e1a2ed48a620?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Las redes sociales hacen más daño que bien a la sociedad?', 'General', 'es', 'https://images.unsplash.com/photo-1611162617213-7d7a39e9b1d7?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿El trabajo remoto debería ser un derecho universal?', 'Trabajo', 'es', 'https://images.unsplash.com/photo-1586473219010-2ffc57b0d282?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿La semana laboral de 4 días debería ser obligatoria?', 'Trabajo', 'es', 'https://images.unsplash.com/photo-1506784365847-bbad939e9335?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿El salario mínimo debería duplicarse?', 'General', 'es', 'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Los políticos deberían someterse a test psicológicos para asumir?', 'General', 'es', 'https://images.unsplash.com/photo-1529107386315-e1a2ed48a620?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿El voto debería ser obligatorio hasta los 70 años?', 'General', 'es', 'https://images.unsplash.com/photo-1541872703-74c5e44368f9?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Las armas deberían estar completamente prohibidas para civiles?', 'General', 'es', 'https://images.unsplash.com/photo-1584461800588-e6e2a11b1b0f?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿La educación universitaria debería ser gratuita en todos los países?', 'General', 'es', 'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿El Estado debería regular el precio de los alquileres?', 'General', 'es', 'https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=600&q=80&fit=crop&h=400'),

  -- Tecnología
  (seed_user, '¿La inteligencia artificial va a reemplazar a la mayoría de los empleos en 20 años?', 'Tech', 'es', 'https://images.unsplash.com/photo-1677442135703-1787eea5ce01?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Deberías poder vender tus datos personales?', 'Tech', 'es', 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Los robots deberían pagar impuestos por los empleos que eliminan?', 'Tech', 'es', 'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Las criptomonedas van a reemplazar al dinero tradicional?', 'Tech', 'es', 'https://images.unsplash.com/photo-1621761191319-c6fb62004040?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Estarías dispuesto/a a tener un chip implantado si mejora tu vida?', 'Tech', 'es', 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿La IA debería tener derechos legales algún día?', 'Tech', 'es', 'https://images.unsplash.com/photo-1531297484001-80022131f5a1?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Los autos sin conductor son más seguros que los humanos?', 'Tech', 'es', 'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Las redes sociales deberían eliminar las cuentas falsas con IA?', 'Tech', 'es', 'https://images.unsplash.com/photo-1611162617213-7d7a39e9b1d7?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿El metaverso va a ser importante en 10 años?', 'Tech', 'es', 'https://images.unsplash.com/photo-1622979135225-d2ba269cf1ac?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Los smartphones nos hacen menos inteligentes?', 'Tech', 'es', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=600&q=80&fit=crop&h=400'),

  -- Comida
  (seed_user, '¿La pizza con ananá es aceptable?', 'Comida', 'es', 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿El asado es la mejor comida del mundo?', 'Comida', 'es', 'https://images.unsplash.com/photo-1529193591184-b1d58069ecdd?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Todo el mundo debería comer menos carne?', 'Comida', 'es', 'https://images.unsplash.com/photo-1607532941433-304659e8198a?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿El sushi es mejor que la hamburguesa?', 'Comida', 'es', 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿El café con leche está subestimado?', 'Comida', 'es', 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Serías vegano/a si fuera fácil?', 'Comida', 'es', 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Los fideos con tuco son la comida perfecta?', 'Comida', 'es', 'https://images.unsplash.com/photo-1551892374-ecf8754cf8b0?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿El mate es superior al café?', 'Comida', 'es', 'https://images.unsplash.com/photo-1568702846914-96b305d2aaeb?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿La milanesa con papas fritas es un plato gourmet?', 'Comida', 'es', 'https://images.unsplash.com/photo-1598103442097-8b74394b95c1?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Preferís picante antes que sin picante?', 'Comida', 'es', 'https://images.unsplash.com/photo-1526318896980-cf78c088247c?w=600&q=80&fit=crop&h=400'),

  -- Animales / Perritos
  (seed_user, '¿Los perros son mejores mascotas que los gatos?', 'General', 'es', 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Deberías poder llevar tu perro al trabajo?', 'Trabajo', 'es', 'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Los animales deberían tener representación legal?', 'General', 'es', 'https://images.unsplash.com/photo-1474511320723-9a56873867b5?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿La experimentación animal debería ser completamente ilegal?', 'General', 'es', 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Los zoos deberían existir?', 'General', 'es', 'https://images.unsplash.com/photo-1564349683136-77e08dba1ef7?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Los perros de raza son mejores que los mestizos?', 'General', 'es', 'https://images.unsplash.com/photo-1561037404-61cd46aa615b?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Gastarías más de $1000 en una cirugía para tu mascota?', 'General', 'es', 'https://images.unsplash.com/photo-1601758003122-53c40e686a19?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Las mascotas exóticas deberían estar permitidas?', 'General', 'es', 'https://images.unsplash.com/photo-1551316679-9c6ae9c76ce7?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Los gatos son animales egocéntricos?', 'General', 'es', 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Hablarle a tu perro como si fuera humano es normal?', 'General', 'es', 'https://images.unsplash.com/photo-1477884213360-7e9d7dcc1e48?w=600&q=80&fit=crop&h=400'),

  -- Viajes
  (seed_user, '¿Preferís playa antes que montaña?', 'General', 'es', 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Viajar solo/a es mejor que en grupo?', 'General', 'es', 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿El avión es la peor parte de cualquier viaje?', 'General', 'es', 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿La Patagonia es el destino más hermoso de Argentina?', 'General', 'es', 'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Preferís hotel 5 estrellas antes que experiencias locales baratas?', 'General', 'es', 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Europa está sobrevalorada como destino turístico?', 'General', 'es', 'https://images.unsplash.com/photo-1499856871958-5b9627545d1a?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿El turismo masivo está destruyendo los destinos naturales?', 'General', 'es', 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Viajarías al espacio si pudieras?', 'General', 'es', 'https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Japón es el país más fascinante del mundo?', 'General', 'es', 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Preferís destinos conocidos antes que lugares poco explorados?', 'General', 'es', 'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=600&q=80&fit=crop&h=400'),

  -- Trabajo y oficina
  (seed_user, '¿Es aceptable revisar el correo del trabajo a las 10pm?', 'Trabajo', 'es', 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿La oficina open space reduce la productividad?', 'Oficina', 'es', 'https://images.unsplash.com/photo-1497366216548-37526070297c?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿El micromanagement es la peor práctica de gestión?', 'Trabajo', 'es', 'https://images.unsplash.com/photo-1552581234-26160f608093?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Deberías poder rechazar reuniones que podrían ser un mail?', 'Trabajo', 'es', 'https://images.unsplash.com/photo-1600880292203-757bb62b4baf?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿El síndrome del impostor afecta a la mayoría de los profesionales?', 'Trabajo', 'es', 'https://images.unsplash.com/photo-1541746972996-4e0b0f43e02a?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Las startups son mejores lugares para trabajar que las corporaciones?', 'Trabajo', 'es', 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿El café gratis en la oficina mejora la productividad?', 'Oficina', 'es', 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Los lunes deberían comenzar a las 10am?', 'Trabajo', 'es', 'https://images.unsplash.com/photo-1506784365847-bbad939e9335?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Deberías poder tomar siestas en el trabajo?', 'Oficina', 'es', 'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿La música en la oficina distrae o ayuda?', 'Oficina', 'es', 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=600&q=80&fit=crop&h=400'),

  -- Entretenimiento y cultura
  (seed_user, '¿Los libros son superiores a las series?', 'General', 'es', 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿El streaming mató al cine?', 'General', 'es', 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Los videojuegos son una forma de arte legítima?', 'General', 'es', 'https://images.unsplash.com/photo-1551103782-8ab07afd45c1?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿El reggaetón es música o ruido?', 'General', 'es', 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Los realities hacen daño a la sociedad?', 'General', 'es', 'https://images.unsplash.com/photo-1611162617213-7d7a39e9b1d7?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Los memes son la expresión cultural de nuestra época?', 'General', 'es', 'https://images.unsplash.com/photo-1545431781-3e1b506e9a37?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿El fútbol está demasiado comercializado?', 'General', 'es', 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿El cine argentino está infravalorado a nivel mundial?', 'General', 'es', 'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Preferís leer en papel antes que en ebook?', 'General', 'es', 'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿TikTok destruyó la capacidad de atención humana?', 'General', 'es', 'https://images.unsplash.com/photo-1611605698335-8b1569810432?w=600&q=80&fit=crop&h=400'),

  -- Medio ambiente
  (seed_user, '¿El cambio climático es la amenaza más urgente del siglo?', 'General', 'es', 'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿La energía nuclear es parte de la solución climática?', 'General', 'es', 'https://images.unsplash.com/photo-1466611653911-95081537e5b7?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Cada persona debería tener un límite anual de vuelos?', 'General', 'es', 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Los autos de gasolina deberían prohibirse antes de 2035?', 'General', 'es', 'https://images.unsplash.com/photo-1593941707882-a5bba13938c4?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿El reciclaje es suficiente o es una ilusión?', 'General', 'es', 'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=600&q=80&fit=crop&h=400'),

  -- Vida y filosofía
  (seed_user, '¿El dinero da la felicidad?', 'General', 'es', 'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿La inteligencia o el esfuerzo: cuál importa más?', 'General', 'es', 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿El matrimonio es una institución obsoleta?', 'General', 'es', 'https://images.unsplash.com/photo-1519741497674-611481863552?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿La amistad online puede ser tan real como la presencial?', 'General', 'es', 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Los 30 son los nuevos 20?', 'General', 'es', 'https://images.unsplash.com/photo-1541963463532-d68292c34b19?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Preferís vivir en ciudad o en el campo?', 'General', 'es', 'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Tener hijos es una elección, no una obligación?', 'General', 'es', 'https://images.unsplash.com/photo-1476703993599-0035a21b17a9?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Es necesario perdonar para sanar?', 'General', 'es', 'https://images.unsplash.com/photo-1499209974431-9dddcece7f88?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿El amor romántico es una construcción social?', 'General', 'es', 'https://images.unsplash.com/photo-1518199266791-5375a83190b7?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿La rutina mata la creatividad?', 'General', 'es', 'https://images.unsplash.com/photo-1456406644174-8ddd4cd52a06?w=600&q=80&fit=crop&h=400'),

  -- Salud
  (seed_user, '¿El sistema de salud público es suficiente?', 'General', 'es', 'https://images.unsplash.com/photo-1538108149393-fbbd81895907?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿La salud mental debería ser prioridad 1 en educación?', 'General', 'es', 'https://images.unsplash.com/photo-1493836512294-502baa1986e2?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿El ejercicio diario debería enseñarse como hábito desde la infancia?', 'General', 'es', 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Las dietas extremas hacen más daño que bien?', 'Comida', 'es', 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿El alcohol debería tener las mismas restricciones que otras drogas?', 'General', 'es', 'https://images.unsplash.com/photo-1474552226712-ac0f0961a954?w=600&q=80&fit=crop&h=400'),

  -- Random divertidos
  (seed_user, '¿La persona que no cierra la heladera es un monstruo?', 'General', 'es', 'https://images.unsplash.com/photo-1584568694244-14fbdf83bd30?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Mojás la galletita en el café?', 'Comida', 'es', 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿El ascensor con una sola persona debería tener música?', 'General', 'es', 'https://images.unsplash.com/photo-1540560260-a5f78b2f7e17?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Es aceptable usar el celular en el baño ajeno?', 'General', 'es', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿La persona que mastica con la boca abierta debería ser multada?', 'General', 'es', 'https://images.unsplash.com/photo-1517093728432-a0440f8d45af?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Los mails con "Espero que estés bien" son molestos?', 'Trabajo', 'es', 'https://images.unsplash.com/photo-1526378722484-bd91ca387e72?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿El pijama es la mejor vestimenta para el home office?', 'Trabajo', 'es', 'https://images.unsplash.com/photo-1586473219010-2ffc57b0d282?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Es aceptable responder con "oke" en lugar de "ok"?', 'General', 'es', 'https://images.unsplash.com/photo-1577563908411-5077b6dc7624?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿La mayonesa en el choripán es un crimen?', 'Comida', 'es', 'https://images.unsplash.com/photo-1529193591184-b1d58069ecdd?w=600&q=80&fit=crop&h=400'),
  (seed_user, '¿Dormir con medias puestas es civilizado?', 'General', 'es', 'https://images.unsplash.com/photo-1541963463532-d68292c34b19?w=600&q=80&fit=crop&h=400');

  -- ============================================================
  -- 100 PREGUNTAS EN INGLÉS
  -- ============================================================
  insert into vote_questions (user_id, text, category, lang, image_url) values

  -- Controversial / Society
  (seed_user, 'Should social media platforms be regulated like utilities?', 'General', 'en', 'https://images.unsplash.com/photo-1611162617213-7d7a39e9b1d7?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is cancel culture doing more harm than good?', 'General', 'en', 'https://images.unsplash.com/photo-1529107386315-e1a2ed48a620?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should voting be mandatory for all citizens?', 'General', 'en', 'https://images.unsplash.com/photo-1541872703-74c5e44368f9?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should the minimum wage be doubled in developed countries?', 'General', 'en', 'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is capitalism the best economic system we have?', 'General', 'en', 'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should all drugs be decriminalized?', 'General', 'en', 'https://images.unsplash.com/photo-1532938911079-1b06ac7ceec7?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should billionaires exist?', 'General', 'en', 'https://images.unsplash.com/photo-1559526324-4b87b5e36e44?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is universal basic income a good idea?', 'General', 'en', 'https://images.unsplash.com/photo-1567427018141-0584cfcbf1b8?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should gun ownership be banned for civilians?', 'General', 'en', 'https://images.unsplash.com/photo-1584461800588-e6e2a11b1b0f?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is the death penalty ever justified?', 'General', 'en', 'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?w=600&q=80&fit=crop&h=400'),

  -- Technology
  (seed_user, 'Will AI replace most jobs in the next 20 years?', 'Tech', 'en', 'https://images.unsplash.com/photo-1677442135703-1787eea5ce01?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should AI-generated art be considered real art?', 'Tech', 'en', 'https://images.unsplash.com/photo-1660616246653-e2c57d1077b9?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Would you get a brain chip if it made you smarter?', 'Tech', 'en', 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Are electric cars actually better for the environment?', 'Tech', 'en', 'https://images.unsplash.com/photo-1593941707882-a5bba13938c4?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should social media age restrictions be strictly enforced?', 'Tech', 'en', 'https://images.unsplash.com/photo-1543765757-f3f3c0ab9e5c?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is TikTok making us less able to focus?', 'Tech', 'en', 'https://images.unsplash.com/photo-1611605698335-8b1569810432?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should tech companies pay much higher taxes?', 'Tech', 'en', 'https://images.unsplash.com/photo-1531297484001-80022131f5a1?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is cryptocurrency the future of money?', 'Tech', 'en', 'https://images.unsplash.com/photo-1621761191319-c6fb62004040?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Would you trust a self-driving car over a human driver?', 'Tech', 'en', 'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should AI have legal rights someday?', 'Tech', 'en', 'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=600&q=80&fit=crop&h=400'),

  -- Food
  (seed_user, 'Is pineapple on pizza acceptable?', 'Comida', 'en', 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is breakfast the most important meal of the day?', 'Comida', 'en', 'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should everyone eat less meat for the environment?', 'Comida', 'en', 'https://images.unsplash.com/photo-1607532941433-304659e8198a?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is sushi better than a burger?', 'Comida', 'en', 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is coffee overrated?', 'Comida', 'en', 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Would you go vegan if it were easy?', 'Comida', 'en', 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is spicy food superior to mild food?', 'Comida', 'en', 'https://images.unsplash.com/photo-1526318896980-cf78c088247c?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should fast food be taxed more heavily?', 'Comida', 'en', 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is a hot dog a sandwich?', 'Comida', 'en', 'https://images.unsplash.com/photo-1612392062631-94c2f83e9eb4?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is cereal a type of soup?', 'Comida', 'en', 'https://images.unsplash.com/photo-1517093728432-a0440f8d45af?w=600&q=80&fit=crop&h=400'),

  -- Dogs, cats & animals
  (seed_user, 'Are dogs better pets than cats?', 'General', 'en', 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should pets be allowed in all workplaces?', 'Trabajo', 'en', 'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should zoos exist?', 'General', 'en', 'https://images.unsplash.com/photo-1564349683136-77e08dba1ef7?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Would you spend over $5,000 on surgery for your pet?', 'General', 'en', 'https://images.unsplash.com/photo-1601758003122-53c40e686a19?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Are cats secretly plotting against us?', 'General', 'en', 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should exotic animals be kept as pets?', 'General', 'en', 'https://images.unsplash.com/photo-1551316679-9c6ae9c76ce7?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is animal testing ever ethical?', 'General', 'en', 'https://images.unsplash.com/photo-1474511320723-9a56873867b5?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Do you talk to your pets like they understand you?', 'General', 'en', 'https://images.unsplash.com/photo-1477884213360-7e9d7dcc1e48?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should purebred dogs be banned to encourage adoption?', 'General', 'en', 'https://images.unsplash.com/photo-1561037404-61cd46aa615b?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Are emotional support animals a valid need?', 'General', 'en', 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600&q=80&fit=crop&h=400'),

  -- Travel
  (seed_user, 'Do you prefer beach over mountains?', 'General', 'en', 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is solo travel better than group travel?', 'General', 'en', 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is flying the worst part of any trip?', 'General', 'en', 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is Europe overrated as a tourist destination?', 'General', 'en', 'https://images.unsplash.com/photo-1499856871958-5b9627545d1a?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Would you travel to space if you could?', 'General', 'en', 'https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is Japan the most fascinating country in the world?', 'General', 'en', 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is mass tourism destroying natural destinations?', 'General', 'en', 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Do you prefer luxury hotels or local guesthouses?', 'General', 'en', 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should everyone take at least one big trip in their lifetime?', 'General', 'en', 'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is working remotely from another country the ultimate lifestyle?', 'Trabajo', 'en', 'https://images.unsplash.com/photo-1501856851467-7b3acf7c3b35?w=600&q=80&fit=crop&h=400'),

  -- Work & Office
  (seed_user, 'Is checking work emails at 10pm acceptable?', 'Trabajo', 'en', 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should the 4-day work week be the global standard?', 'Trabajo', 'en', 'https://images.unsplash.com/photo-1506784365847-bbad939e9335?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is remote work more productive than office work?', 'Trabajo', 'en', 'https://images.unsplash.com/photo-1586473219010-2ffc57b0d282?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should you be able to decline meetings that could be emails?', 'Trabajo', 'en', 'https://images.unsplash.com/photo-1600880292203-757bb62b4baf?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is micromanagement the worst management style?', 'Trabajo', 'en', 'https://images.unsplash.com/photo-1552581234-26160f608093?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should naps at work be encouraged?', 'Oficina', 'en', 'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Does free coffee at the office actually improve productivity?', 'Oficina', 'en', 'https://images.unsplash.com/photo-1497366216548-37526070297c?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should Mondays start at 10am?', 'Trabajo', 'en', 'https://images.unsplash.com/photo-1541746972996-4e0b0f43e02a?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is the open office layout killing deep work?', 'Oficina', 'en', 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Does imposter syndrome affect most professionals?', 'Trabajo', 'en', 'https://images.unsplash.com/photo-1573496799652-408c2ac9fe98?w=600&q=80&fit=crop&h=400'),

  -- Entertainment & Culture
  (seed_user, 'Are books better than TV series?', 'General', 'en', 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Has streaming killed the cinema experience?', 'General', 'en', 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Are video games a legitimate art form?', 'General', 'en', 'https://images.unsplash.com/photo-1551103782-8ab07afd45c1?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should reality TV be banned?', 'General', 'en', 'https://images.unsplash.com/photo-1593784991095-a205069470b6?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Are memes the cultural expression of our era?', 'General', 'en', 'https://images.unsplash.com/photo-1545431781-3e1b506e9a37?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is Marvel domination ruining cinema quality?', 'General', 'en', 'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should music streaming services pay artists more?', 'General', 'en', 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Do you prefer reading on paper or e-reader?', 'General', 'en', 'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Are sports leagues too commercialized?', 'General', 'en', 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is nostalgia stopping us from creating truly original content?', 'General', 'en', 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=600&q=80&fit=crop&h=400'),

  -- Environment
  (seed_user, 'Is climate change the most urgent threat of this century?', 'General', 'en', 'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should nuclear energy be part of the climate solution?', 'General', 'en', 'https://images.unsplash.com/photo-1466611653911-95081537e5b7?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should each person have an annual flight limit?', 'General', 'en', 'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should gasoline cars be banned before 2035?', 'General', 'en', 'https://images.unsplash.com/photo-1593941707882-a5bba13938c4?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is recycling enough, or is it just performative?', 'General', 'en', 'https://images.unsplash.com/photo-1532938911079-1b06ac7ceec7?w=600&q=80&fit=crop&h=400'),

  -- Life & Philosophy
  (seed_user, 'Does money buy happiness?', 'General', 'en', 'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is effort more important than natural talent?', 'General', 'en', 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is marriage an outdated institution?', 'General', 'en', 'https://images.unsplash.com/photo-1519741497674-611481863552?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Can online friendships be as real as in-person ones?', 'General', 'en', 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Are your 30s better than your 20s?', 'General', 'en', 'https://images.unsplash.com/photo-1541963463532-d68292c34b19?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Do you prefer city life or countryside living?', 'General', 'en', 'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is having children a choice, not an obligation?', 'General', 'en', 'https://images.unsplash.com/photo-1476703993599-0035a21b17a9?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is forgiveness necessary for healing?', 'General', 'en', 'https://images.unsplash.com/photo-1499209974431-9dddcece7f88?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is romantic love a social construct?', 'General', 'en', 'https://images.unsplash.com/photo-1518199266791-5375a83190b7?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Does daily routine kill creativity?', 'General', 'en', 'https://images.unsplash.com/photo-1456406644174-8ddd4cd52a06?w=600&q=80&fit=crop&h=400'),

  -- Health
  (seed_user, 'Should mental health days be officially recognized at work?', 'Trabajo', 'en', 'https://images.unsplash.com/photo-1493836512294-502baa1986e2?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is the healthcare system in most countries good enough?', 'General', 'en', 'https://images.unsplash.com/photo-1538108149393-fbbd81895907?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should junk food ads targeting kids be banned?', 'General', 'en', 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Do extreme diets do more harm than good?', 'Comida', 'en', 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should alcohol have the same restrictions as other drugs?', 'General', 'en', 'https://images.unsplash.com/photo-1474552226712-ac0f0961a954?w=600&q=80&fit=crop&h=400'),

  -- Fun & Random
  (seed_user, 'Is a person who leaves the fridge door open a monster?', 'General', 'en', 'https://images.unsplash.com/photo-1584568694244-14fbdf83bd30?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Do you dip cookies in your coffee?', 'Comida', 'en', 'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should elevators play music when there is only one person inside?', 'General', 'en', 'https://images.unsplash.com/photo-1540560260-a5f78b2f7e17?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is it okay to use your phone in the bathroom at someone else house?', 'General', 'en', 'https://images.unsplash.com/photo-1577563908411-5077b6dc7624?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should people who chew loudly be fined?', 'General', 'en', 'https://images.unsplash.com/photo-1517093728432-a0440f8d45af?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Are "Hope this email finds you well" openers annoying?', 'Trabajo', 'en', 'https://images.unsplash.com/photo-1526378722484-bd91ca387e72?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is pajamas the best outfit for working from home?', 'Trabajo', 'en', 'https://images.unsplash.com/photo-1606214174585-fe31582dc6ee?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should replying "k" instead of "ok" be socially acceptable?', 'General', 'en', 'https://images.unsplash.com/photo-1611532736597-de2d4265fba3?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Is a grilled cheese sandwich the perfect comfort food?', 'Comida', 'en', 'https://images.unsplash.com/photo-1528736235302-52922df5c122?w=600&q=80&fit=crop&h=400'),
  (seed_user, 'Should sleeping with socks on be normalized?', 'General', 'en', 'https://images.unsplash.com/photo-1541963463532-d68292c34b19?w=600&q=80&fit=crop&h=400');

  raise notice 'Seed completado: 200 preguntas con imagenes insertadas para user %', seed_user;
end;
$$;
