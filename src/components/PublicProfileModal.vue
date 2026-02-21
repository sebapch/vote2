<template>
  <div class="fixed inset-0 z-[200] flex items-end sm:items-center justify-center">
    <div class="absolute inset-0 bg-black/25 backdrop-blur-[2px]" @click="$emit('close')"></div>

    <div class="relative w-full sm:max-w-md bg-white sm:rounded-3xl rounded-t-3xl shadow-2xl overflow-hidden max-h-[88vh] flex flex-col border-t border-slate-200 sm:border">
      <div class="w-10 h-1 rounded-full bg-slate-200 mx-auto mt-3 mb-1 sm:hidden shrink-0"></div>

      <!-- Close button -->
      <button @click="$emit('close')" class="absolute top-4 right-4 z-10 w-8 h-8 rounded-xl bg-white/80 backdrop-blur-sm border border-slate-200 flex items-center justify-center text-slate-400 hover:bg-slate-100 transition-colors">
        <X :size="15" />
      </button>

      <!-- Loading -->
      <div v-if="loadingProfile" class="flex items-center justify-center py-20 opacity-30">
        <div class="w-7 h-7 border-[3px] border-slate-300 border-t-blue-600 rounded-full animate-spin"></div>
      </div>

      <template v-else>
        <!-- Profile hero — centered -->
        <div class="flex flex-col items-center text-center px-8 pt-8 pb-6 border-b border-slate-100 shrink-0">
          <div class="w-20 h-20 rounded-2xl overflow-hidden bg-slate-100 border border-slate-200 flex items-center justify-center mb-4 shadow-sm">
            <img v-if="profile?.avatar_url" :src="profile.avatar_url" class="w-full h-full object-cover" />
            <User v-else :size="32" class="text-slate-300" />
          </div>
          <h3 class="text-lg font-extrabold text-slate-900 tracking-tight">{{ firstName }}</h3>
        </div>

        <!-- Stats row — centered -->
        <div class="flex gap-3 px-5 py-4 border-b border-slate-100 shrink-0">
          <div class="flex-1 bg-slate-50 border border-slate-200 rounded-2xl p-3 flex flex-col items-center">
            <span class="text-2xl font-black text-slate-900">{{ createdQuestions.length }}</span>
            <span class="text-[9px] font-bold uppercase tracking-widest text-slate-400 mt-0.5 text-center">Votaciones</span>
          </div>
          <div class="flex-1 bg-slate-50 border border-slate-200 rounded-2xl p-3 flex flex-col items-center">
            <span class="text-2xl font-black text-blue-600">{{ totalVotesReceived }}</span>
            <span class="text-[9px] font-bold uppercase tracking-widest text-slate-400 mt-0.5 text-center">Votos recibidos</span>
          </div>
          <div class="flex-1 bg-slate-50 border border-slate-200 rounded-2xl p-3 flex flex-col items-center">
            <span class="text-2xl font-black text-slate-900">{{ avgYesPercent }}%</span>
            <span class="text-[9px] font-bold uppercase tracking-widest text-slate-400 mt-0.5 text-center">Promedio Sí</span>
          </div>
        </div>

        <!-- Section label -->
        <div class="px-5 pt-4 pb-2 shrink-0">
          <p class="text-[10px] font-bold uppercase tracking-[0.2em] text-slate-400">Votaciones creadas</p>
        </div>

        <!-- Scrollable question list -->
        <div class="flex-1 overflow-y-auto px-4 pb-6 space-y-3">
          <div
            v-for="q in createdQuestions"
            :key="q.id"
            class="rounded-2xl bg-slate-50 border border-slate-200 overflow-hidden"
          >
            <!-- Image -->
            <div v-if="q.image_url" class="h-28 overflow-hidden bg-slate-200">
              <img :src="q.image_url" class="w-full h-full object-cover" />
            </div>

            <div class="p-4">
              <!-- Question text — centered -->
              <p class="text-sm font-semibold text-slate-800 leading-snug mb-3 text-center">{{ q.text }}</p>

              <!-- Progress bar -->
              <div class="h-1.5 w-full bg-slate-200 rounded-full overflow-hidden mb-2.5">
                <div class="h-full bg-blue-500 rounded-full" :style="{ width: getYesPercent(q) + '%' }"></div>
              </div>

              <!-- Chips row — centered -->
              <div class="flex items-center justify-center gap-2">
                <span class="flex items-center gap-1 text-[9px] font-bold text-blue-600 bg-blue-50 border border-blue-100 px-2 py-1 rounded-lg">
                  <ThumbsUp :size="9" /> {{ q.yes_count || 0 }} Sí ({{ getYesPercent(q) }}%)
                </span>
                <span class="text-[9px] text-slate-300">·</span>
                <span class="flex items-center gap-1 text-[9px] font-bold text-slate-500 bg-slate-100 border border-slate-200 px-2 py-1 rounded-lg">
                  <ThumbsDown :size="9" /> {{ q.no_count || 0 }} No
                </span>
                <span class="text-[9px] text-slate-400 ml-1">{{ getTotalVotes(q) }}v.</span>
              </div>
            </div>
          </div>

          <div v-if="!createdQuestions.length" class="py-10 flex justify-center">
            <p class="text-[10px] font-bold uppercase tracking-widest text-slate-400">Sin votaciones creadas</p>
          </div>
        </div>
      </template>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { User, X, ThumbsUp, ThumbsDown } from 'lucide-vue-next'
import { supabase } from '../lib/supabase'

const props = defineProps({ userId: String })
defineEmits(['close'])

const profile = ref(null)
const createdQuestions = ref([])
const loadingProfile = ref(true)

// Only show first name for privacy
const firstName = computed(() => {
  const name = profile.value?.full_name || ''
  return name.split(' ')[0] || 'Usuario'
})

const getTotalVotes = (q) => (q.yes_count || 0) + (q.no_count || 0)
const getYesPercent = (q) => {
  const total = getTotalVotes(q)
  return total === 0 ? 0 : Math.round((q.yes_count / total) * 100)
}

const totalVotesReceived = computed(() =>
  createdQuestions.value.reduce((acc, q) => acc + getTotalVotes(q), 0)
)
const avgYesPercent = computed(() => {
  const qs = createdQuestions.value.filter(q => getTotalVotes(q) > 0)
  if (!qs.length) return 0
  return Math.round(qs.reduce((acc, q) => acc + getYesPercent(q), 0) / qs.length)
})

onMounted(async () => {
  try {
    const [{ data: profileData }, { data: qData }] = await Promise.all([
      supabase.from('vote_profiles').select('full_name, avatar_url').eq('id', props.userId).single(),
      supabase.from('vote_questions').select('*').eq('user_id', props.userId).order('created_at', { ascending: false }),
    ])
    profile.value = profileData
    createdQuestions.value = qData || []
  } catch (e) {
    console.error('PublicProfile error:', e.message)
  } finally {
    loadingProfile.value = false
  }
})
</script>
