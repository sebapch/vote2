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

    const currentLangQuestions = computed(() => {
        const currentLang = i18n.global.locale.value
        return questions.value.filter(q => q.lang === currentLang)
    })

    const unvotedQuestions = computed(() => {
        const votedIds = new Set(userVotes.value.map(v => v.question_id))
        return currentLangQuestions.value.filter(q => !votedIds.has(q.id))
    })

    const fetchData = async () => {
        if (!user.value || loading.value) return
        loading.value = true
        try {
            const currentLang = i18n.global.locale.value

            // 1. Fetch user votes and created count first to know which IDs to fetch
            const [{ data: vData, error: vErr }, { count, error: cErr }] = await Promise.all([
                supabase.from('vote_votes').select('*').eq('user_id', user.value.id),
                supabase.from('vote_questions').select('*', { count: 'exact', head: true }).eq('user_id', user.value.id).eq('lang', currentLang),
            ])
            if (vErr) throw vErr
            if (cErr) throw cErr

            userVotes.value = vData || []
            userCreatedCount.value = count || 0

            // 2. Determine which question IDs we need (current feed + all voted questions)
            const votedIds = (vData || []).map(v => v.question_id)

            // 3. Fetch questions: those in current lang OR those the user voted on
            const { data: qData, error: qErr } = await supabase
                .from('vote_questions')
                .select('*')
                .or(`lang.eq.${currentLang}${votedIds.length ? `,id.in.(${votedIds.join(',')})` : ''}`)
                .order('created_at', { ascending: false })

            if (qErr) throw qErr

            // 4. Fetch creator profiles for these questions
            const uniqueUserIds = [...new Set((qData || []).map(q => q.user_id).filter(Boolean))]
            let profileMap = {}
            if (uniqueUserIds.length) {
                const { data: profiles } = await supabase
                    .from('vote_profiles')
                    .select('id, full_name, avatar_url')
                    .in('id', uniqueUserIds)
                profileMap = Object.fromEntries((profiles || []).map(p => [p.id, p]))
            }

            questions.value = (qData || []).map(q => ({ ...q, creator: profileMap[q.user_id] ?? null }))

            // 5. Preload images for history and top feed
            questions.value.slice(0, 20).forEach(q => {
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
        currentLangQuestions,
        profileHistory,
        fetchData,
        castVote,
        createQuestion,
        clearData,
    }
}
