-- ================================================================
-- SEED: 100 preguntas en español + 100 en inglés
-- Reemplaza 'TU_USER_ID_AQUI' con tu UUID de auth.users
-- O usa la subquery comentada al final para auto-detectar
-- ================================================================

-- OPCIÓN 1: Pegar tu UUID manualmente
-- do $$ declare seed_user uuid := 'TU_USER_ID_AQUI'; ...

-- OPCIÓN 2: Script dinámico (toma el primer usuario registrado)
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
  insert into vote_questions (user_id, text, category, lang) values
  -- Polémica / Sociedad
  (seed_user, '¿Debería el aborto ser legal en toda América Latina?', 'General', 'es'),
  (seed_user, '¿Las redes sociales hacen más daño que bien a la sociedad?', 'General', 'es'),
  (seed_user, '¿El trabajo remoto debería ser un derecho universal?', 'Trabajo', 'es'),
  (seed_user, '¿La semana laboral de 4 días debería ser obligatoria?', 'Trabajo', 'es'),
  (seed_user, '¿El salario mínimo debería duplicarse?', 'General', 'es'),
  (seed_user, '¿Los políticos deberían someterse a test psicológicos para asumir?', 'General', 'es'),
  (seed_user, '¿El voto debería ser obligatorio hasta los 70 años?', 'General', 'es'),
  (seed_user, '¿Las armas deberían estar completamente prohibidas para civiles?', 'General', 'es'),
  (seed_user, '¿La educación universitaria debería ser gratuita en todos los países?', 'General', 'es'),
  (seed_user, '¿El Estado debería regular el precio de los alquileres?', 'General', 'es'),
  -- Tecnología
  (seed_user, '¿La inteligencia artificial va a reemplazar a la mayoría de los empleos en 20 años?', 'Tech', 'es'),
  (seed_user, '¿Deberías poder vender tus datos personales?', 'Tech', 'es'),
  (seed_user, '¿Los robots deberían pagar impuestos por los empleos que eliminan?', 'Tech', 'es'),
  (seed_user, '¿Las criptomonedas van a reemplazar al dinero tradicional?', 'Tech', 'es'),
  (seed_user, '¿Estarías dispuesto/a a tener un chip implantado si mejora tu vida?', 'Tech', 'es'),
  (seed_user, '¿La IA debería tener derechos legales algún día?', 'Tech', 'es'),
  (seed_user, '¿Los autos sin conductor son más seguros que los humanos?', 'Tech', 'es'),
  (seed_user, '¿Las redes sociales deberían eliminar las cuentas falsas con IA?', 'Tech', 'es'),
  (seed_user, '¿El metaverso va a ser importante en 10 años?', 'Tech', 'es'),
  (seed_user, '¿Los smartphones nos hacen menos inteligentes?', 'Tech', 'es'),
  -- Comida
  (seed_user, '¿La pizza con ananá es aceptable?', 'Comida', 'es'),
  (seed_user, '¿El asado es la mejor comida del mundo?', 'Comida', 'es'),
  (seed_user, '¿Todo el mundo debería comer menos carne?', 'Comida', 'es'),
  (seed_user, '¿El sushi es mejor que la hamburguesa?', 'Comida', 'es'),
  (seed_user, '¿El café con leche está subestimado?', 'Comida', 'es'),
  (seed_user, '¿Serías vegano/a si fuera fácil?', 'Comida', 'es'),
  (seed_user, '¿Los fideos con tuco son la comida perfecta?', 'Comida', 'es'),
  (seed_user, '¿El mate es superior al café?', 'Comida', 'es'),
  (seed_user, '¿La milanesa con papas fritas es un plato gourmet?', 'Comida', 'es'),
  (seed_user, '¿Preferís picante antes que sin picante?', 'Comida', 'es'),
  -- Perritos y animales
  (seed_user, '¿Los perros son mejores mascotas que los gatos?', 'General', 'es'),
  (seed_user, '¿Deberías poder llevar tu perro al trabajo?', 'Trabajo', 'es'),
  (seed_user, '¿Los animales deberían tener representación legal?', 'General', 'es'),
  (seed_user, '¿La experimentación animal debería ser completamente ilegal?', 'General', 'es'),
  (seed_user, '¿Los zoos deberían existir?', 'General', 'es'),
  (seed_user, '¿Los perros de raza son mejores que los mestizos?', 'General', 'es'),
  (seed_user, '¿Gastarías más de $1000 en una cirugía para tu mascota?', 'General', 'es'),
  (seed_user, '¿Las mascotas exóticas deberían estar permitidas?', 'General', 'es'),
  (seed_user, '¿Los gatos son animales egocéntricos?', 'General', 'es'),
  (seed_user, '¿Hablarle a tu perro como si fuera humano es normal?', 'General', 'es'),
  -- Viajes
  (seed_user, '¿Preferís playa antes que montaña?', 'General', 'es'),
  (seed_user, '¿Viajar solo/a es mejor que en grupo?', 'General', 'es'),
  (seed_user, '¿El avión es la peor parte de cualquier viaje?', 'General', 'es'),
  (seed_user, '¿La Patagonia es el destino más hermoso de Argentina?', 'General', 'es'),
  (seed_user, '¿Preferís hotel 5 estrellas antes que experiencias locales baratas?', 'General', 'es'),
  (seed_user, '¿Europa está sobrevalorada como destino turístico?', 'General', 'es'),
  (seed_user, '¿El turismo masivo está destruyendo los destinos naturales?', 'General', 'es'),
  (seed_user, '¿Viajarías al espacio si pudieras?', 'General', 'es'),
  (seed_user, '¿Japón es el país más fascinante del mundo?', 'General', 'es'),
  (seed_user, '¿Preferís destinos conocidos antes que lugares poco explorados?', 'General', 'es'),
  -- Trabajo y oficina
  (seed_user, '¿Es aceptable revisar el correo del trabajo a las 10pm?', 'Trabajo', 'es'),
  (seed_user, '¿La oficina open space reduce la productividad?', 'Oficina', 'es'),
  (seed_user, '¿El micromanagement es la peor práctica de gestión?', 'Trabajo', 'es'),
  (seed_user, '¿Deberías poder rechazar reuniones que podrían ser un mail?', 'Trabajo', 'es'),
  (seed_user, '¿El síndrome del impostor afecta a la mayoría de los profesionales?', 'Trabajo', 'es'),
  (seed_user, '¿Las startups son mejores lugares para trabajar que las corporaciones?', 'Trabajo', 'es'),
  (seed_user, '¿El café gratis en la oficina mejora la productividad?', 'Oficina', 'es'),
  (seed_user, '¿Los lunes deberían comenzar a las 10am?', 'Trabajo', 'es'),
  (seed_user, '¿Deberías poder tomar siestas en el trabajo?', 'Oficina', 'es'),
  (seed_user, '¿La música en la oficina distrae o ayuda?', 'Oficina', 'es'),
  -- Entretenimiento y cultura
  (seed_user, '¿Los libros son superiores a las series?', 'General', 'es'),
  (seed_user, '¿El streaming mató al cine?', 'General', 'es'),
  (seed_user, '¿Los videojuegos son una forma de arte legítima?', 'General', 'es'),
  (seed_user, '¿El reggaetón es música o ruido?', 'General', 'es'),
  (seed_user, '¿Los realities hacen daño a la sociedad?', 'General', 'es'),
  (seed_user, '¿Los memes son la expresión cultural de nuestra época?', 'General', 'es'),
  (seed_user, '¿El fútbol está demasiado comercializado?', 'General', 'es'),
  (seed_user, '¿El cine argentino está infravalorado a nivel mundial?', 'General', 'es'),
  (seed_user, '¿Preferís leer en papel antes que en ebook?', 'General', 'es'),
  (seed_user, '¿TikTok destruyó la capacidad de atención humana?', 'General', 'es'),
  -- Medio ambiente
  (seed_user, '¿El cambio climático es la amenaza más urgente del siglo?', 'General', 'es'),
  (seed_user, '¿La energía nuclear es parte de la solución climática?', 'General', 'es'),
  (seed_user, '¿Cada persona debería tener un límite anual de vuelos?', 'General', 'es'),
  (seed_user, '¿Los autos de gasolina deberían prohibirse antes de 2035?', 'General', 'es'),
  (seed_user, '¿El reciclaje es suficiente o es una ilusión?', 'General', 'es'),
  -- Vida y filosofía
  (seed_user, '¿El dinero da la felicidad?', 'General', 'es'),
  (seed_user, '¿La inteligencia o el esfuerzo: cuál importa más?', 'General', 'es'),
  (seed_user, '¿El matrimonio es una institución obsoleta?', 'General', 'es'),
  (seed_user, '¿La amistad online puede ser tan real como la presencial?', 'General', 'es'),
  (seed_user, '¿Los 30 son los nuevos 20?', 'General', 'es'),
  (seed_user, '¿Preferís vivir en ciudad o en el campo?', 'General', 'es'),
  (seed_user, '¿Tener hijos es una elección, no una obligación?', 'General', 'es'),
  (seed_user, '¿Es necesario perdonar para sanar?', 'General', 'es'),
  (seed_user, '¿El amor romántico es una construcción social?', 'General', 'es'),
  (seed_user, '¿La rutina mata la creatividad?', 'General', 'es'),
  -- Salud
  (seed_user, '¿El sistema de salud público es suficiente?', 'General', 'es'),
  (seed_user, '¿La salud mental debería ser prioridad 1 en educación?', 'General', 'es'),
  (seed_user, '¿El ejercicio diario debería enseñarse como hábito desde la infancia?', 'General', 'es'),
  (seed_user, '¿Las dietas extremas hacen más daño que bien?', 'Comida', 'es'),
  (seed_user, '¿El alcohol debería tener las mismas restricciones que otras drogas?', 'General', 'es'),
  -- Random divertidos
  (seed_user, '¿La persona que no cierra la heladera es un monstruo?', 'General', 'es'),
  (seed_user, '¿Mojás la galletita en el café?', 'Comida', 'es'),
  (seed_user, '¿El ascensor con una sola persona debería tener música?', 'General', 'es'),
  (seed_user, '¿Es aceptable usar el celular en el baño ajeno?', 'General', 'es'),
  (seed_user, '¿La persona que mastica con la boca abierta debería ser multada?', 'General', 'es'),
  (seed_user, '¿Los mails con "Espero que estés bien" son molestos?', 'Trabajo', 'es'),
  (seed_user, '¿El pijama es la mejor vestimenta para el home office?', 'Trabajo', 'es'),
  (seed_user, '¿Es aceptable responder con "oke" en lugar de "ok"?', 'General', 'es'),
  (seed_user, '¿La mayonesa en el choripán es un crimen?', 'Comida', 'es'),
  (seed_user, '¿Dormir con medias puestas es civilizado?', 'General', 'es');

  -- ============================================================
  -- 100 PREGUNTAS EN INGLÉS
  -- ============================================================
  insert into vote_questions (user_id, text, category, lang) values
  -- Controversial / Society
  (seed_user, 'Should social media platforms be regulated like utilities?', 'General', 'en'),
  (seed_user, 'Is cancel culture doing more harm than good?', 'General', 'en'),
  (seed_user, 'Should voting be mandatory for all citizens?', 'General', 'en'),
  (seed_user, 'Should the minimum wage be doubled in developed countries?', 'General', 'en'),
  (seed_user, 'Is capitalism the best economic system we have?', 'General', 'en'),
  (seed_user, 'Should all drugs be decriminalized?', 'General', 'en'),
  (seed_user, 'Should billionaires exist?', 'General', 'en'),
  (seed_user, 'Is universal basic income a good idea?', 'General', 'en'),
  (seed_user, 'Should gun ownership be banned for civilians?', 'General', 'en'),
  (seed_user, 'Is the death penalty ever justified?', 'General', 'en'),
  -- Technology
  (seed_user, 'Will AI replace most jobs in the next 20 years?', 'Tech', 'en'),
  (seed_user, 'Should AI-generated art be considered real art?', 'Tech', 'en'),
  (seed_user, 'Would you get a brain chip if it made you smarter?', 'Tech', 'en'),
  (seed_user, 'Are electric cars actually better for the environment?', 'Tech', 'en'),
  (seed_user, 'Should social media age restrictions be strictly enforced?', 'Tech', 'en'),
  (seed_user, 'Is TikTok making us less able to focus?', 'Tech', 'en'),
  (seed_user, 'Should tech companies pay much higher taxes?', 'Tech', 'en'),
  (seed_user, 'Is cryptocurrency the future of money?', 'Tech', 'en'),
  (seed_user, 'Would you trust a self-driving car over a human driver?', 'Tech', 'en'),
  (seed_user, 'Should AI have legal rights someday?', 'Tech', 'en'),
  -- Food
  (seed_user, 'Is pineapple on pizza acceptable?', 'Comida', 'en'),
  (seed_user, 'Is breakfast the most important meal of the day?', 'Comida', 'en'),
  (seed_user, 'Should everyone eat less meat for the environment?', 'Comida', 'en'),
  (seed_user, 'Is sushi better than a burger?', 'Comida', 'en'),
  (seed_user, 'Is coffee overrated?', 'Comida', 'en'),
  (seed_user, 'Would you go vegan if it were easy?', 'Comida', 'en'),
  (seed_user, 'Is spicy food superior to mild food?', 'Comida', 'en'),
  (seed_user, 'Should fast food be taxed more heavily?', 'Comida', 'en'),
  (seed_user, 'Is a hot dog a sandwich?', 'Comida', 'en'),
  (seed_user, 'Is cereal a type of soup?', 'Comida', 'en'),
  -- Dogs, cats & animals
  (seed_user, 'Are dogs better pets than cats?', 'General', 'en'),
  (seed_user, 'Should pets be allowed in all workplaces?', 'Trabajo', 'en'),
  (seed_user, 'Should zoos exist?', 'General', 'en'),
  (seed_user, 'Would you spend over $5,000 on surgery for your pet?', 'General', 'en'),
  (seed_user, 'Are cats secretly plotting against us?', 'General', 'en'),
  (seed_user, 'Should exotic animals be kept as pets?', 'General', 'en'),
  (seed_user, 'Is animal testing ever ethical?', 'General', 'en'),
  (seed_user, 'Do you talk to your pets like they understand you?', 'General', 'en'),
  (seed_user, 'Should purebred dogs be banned to encourage adoption?', 'General', 'en'),
  (seed_user, 'Are emotional support animals a valid need?', 'General', 'en'),
  -- Travel
  (seed_user, 'Do you prefer beach over mountains?', 'General', 'en'),
  (seed_user, 'Is solo travel better than group travel?', 'General', 'en'),
  (seed_user, 'Is flying the worst part of any trip?', 'General', 'en'),
  (seed_user, 'Is Europe overrated as a tourist destination?', 'General', 'en'),
  (seed_user, 'Would you travel to space if you could?', 'General', 'en'),
  (seed_user, 'Is Japan the most fascinating country in the world?', 'General', 'en'),
  (seed_user, 'Is mass tourism destroying natural destinations?', 'General', 'en'),
  (seed_user, 'Do you prefer luxury hotels or local guesthouses?', 'General', 'en'),
  (seed_user, 'Should everyone take at least one big trip in their lifetime?', 'General', 'en'),
  (seed_user, 'Is working remotely from another country the ultimate lifestyle?', 'Trabajo', 'en'),
  -- Work & Office
  (seed_user, 'Is checking work emails at 10pm acceptable?', 'Trabajo', 'en'),
  (seed_user, 'Should the 4-day work week be the global standard?', 'Trabajo', 'en'),
  (seed_user, 'Is remote work more productive than office work?', 'Trabajo', 'en'),
  (seed_user, 'Should you be able to decline meetings that could be emails?', 'Trabajo', 'en'),
  (seed_user, 'Is micromanagement the worst management style?', 'Trabajo', 'en'),
  (seed_user, 'Should naps at work be encouraged?', 'Oficina', 'en'),
  (seed_user, 'Does free coffee at the office actually improve productivity?', 'Oficina', 'en'),
  (seed_user, 'Should Mondays start at 10am?', 'Trabajo', 'en'),
  (seed_user, 'Is the open office layout killing deep work?', 'Oficina', 'en'),
  (seed_user, 'Does imposter syndrome affect most professionals?', 'Trabajo', 'en'),
  -- Entertainment & Culture
  (seed_user, 'Are books better than TV series?', 'General', 'en'),
  (seed_user, 'Has streaming killed the cinema experience?', 'General', 'en'),
  (seed_user, 'Are video games a legitimate art form?', 'General', 'en'),
  (seed_user, 'Should reality TV be banned?', 'General', 'en'),
  (seed_user, 'Are memes the cultural expression of our era?', 'General', 'en'),
  (seed_user, 'Is Marvel domination ruining cinema quality?', 'General', 'en'),
  (seed_user, 'Should music streaming services pay artists more?', 'General', 'en'),
  (seed_user, 'Do you prefer reading on paper or e-reader?', 'General', 'en'),
  (seed_user, 'Are sports leagues too commercialized?', 'General', 'en'),
  (seed_user, 'Is nostalgia stopping us from creating truly original content?', 'General', 'en'),
  -- Environment
  (seed_user, 'Is climate change the most urgent threat of this century?', 'General', 'en'),
  (seed_user, 'Should nuclear energy be part of the climate solution?', 'General', 'en'),
  (seed_user, 'Should each person have an annual flight limit?', 'General', 'en'),
  (seed_user, 'Should gasoline cars be banned before 2035?', 'General', 'en'),
  (seed_user, 'Is recycling enough, or is it just performative?', 'General', 'en'),
  -- Life & Philosophy
  (seed_user, 'Does money buy happiness?', 'General', 'en'),
  (seed_user, 'Is effort more important than natural talent?', 'General', 'en'),
  (seed_user, 'Is marriage an outdated institution?', 'General', 'en'),
  (seed_user, 'Can online friendships be as real as in-person ones?', 'General', 'en'),
  (seed_user, 'Are your 30s better than your 20s?', 'General', 'en'),
  (seed_user, 'Do you prefer city life or countryside living?', 'General', 'en'),
  (seed_user, 'Is having children a choice, not an obligation?', 'General', 'en'),
  (seed_user, 'Is forgiveness necessary for healing?', 'General', 'en'),
  (seed_user, 'Is romantic love a social construct?', 'General', 'en'),
  (seed_user, 'Does daily routine kill creativity?', 'General', 'en'),
  -- Health
  (seed_user, 'Should mental health days be officially recognized at work?', 'Trabajo', 'en'),
  (seed_user, 'Is the healthcare system in most countries good enough?', 'General', 'en'),
  (seed_user, 'Should junk food ads targeting kids be banned?', 'General', 'en'),
  (seed_user, 'Do extreme diets do more harm than good?', 'Comida', 'en'),
  (seed_user, 'Should alcohol have the same restrictions as other drugs?', 'General', 'en'),
  -- Fun & Random
  (seed_user, 'Is a person who leaves the fridge door open a monster?', 'General', 'en'),
  (seed_user, 'Do you dip cookies in your coffee?', 'Comida', 'en'),
  (seed_user, 'Should elevators play music when there is only one person inside?', 'General', 'en'),
  (seed_user, 'Is it okay to use your phone in the bathroom at someone else house?', 'General', 'en'),
  (seed_user, 'Should people who chew loudly be fined?', 'General', 'en'),
  (seed_user, 'Are "Hope this email finds you well" openers annoying?', 'Trabajo', 'en'),
  (seed_user, 'Is pajamas the best outfit for working from home?', 'Trabajo', 'en'),
  (seed_user, 'Should replying "k" instead of "ok" be socially acceptable?', 'General', 'en'),
  (seed_user, 'Is a grilled cheese sandwich the perfect comfort food?', 'Comida', 'en'),
  (seed_user, 'Should sleeping with socks on be normalized?', 'General', 'en');

  raise notice 'Seed completado: 200 preguntas insertadas para user %', seed_user;
end;
$$;
