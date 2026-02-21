<template>
  <div class="w-full max-w-2xl mx-auto px-2 py-4">

    <!-- Header -->
    <div class="flex items-center justify-between mb-6 px-1">
      <h2 class="text-xl font-extrabold tracking-tight text-slate-900">Resultados</h2>
      <span class="text-[10px] font-bold text-slate-500 bg-white border border-slate-200 px-3 py-1.5 rounded-full uppercase tracking-widest shadow-sm">
        {{ questions.length }} preguntas
      </span>
    </div>

    <!-- Empty state -->
    <div v-if="!questions.length" class="flex flex-col items-center justify-center py-24 gap-4">
      <div class="w-14 h-14 bg-white rounded-2xl border border-slate-200 flex items-center justify-center shadow-sm">
        <BarChart3 :size="24" class="text-slate-300" />
      </div>
      <p class="text-[11px] font-bold uppercase tracking-widest text-slate-400">Sin resultados aún</p>
    </div>

    <!-- 2-column grid -->
    <div v-else class="grid grid-cols-2 gap-3">
      <div
        v-for="(question, i) in sortedQuestions"
        :key="question.id"
        class="bg-white border border-slate-200 rounded-3xl overflow-hidden shadow-sm hover:shadow-md hover:-translate-y-0.5 transition-all duration-200 group flex flex-col"
      >
        <!-- Image -->
        <div v-if="question.image_url" class="relative h-24 overflow-hidden bg-slate-100 shrink-0">
          <img :src="question.image_url" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500" />
          <div class="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent"></div>
          <span class="absolute top-2.5 left-2.5 w-7 h-7 rounded-xl bg-white/90 backdrop-blur-sm flex items-center justify-center text-[10px] font-black text-slate-700">#{{ i + 1 }}</span>
        </div>

        <div class="p-4 flex flex-col flex-1">
          <!-- Rank (no image) -->
          <div v-if="!question.image_url" class="flex items-center gap-1.5 mb-2.5">
            <span class="w-7 h-7 rounded-xl bg-slate-100 border border-slate-200 flex items-center justify-center text-[10px] font-black text-slate-500">#{{ i + 1 }}</span>
          </div>

          <!-- Question text -->
          <h3 class="text-xs font-bold text-slate-900 leading-snug mb-4 line-clamp-2 flex-1">{{ question.text }}</h3>

          <!-- Stats row -->
          <div class="flex items-center justify-between text-[9px] font-bold uppercase tracking-widest mb-2">
            <span :class="getYesPercent(question) >= 50 ? 'text-blue-600' : 'text-slate-400'">
              {{ getYesPercent(question) }}% Sí
            </span>
            <span class="text-slate-300">{{ getTotalVotes(question) }} v.</span>
            <span :class="getYesPercent(question) < 50 ? 'text-slate-700' : 'text-slate-400'">
              No {{ 100 - getYesPercent(question) }}%
            </span>
          </div>

          <!-- Split bar -->
          <div class="h-1.5 w-full bg-slate-100 rounded-full overflow-hidden flex mb-3.5">
            <div class="h-full bg-blue-500 rounded-full transition-all duration-700" :style="{ width: getYesPercent(question) + '%' }"></div>
            <div class="h-full bg-slate-300 rounded-full transition-all duration-700" :style="{ width: (100 - getYesPercent(question)) + '%' }"></div>
          </div>

          <!-- Bottom row: creator + personal badge -->
          <div class="flex items-center justify-between">
            <!-- Creator avatar -->
            <button
              class="w-7 h-7 rounded-full overflow-hidden bg-slate-100 border border-slate-200 flex items-center justify-center hover:ring-2 hover:ring-blue-400 hover:ring-offset-1 transition-all shrink-0"
              :title="question.creator?.full_name || 'Ver perfil'"
              @click.stop="selectedCreatorId = question.user_id"
            >
              <img v-if="question.creator?.avatar_url" :src="question.creator.avatar_url" class="w-full h-full object-cover" />
              <User v-else :size="12" class="text-slate-400" />
            </button>

            <!-- Personal badge: only if user voted this -->
            <span
              v-if="getUserVote(question.id)"
              class="text-[8px] font-black uppercase tracking-wider px-2 py-1 rounded-full"
              :class="isWinning(question) ? 'bg-blue-600 text-white' : 'bg-slate-200 text-slate-600'"
            >
              {{ isWinning(question) ? '🔥 Ganás' : '😬 Perdés' }}
            </span>

            <!-- No vote yet badge -->
            <span v-else-if="getTotalVotes(question) === 0" class="text-[8px] font-bold text-slate-300 uppercase tracking-wider">Sin votos</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Public Profile Modal -->
    <PublicProfileModal
      v-if="selectedCreatorId"
      :userId="selectedCreatorId"
      @close="selectedCreatorId = null"
    />
  </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import { BarChart3, User } from 'lucide-vue-next';
import PublicProfileModal from './PublicProfileModal.vue';
import { useAuth } from '../composables/useAuth';
import { useVoteData } from '../composables/useVoteData';

const props = defineProps({ questions: Array });

const { user } = useAuth();
const { userVotes } = useVoteData();

const selectedCreatorId = ref(null);

const getTotalVotes = (q) => (q.yes_count || 0) + (q.no_count || 0);
const getYesPercent = (q) => {
  const total = getTotalVotes(q);
  return total === 0 ? 50 : Math.round((q.yes_count / total) * 100);
};

// Find how the current user voted on a question
const getUserVote = (questionId) => {
  return userVotes.value.find(v => v.question_id === questionId)?.vote_type ?? null;
};

// Is the user on the winning side?
const isWinning = (question) => {
  const userVote = getUserVote(question.id);
  if (!userVote) return false;
  const yesPercent = getYesPercent(question);
  return (userVote === 'yes' && yesPercent >= 50) || (userVote === 'no' && yesPercent < 50);
};

// Sort: most voted first
const sortedQuestions = computed(() =>
  [...(props.questions || [])].sort((a, b) => getTotalVotes(b) - getTotalVotes(a))
);
</script>
