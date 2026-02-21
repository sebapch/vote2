<template>
  <div 
    v-if="question"
    ref="cardRef"
    class="absolute inset-0 w-full h-full bg-white rounded-[40px] overflow-hidden shadow-2xl shadow-slate-200 transition-transform duration-300 transform-gpu select-none touch-none border border-slate-100"
    :style="cardStyle"
    @mousedown="startDrag"
    @touchstart.prevent="startDrag"
  >
    <!-- Image -->
    <div class="relative w-full h-[60%] overflow-hidden bg-slate-100">
      <div v-if="question.image_url" class="w-full h-full relative bg-slate-50">
        <!-- Skeleton/Spinner while loading -->
        <div 
          v-if="!imageLoaded" 
          class="absolute inset-0 flex items-center justify-center bg-slate-50 z-10"
        >
          <div class="w-6 h-6 border-2 border-slate-200 border-t-blue-500 rounded-full animate-spin"></div>
        </div>
        
        <img 
          ref="imgRef"
          :src="question.image_url" 
          :alt="question.text" 
          class="w-full h-full object-cover transition-opacity duration-500"
          :class="imageLoaded ? 'opacity-100' : 'opacity-0'"
          @load="imageLoaded = true"
          @error="imageError = true"
          draggable="false" 
        />

        <!-- Error fallback -->
        <div v-if="imageError" class="absolute inset-0 flex flex-col items-center justify-center bg-slate-100 text-slate-400 gap-2">
           <ImageIcon :size="24" class="opacity-30" />
           <span class="text-[9px] font-bold uppercase tracking-widest opacity-50">Error al cargar</span>
        </div>
      </div>
      <div v-else class="w-full h-full flex items-center justify-center bg-gradient-to-br from-slate-100 to-slate-200">
        <span class="text-6xl opacity-20">?</span>
      </div>

      <!-- Report button: top-right corner, always visible -->
      <button
        @mousedown.stop
        @touchstart.stop
        @click.stop="handleReport"
        :disabled="reported"
        :title="reported ? $t('report.already') : $t('report.tooltip')"
        class="absolute top-3 right-3 z-20 flex items-center gap-1.5 px-2.5 py-1.5 rounded-xl text-[10px] font-black uppercase tracking-wider transition-all active:scale-90 shadow-lg"
        :class="reported
          ? 'bg-slate-200 text-slate-400 cursor-not-allowed'
          : 'bg-orange-500 text-white hover:bg-red-600 hover:scale-105'"
      >
        <Flag :size="11" />
        {{ reported ? $t('report.done') : $t('report.button') }}
      </button>
    </div>

    
    <!-- Content Area -->
    <div class="flex flex-col justify-between h-[40%] p-6 bg-white relative">
      <p class="text-base font-bold text-slate-900 leading-snug line-clamp-3 pointer-events-none">
        {{ question.text }}
      </p>
      
      <!-- Buttons -->
      <div class="flex gap-3 pt-2">
        <button 
          @mousedown.stop 
          @touchstart.stop
          @click.stop="$emit('vote', 'no')"
          class="flex-1 py-3.5 bg-slate-100 border border-slate-200 rounded-2xl font-bold text-xs uppercase tracking-wider flex items-center justify-center gap-2 text-slate-600 hover:bg-red-50 hover:text-red-600 hover:border-red-200 active:scale-95 transition-all"
        >
          <X :size="14" /> {{ $t('results.no') }}
        </button>
        <button 
          @mousedown.stop 
          @touchstart.stop
          @click.stop="$emit('vote', 'yes')"
          class="flex-1 py-3.5 bg-slate-900 text-white rounded-2xl font-bold text-xs uppercase tracking-wider flex items-center justify-center gap-2 hover:bg-blue-600 active:scale-95 transition-all shadow-lg shadow-slate-200"
        >
          <Check :size="14" /> {{ $t('results.yes') }}
        </button>
      </div>

      <!-- Report button fallback for no-image cards -->
      <button
        v-if="!question.image_url"
        @mousedown.stop
        @touchstart.stop
        @click.stop="handleReport"
        :disabled="reported"
        :title="reported ? $t('report.already') : $t('report.tooltip')"
        class="absolute top-3 right-3 flex items-center gap-1 px-2 py-1 rounded-lg text-[9px] font-black uppercase tracking-wider transition-all active:scale-90"
        :class="reported
          ? 'bg-slate-100 text-slate-300 cursor-not-allowed'
          : 'bg-orange-100 text-orange-500 hover:bg-orange-500 hover:text-white'"
      >
        <Flag :size="10" />
        {{ reported ? $t('report.done') : $t('report.button') }}
      </button>
    </div>

    <!-- Swipe Indicators -->
    <div 
      class="absolute top-10 left-8 border-[4px] border-blue-600 text-blue-600 font-black text-3xl px-4 py-1.5 rounded-2xl pointer-events-none -rotate-[20deg] uppercase"
      :style="{ opacity: yesOpacity }"
    >
      {{ $t('results.yes') }}
    </div>
    <div 
      class="absolute top-10 right-8 border-[4px] border-red-500 text-red-500 font-black text-3xl px-4 py-1.5 rounded-2xl pointer-events-none rotate-[20deg] uppercase"
      :style="{ opacity: noOpacity }"
    >
      {{ $t('results.no') }}
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onUnmounted, onMounted } from 'vue';
import { Check, X, ImageIcon, Flag } from 'lucide-vue-next';
import { useVoteData } from '../composables/useVoteData';

const props = defineProps({
  question: Object,
  swiped: String,
  alreadyReported: Boolean,
});

const emit = defineEmits(['vote', 'report']);

const { reportQuestion } = useVoteData();

const reported = ref(props.alreadyReported ?? false);

const handleReport = async () => {
  if (reported.value || !props.question) return;
  reported.value = true;
  emit('report', props.question.id);
  await reportQuestion(props.question.id);
};

const cardRef = ref(null);
const imgRef = ref(null);
const imageLoaded = ref(false);
const imageError = ref(false);

onMounted(() => {
  if (imgRef.value?.complete) {
    imageLoaded.value = true;
  }
});
const isDragging = ref(false);
const startX = ref(0);
const currentX = ref(0);
const rotationMultiplier = 0.08;

const cardStyle = computed(() => {
  if (props.swiped === 'right') {
    return { transform: 'translateX(200%) rotate(20deg)', transition: 'transform 0.45s cubic-bezier(0.55, 0, 1, 0.45)' };
  }
  if (props.swiped === 'left') {
    return { transform: 'translateX(-200%) rotate(-20deg)', transition: 'transform 0.45s cubic-bezier(0.55, 0, 1, 0.45)' };
  }
  
  if (!isDragging.value) {
    return { transform: 'translateX(0) rotate(0)', transition: 'transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275)' };
  }

  const distance = currentX.value - startX.value;
  const rotation = distance * rotationMultiplier;
  return { transform: `translateX(${distance}px) rotate(${rotation}deg)`, transition: 'none' };
});

const yesOpacity = computed(() => {
  if (props.swiped === 'right') return 1;
  return Math.max(0, Math.min(1, (currentX.value - startX.value) / 80));
});

const noOpacity = computed(() => {
  if (props.swiped === 'left') return 1;
  return Math.max(0, Math.min(1, -(currentX.value - startX.value) / 80));
});

const startDrag = (e) => {
  if (props.swiped) return;
  isDragging.value = true;
  startX.value = e.type.includes('touch') ? e.touches[0].clientX : e.clientX;
  currentX.value = startX.value;
  window.addEventListener('mousemove', onDrag);
  window.addEventListener('mouseup', endDrag);
  window.addEventListener('touchmove', onDrag, { passive: false });
  window.addEventListener('touchend', endDrag);
};

const onDrag = (e) => {
  if (!isDragging.value) return;
  if (e.cancelable) e.preventDefault();
  currentX.value = e.type.includes('touch') ? e.touches[0].clientX : e.clientX;
};

const endDrag = () => {
  if (!isDragging.value) return;
  isDragging.value = false;
  const distance = currentX.value - startX.value;
  if (distance > 100) emit('vote', 'yes');
  else if (distance < -100) emit('vote', 'no');
  window.removeEventListener('mousemove', onDrag);
  window.removeEventListener('mouseup', endDrag);
  window.removeEventListener('touchmove', onDrag);
  window.removeEventListener('touchend', endDrag);
};

onUnmounted(() => {
  window.removeEventListener('mousemove', onDrag);
  window.removeEventListener('mouseup', endDrag);
  window.removeEventListener('touchmove', onDrag);
  window.removeEventListener('touchend', endDrag);
});
</script>
