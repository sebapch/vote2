import { createI18n } from 'vue-i18n';

const messages = {
    es: {
        nav: {
            feed: 'Votar',
            results: 'Resultados',
            profile: 'Perfil'
        },
        feed: {
            empty: 'No hay más preguntas por ahora',
            reloading: 'Recargando...'
        },
        results: {
            title: 'Resultados',
            count: '{n} preguntas',
            empty: 'Sin resultados aún',
            voted: '{n} v.',
            yes: 'Sí',
            no: 'No',
            winning: '🔥 Ganás',
            losing: '😬 Perdés',
            no_votes: 'Sin votos',
            view_profile: 'Ver perfil'
        },
        profile: {
            hello: 'Hola, {name}',
            logout: 'Cerrar Sesión',
            stats: {
                total_votes: 'Votos totales',
                questions: 'Preguntas'
            },
            history: {
                title: 'Actividad Reciente',
                count: '{n} items',
                voted_yes: 'Votaste SÍ',
                voted_no: 'Votaste NO',
                empty: 'Sin actividad previa'
            }
        },
        create: {
            title: 'Nueva pregunta',
            placeholder: '¿Debería el teletrabajo ser un derecho universal?',
            image_label: 'Agregar imagen',
            image_hint: 'Arrastra, pega o toca para subir',
            submit: 'Publicar',
            uploading: 'Publicando...',
            image_compressed: 'WebP comprimido'
        },
        public_profile: {
            questions: 'Votaciones',
            votes_received: 'Votos recibidos',
            avg_yes: 'Promedio Sí',
            created_label: 'Votaciones creadas',
            empty: 'Sin votaciones creadas',
            default_name: 'Usuario'
        },
        login: {
            title: 'Toma el control',
            subtitle: 'Únete a la comunidad para votar y proponer nuevas ideas de forma anónima y segura.',
            google: 'Entrar con Google'
        },
        app: {
            loading: 'Cargando',
            syncing: 'Sincronizando'
        },
        categories: {
            general: 'General',
            trabajo: 'Trabajo',
            comida: 'Comida',
            oficina: 'Oficina',
            tech: 'Tech'
        },
        onboarding: {
            welcome: '¡Bienvenido a VOTE!',
            step1: 'Desliza a la derecha para SI, a la izquierda para NO.',
            step2: 'Crea tus propias preguntas con el botón central.',
            step3: 'Mira los resultados en tiempo real de toda la comunidad.',
            finish: '¡Empezar!'
        },
        report: {
            button: 'Denunciar',
            confirm: '¿Denunciar esta pregunta como inapropiada?',
            done: 'Denuncia enviada',
            already: 'Ya denunciaste esta pregunta',
            tooltip: 'Contenido inapropiado'
        }
    },
    en: {
        nav: {
            feed: 'Vote',
            results: 'Results',
            profile: 'Profile'
        },
        feed: {
            empty: 'No more questions for now',
            reloading: 'Reloading...'
        },
        results: {
            title: 'Results',
            count: '{n} questions',
            empty: 'No results yet',
            voted: '{n} v.',
            yes: 'Yes',
            no: 'No',
            winning: '🔥 Winning',
            losing: '😬 Losing',
            no_votes: 'No votes',
            view_profile: 'View profile'
        },
        profile: {
            hello: 'Hello, {name}',
            logout: 'Log Out',
            stats: {
                total_votes: 'Total Votes',
                questions: 'Questions'
            },
            history: {
                title: 'Recent Activity',
                count: '{n} items',
                voted_yes: 'You voted YES',
                voted_no: 'You voted NO',
                empty: 'No previous activity'
            }
        },
        create: {
            title: 'New question',
            placeholder: 'Should remote work be a universal right?',
            image_label: 'Add image',
            image_hint: 'Drag, paste or tap to upload',
            submit: 'Post',
            uploading: 'Posting...',
            image_compressed: 'Compressed WebP'
        },
        public_profile: {
            questions: 'Polls',
            votes_received: 'Votes received',
            avg_yes: 'Average Yes',
            created_label: 'Created polls',
            empty: 'No polls created',
            default_name: 'User'
        },
        login: {
            title: 'Take control',
            subtitle: 'Join the community to vote and propose new ideas anonymously and securely.',
            google: 'Sign in with Google'
        },
        app: {
            loading: 'Loading',
            syncing: 'Syncing'
        },
        categories: {
            general: 'General',
            trabajo: 'Work',
            comida: 'Food',
            oficina: 'Office',
            tech: 'Tech'
        },
        onboarding: {
            welcome: 'Welcome to VOTE!',
            step1: 'Swipe right for YES, left for NO.',
            step2: 'Create your own questions with the center button.',
            step3: 'See real-time results from the entire community.',
            finish: 'Get Started!'
        },
        report: {
            button: 'Report',
            confirm: 'Report this question as inappropriate?',
            done: 'Report submitted',
            already: 'You already reported this question',
            tooltip: 'Inappropriate content'
        }
    }
}

const detectLanguage = () => {
    const lang = navigator.language || navigator.userLanguage;
    return lang.startsWith('es') ? 'es' : 'en';
};

const i18n = createI18n({
    legacy: false,
    locale: detectLanguage(),
    fallbackLocale: 'en',
    messages,
});

export default i18n;
