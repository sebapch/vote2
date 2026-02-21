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
      <img 
        v-if="question.image_url" 
        :src="question.image_url" 
        :alt="question.text" 
        class="w-full h-full object-cover" 
        draggable="false" 
      />
      <div v-else class="w-full h-full flex items-center justify-center bg-gradient-to-br from-slate-100 to-slate-200">
        <span class="text-6xl opacity-20">?</span>
      </div>
      
      <!-- Category Badge -->
      <div class="absolute top-4 left-4">
        <span class="px-3 py-1.5 bg-white/90 backdrop-blur-sm rounded-full text-[9px] font-black uppercase tracking-widest text-slate-700 border border-white shadow-sm">
          {{ question.category }}
        </span>
      </div>
    </div>
    
    <!-- Content Area -->
    <div class="flex flex-col justify-between h-[40%] p-6 bg-white">
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
          <X :size="14" /> No
        </button>
        <button 
          @mousedown.stop 
          @touchstart.stop
          @click.stop="$emit('vote', 'yes')"
          class="flex-1 py-3.5 bg-slate-900 text-white rounded-2xl font-bold text-xs uppercase tracking-wider flex items-center justify-center gap-2 hover:bg-blue-600 active:scale-95 transition-all shadow-lg shadow-slate-200"
        >
          <Check :size="14" /> Sí
        </button>
      </div>
    </div>

    <!-- Swipe Indicators -->
    <div 
      class="absolute top-10 left-8 border-[4px] border-blue-600 text-blue-600 font-black text-3xl px-4 py-1.5 rounded-2xl pointer-events-none -rotate-[20deg]"
      :style="{ opacity: yesOpacity }"
    >
      SÍ
    </div>
    <div 
      class="absolute top-10 right-8 border-[4px] border-red-500 text-red-500 font-black text-3xl px-4 py-1.5 rounded-2xl pointer-events-none rotate-[20deg]"
      :style="{ opacity: noOpacity }"
    >
      NO
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onUnmounted } from 'vue';
import { Check, X } from 'lucide-vue-next';

const props = defineProps({
  question: Object,
  swiped: String
});

const emit = defineEmits(['vote']);

const cardRef = ref(null);
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
