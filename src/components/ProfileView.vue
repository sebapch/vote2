<template>
  <div class="w-full max-w-2xl mx-auto space-y-6">

    <!-- Profile Card -->
    <div class="p-8 rounded-3xl bg-white border border-slate-200 shadow-sm flex flex-col items-center text-center">
      <div class="w-24 h-24 rounded-full border-2 border-slate-100 overflow-hidden mb-5 bg-slate-50 flex items-center justify-center">
        <img v-if="user?.user_metadata?.avatar_url" :src="user.user_metadata.avatar_url" class="w-full h-full object-cover" />
        <User v-else :size="40" class="text-slate-300" />
      </div>
      <h2 class="text-xl font-bold text-slate-900 tracking-tight mb-1">
        {{ user?.user_metadata?.full_name || 'Usuario' }}
      </h2>
      <p class="text-slate-400 text-xs font-medium uppercase tracking-wider mb-6">{{ user?.email }}</p>
      <button
        @click="logout"
        class="px-5 py-2 rounded-xl bg-slate-100 border border-slate-200 text-[10px] font-bold uppercase tracking-widest text-slate-500 hover:bg-red-50 hover:text-red-500 hover:border-red-100 transition-all active:scale-95"
      >
        Cerrar Sesión
      </button>
    </div>

    <!-- Stats -->
    <div class="grid grid-cols-2 gap-4">
      <div class="p-6 rounded-3xl bg-white border border-slate-200 shadow-sm flex flex-col items-center">
        <span class="text-3xl font-bold text-slate-900 mb-1">{{ votesCount }}</span>
        <span class="text-[9px] font-bold uppercase tracking-widest text-slate-400">Votos totales</span>
      </div>
      <div class="p-6 rounded-3xl bg-white border border-slate-200 shadow-sm flex flex-col items-center">
        <span class="text-3xl font-bold text-slate-900 mb-1">{{ createdCount }}</span>
        <span class="text-[9px] font-bold uppercase tracking-widest text-slate-400">Preguntas creadas</span>
      </div>
    </div>

    <!-- History -->
    <div>
      <div class="flex items-center gap-4 mb-4 px-1">
        <h3 class="text-[11px] font-bold text-slate-500 uppercase tracking-[0.2em] shrink-0">Historial</h3>
        <div class="h-px flex-1 bg-slate-200"></div>
      </div>

      <div v-if="history?.length" class="space-y-2.5">
        <div
          v-for="item in history"
          :key="item.id"
          class="p-4 rounded-2xl bg-white border border-slate-200 shadow-sm flex items-center gap-4 hover:border-blue-200 transition-colors"
        >
          <div
            class="w-10 h-10 rounded-xl flex items-center justify-center shrink-0 text-[9px] font-black italic"
            :class="item.userChoice === 'yes' ? 'bg-blue-50 text-blue-600' : 'bg-slate-100 text-slate-400'"
          >
            {{ item.userChoice === 'yes' ? 'SÍ' : 'NO' }}
          </div>
          <div class="flex-1 min-w-0">
            <p class="text-slate-800 font-semibold text-sm leading-snug truncate">{{ item.text }}</p>
            <span class="text-[9px] font-bold text-slate-400 uppercase tracking-wider">{{ item.category }}</span>
          </div>
          <ChevronRight :size="14" class="text-slate-300 shrink-0" />
        </div>
      </div>

      <div v-else class="py-10 flex justify-center">
        <p class="text-[10px] font-bold uppercase tracking-widest text-slate-400 bg-slate-100 px-4 py-2 rounded-full border border-slate-200">
          Sin actividad previa
        </p>
      </div>
    </div>

  </div>
</template>

<script setup>
import { User, ChevronRight } from 'lucide-vue-next';
import { useAuth } from '../composables/useAuth';

const { user, logout } = useAuth();

defineProps({
  votesCount: { type: Number, default: 0 },
  createdCount: { type: Number, default: 0 },
  history: { type: Array, default: () => [] },
});
</script>
