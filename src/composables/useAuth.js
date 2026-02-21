import { ref, watch } from 'vue'
import { supabase } from '../lib/supabase'

// Module-level state — shared across all components
const user = ref(null)
const profile = ref(null)
const authInitialized = ref(false)

// Function to fetch or create profile
const fetchProfile = async (userId) => {
    if (!userId) return
    const { data, error } = await supabase
        .from('vote_profiles')
        .select('*')
        .eq('id', userId)
        .single()

    if (!error && data) {
        profile.value = data
    }
}

// Initialize auth ONCE at module load time
supabase.auth.getSession().then(({ data }) => {
    user.value = data.session?.user ?? null
    if (user.value) fetchProfile(user.value.id)
    authInitialized.value = true
})

// Listen for auth state changes (login / logout / token refresh)
supabase.auth.onAuthStateChange((_event, session) => {
    const newUser = session?.user ?? null
    if (newUser?.id !== user.value?.id) {
        if (newUser) fetchProfile(newUser.id)
        else profile.value = null
    }
    user.value = newUser
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
        profile.value = null
    }

    const completeOnboarding = async () => {
        if (!user.value) return
        const { error } = await supabase
            .from('vote_profiles')
            .update({ onboarding_completed: true })
            .eq('id', user.value.id)

        if (!error) {
            if (profile.value) profile.value.onboarding_completed = true
        }
    }

    return { user, profile, authInitialized, loginWithGoogle, logout, completeOnboarding }
}
