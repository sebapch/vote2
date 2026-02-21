<template>
  <div class="relative w-full max-w-[340px] aspect-[3/4.2]">
    <!-- Cards exist -->
    <div v-if="unvotedQuestions.length > 0 && currentIndex < unvotedQuestions.length" class="relative w-full h-full">
      <!-- Background card peek -->
      <div
        v-if="currentIndex + 1 < unvotedQuestions.length"
        class="absolute inset-x-4 inset-y-0 scale-[0.93] translate-y-6 opacity-40 rounded-[40px] bg-white border border-slate-200 pointer-events-none"
      ></div>

      <!-- Active SwipeCard -->
      <SwipeCard
        :key="unvotedQuestions[currentIndex].id"
        :question="unvotedQuestions[currentIndex]"
        :swiped="swipeDirection"
        @vote="handleVote"
      />
    </div>

    <!-- All done state -->
    <div v-else class="text-center p-12 bg-white rounded-[40px] border border-slate-200 shadow-sm">
      <div class="w-16 h-16 bg-slate-50 rounded-2xl flex items-center justify-center mx-auto mb-6 border border-slate-100">
        <Trophy :size="32" class="text-blue-600" />
      </div>
      <h2 class="text-lg font-bold text-slate-900 mb-2 tracking-tight">{{ $t('feed.empty') }}</h2>
      <button
        @click="$emit('reload')"
        class="w-full py-4 bg-slate-100 text-slate-900 font-bold rounded-2xl hover:bg-slate-200 transition-all border border-slate-200"
      >
        {{ $t('feed.reloading') }}
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { Trophy } from 'lucide-vue-next';
import SwipeCard from '../components/SwipeCard.vue';
import { useVoteData } from '../composables/useVoteData';

const { unvotedQuestions, castVote } = useVoteData();
const emit = defineEmits(['reload']);

const currentIndex = ref(0);
const swipeDirection = ref(null);

const handleVote = async (direction) => {
  if (swipeDirection.value) return;

  const question = unvotedQuestions.value[currentIndex.value];
  const voteType = direction === 'yes' ? 'yes' : 'no';
  swipeDirection.value = direction === 'yes' ? 'right' : 'left';

  await castVote(question, voteType);

  setTimeout(() => {
    currentIndex.value++;
    swipeDirection.value = null;
  }, 420);
};

// Reset when feed reloads
const reset = () => {
  currentIndex.value = 0;
  swipeDirection.value = null;
};

defineExpose({ reset });
</script>
