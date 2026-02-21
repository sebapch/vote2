import { ref } from 'vue'
import { supabase } from '../lib/supabase'

// Module-level state — shared across all components
const user = ref(null)
const authInitialized = ref(false)

// Initialize auth ONCE at module load time
supabase.auth.getSession().then(({ data }) => {
    user.value = data.session?.user ?? null
    authInitialized.value = true
})

// Listen for auth state changes (login / logout / token refresh)
supabase.auth.onAuthStateChange((_event, session) => {
    user.value = session?.user ?? null
    authInitialized.value = true
})

export function useAuth() {
    const loginWithGoogle = async () => {
        await supabase.auth.signInWithOAuth({
            provider: 'google',
            options: { redirectTo: window.location.origin }
        })
    }

    const logout = async () => {
        await supabase.auth.signOut()
        user.value = null
    }

    return { user, authInitialized, loginWithGoogle, logout }
}
