import { ref, computed } from 'vue'
import { supabase } from '../lib/supabase'
import { useAuth } from './useAuth'
import i18n from '../i18n'

const { user } = useAuth()

// Module-level shared data state
const questions = ref([])
const userVotes = ref([])
const userCreatedCount = ref(0)
const loading = ref(false)

export function useVoteData() {
    const profileHistory = computed(() =>
        userVotes.value
            .map(uv => {
                const q = questions.value.find(q => q.id === uv.question_id)
                return q ? { ...q, userChoice: uv.vote_type } : null
            })
            .filter(Boolean)
            .reverse()
    )

    const unvotedQuestions = computed(() => {
        const votedIds = new Set(userVotes.value.map(v => v.question_id))
        return questions.value.filter(q => !votedIds.has(q.id))
    })

    const fetchData = async () => {
        if (!user.value || loading.value) return
        loading.value = true
        try {
            const currentLang = i18n.global.locale.value
            const [{ data: qData, error: qErr }, { data: vData, error: vErr }, { count, error: cErr }] =
                await Promise.all([
                    supabase.from('vote_questions').select('*').eq('lang', currentLang).order('created_at', { ascending: false }),
                    supabase.from('vote_votes').select('*').eq('user_id', user.value.id),
                    supabase.from('vote_questions').select('*', { count: 'exact', head: true }).eq('user_id', user.value.id).eq('lang', currentLang),
                ])
            if (qErr) throw qErr
            if (vErr) throw vErr
            if (cErr) throw cErr

            // Fetch creator profiles separately — works regardless of FK setup
            const uniqueIds = [...new Set((qData || []).map(q => q.user_id).filter(Boolean))]
            let profileMap = {}
            if (uniqueIds.length) {
                const { data: profiles } = await supabase
                    .from('vote_profiles')
                    .select('id, full_name, avatar_url')
                    .in('id', uniqueIds)
                profileMap = Object.fromEntries((profiles || []).map(p => [p.id, p]))
            }

            questions.value = (qData || []).map(q => ({ ...q, creator: profileMap[q.user_id] ?? null }))
            userVotes.value = vData
            userCreatedCount.value = count || 0

            // Preload images for current language to avoid blank cards
            questions.value.slice(0, 5).forEach(q => {
                if (q.image_url) {
                    const img = new Image();
                    img.src = q.image_url;
                }
            });

        } catch (e) {
            console.error('fetchData error:', e.message)
        } finally {
            loading.value = false
        }
    }

    const castVote = async (question, voteType) => {
        if (!user.value) return
        try {
            const { error } = await supabase
                .from('vote_votes')
                .insert({ user_id: user.value.id, question_id: question.id, vote_type: voteType })
            if (error) throw error
            await supabase.rpc('vote_increment', { question_id: question.id, vote_col: voteType })
            if (voteType === 'yes') question.yes_count = (question.yes_count || 0) + 1
            else question.no_count = (question.no_count || 0) + 1
            userVotes.value.push({ question_id: question.id, vote_type: voteType })
        } catch (e) {
            console.error('castVote error:', e.message)
        }
    }

    const createQuestion = async (payload) => {
        if (!user.value) return null
        try {
            const currentLang = i18n.global.locale.value
            const { data, error } = await supabase
                .from('vote_questions')
                .insert({
                    user_id: user.value.id,
                    text: payload.text,
                    category: payload.category,
                    image_url: payload.image,
                    lang: currentLang
                })
                .select()
                .single()
            if (error) throw error
            questions.value.unshift(data)
            userCreatedCount.value++
            return data
        } catch (e) {
            console.error('createQuestion error:', e.message)
            return null
        }
    }

    const clearData = () => {
        questions.value = []
        userVotes.value = []
        userCreatedCount.value = 0
    }

    return {
        questions,
        userVotes,
        userCreatedCount,
        loading,
        unvotedQuestions,
        profileHistory,
        fetchData,
        castVote,
        createQuestion,
        clearData,
    }
}
