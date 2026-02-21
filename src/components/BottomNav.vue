<template>
  <nav class="bottom-nav fixed bottom-0 left-0 right-0 pb-5 pt-2.5 px-4 flex justify-center z-[110] border-t border-slate-200/50">
    <div class="flex items-center gap-1">
      <button
        @click="$emit('navigate', 'feed')"
        class="flex items-center gap-1.5 px-4 py-2 rounded-2xl transition-all"
        :class="activeTab === 'feed' ? 'bg-slate-900 text-white' : 'text-slate-400 hover:text-slate-600'"
      >
        <Layers :size="17" />
        <span v-if="activeTab === 'feed'" class="text-[11px] font-bold">Explorar</span>
      </button>

      <button
        @click="$emit('openCreate')"
        class="w-10 h-10 bg-blue-600 text-white rounded-2xl flex items-center justify-center hover:scale-105 active:scale-95 transition-all shadow-md shadow-blue-300/40 mx-2"
      >
        <Plus :size="20" />
      </button>

      <button
        @click="$emit('navigate', 'results')"
        class="flex items-center gap-1.5 px-4 py-2 rounded-2xl transition-all"
        :class="activeTab === 'results' ? 'bg-slate-900 text-white' : 'text-slate-400 hover:text-slate-600'"
      >
        <BarChart3 :size="17" />
        <span v-if="activeTab === 'results'" class="text-[11px] font-bold">Ranking</span>
      </button>
    </div>
  </nav>
</template>

<script setup>
import { Layers, Plus, BarChart3 } from 'lucide-vue-next';

defineProps({ activeTab: String });
defineEmits(['navigate', 'openCreate']);
</script>

<style scoped>
.bottom-nav {
  background: rgba(244, 244, 247, 0.6);
  backdrop-filter: blur(24px) saturate(180%);
  -webkit-backdrop-filter: blur(24px) saturate(180%);
}
</style>
