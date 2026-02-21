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

    <!-- Cards -->
    <div v-else class="grid grid-cols-2 gap-3">
      <div
        v-for="(question, i) in sortedQuestions"
        :key="question.id"
        class="bg-white border border-slate-200 rounded-3xl overflow-hidden shadow-sm hover:shadow-md hover:-translate-y-0.5 transition-all duration-200 group flex flex-col"
      >
        <!-- Image banner -->
        <div v-if="question.image_url" class="relative h-24 overflow-hidden bg-slate-100">
          <img :src="question.image_url" :alt="question.text" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500" />
          <div class="absolute inset-0 bg-gradient-to-t from-black/60 via-black/10 to-transparent"></div>
          <!-- Rank badge on image -->
          <div class="absolute top-3 left-3 w-8 h-8 rounded-xl bg-white/90 backdrop-blur-sm border border-white/50 flex items-center justify-center shadow-sm">
            <span class="text-[11px] font-black text-slate-700">#{{ i + 1 }}</span>
          </div>
          <span class="absolute top-3 right-3 text-[9px] font-black uppercase tracking-widest text-white/90 bg-black/30 backdrop-blur-sm px-2.5 py-1 rounded-full">
            {{ question.category }}
          </span>
        </div>

        <div class="p-4 flex flex-col flex-1">
          <!-- No image: rank + category inline -->
          <div v-if="!question.image_url" class="flex items-center gap-2 mb-3">
            <div class="w-7 h-7 rounded-xl bg-slate-100 border border-slate-200 flex items-center justify-center shrink-0">
              <span class="text-[10px] font-black text-slate-500">#{{ i + 1 }}</span>
            </div>
            <span class="text-[9px] font-bold uppercase tracking-widest text-blue-600">{{ question.category }}</span>
          </div>

          <!-- Question text -->
          <h3 class="text-xs font-bold text-slate-900 leading-snug mb-4 line-clamp-2">{{ question.text }}</h3>

          <!-- Stats row -->
          <div class="flex items-center justify-between text-[9px] font-bold uppercase tracking-widest mb-2">
            <span :class="getYesPercent(question) >= 50 ? 'text-blue-600' : 'text-slate-400'">
              Sí {{ getYesPercent(question) }}%
            </span>
            <span class="text-slate-300 font-medium">{{ getTotalVotes(question) }} votos</span>
            <span :class="getYesPercent(question) < 50 ? 'text-slate-700' : 'text-slate-400'">
              No {{ 100 - getYesPercent(question) }}%
            </span>
          </div>

          <!-- Split bar -->
          <div class="h-2 w-full bg-slate-100 rounded-full overflow-hidden flex gap-0.5">
            <div
              class="h-full bg-blue-500 rounded-full transition-all duration-700"
              :style="{ width: getYesPercent(question) + '%' }"
            ></div>
            <div
              class="h-full bg-slate-300 rounded-full transition-all duration-700"
              :style="{ width: (100 - getYesPercent(question)) + '%' }"
            ></div>
          </div>

          <!-- Vote chips + winner -->
          <div class="flex flex-wrap items-center gap-1.5 mt-3">
            <div class="flex items-center gap-1.5 px-3 py-1.5 bg-blue-50 border border-blue-100 rounded-xl">
              <ThumbsUp :size="12" class="text-blue-500" />
              <span class="text-[10px] font-bold text-blue-700">{{ question.yes_count || 0 }}</span>
            </div>
            <div class="flex items-center gap-1.5 px-3 py-1.5 bg-slate-50 border border-slate-200 rounded-xl">
              <ThumbsDown :size="12" class="text-slate-400" />
              <span class="text-[10px] font-bold text-slate-500">{{ question.no_count || 0 }}</span>
            </div>

            <!-- Winner chip -->
            <div class="ml-auto">
              <span
                v-if="getTotalVotes(question) > 0"
                class="text-[9px] font-black uppercase tracking-wider px-3 py-1.5 rounded-full"
                :class="getYesPercent(question) > 50
                  ? 'bg-blue-600 text-white'
                  : getYesPercent(question) < 50
                    ? 'bg-slate-800 text-white'
                    : 'bg-slate-100 text-slate-500 border border-slate-200'"
              >
                {{ getYesPercent(question) > 50 ? '🔥 Sí gana' : getYesPercent(question) < 50 ? '⚡ No gana' : '🤝 Empate' }}
              </span>
              <span v-else class="text-[9px] font-bold text-slate-300 uppercase tracking-wider">Sin votos</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue';
import { BarChart3, ThumbsUp, ThumbsDown } from 'lucide-vue-next';

const props = defineProps({ questions: Array });

const getTotalVotes = (q) => (q.yes_count || 0) + (q.no_count || 0);
const getYesPercent = (q) => {
  const total = getTotalVotes(q);
  return total === 0 ? 50 : Math.round((q.yes_count / total) * 100);
};

// Sort: most voted first
const sortedQuestions = computed(() =>
  [...(props.questions || [])].sort((a, b) => getTotalVotes(b) - getTotalVotes(a))
);
</script>
