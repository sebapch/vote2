<template>
  <div class="w-full max-w-2xl mx-auto space-y-6">

    <!-- Profile Card -->
    <div class="p-8 rounded-[40px] bg-white border border-slate-200 shadow-sm flex flex-col items-center text-center">
      <div class="w-24 h-24 rounded-full border-4 border-slate-50 overflow-hidden mb-5 bg-slate-50 flex items-center justify-center shadow-inner">
        <img v-if="user?.user_metadata?.avatar_url" :src="user.user_metadata.avatar_url" class="w-full h-full object-cover" />
        <User v-else :size="40" class="text-slate-300" />
      </div>
      <h2 class="text-2xl font-black text-slate-900 tracking-tight mb-6">
        {{ $t('profile.hello', { name: firstName }) }}<span class="text-blue-600">.</span>
      </h2>
      
      <button
        @click="logout"
        class="px-6 py-2.5 rounded-2xl bg-white border border-slate-200 text-[10px] font-bold uppercase tracking-widest text-slate-500 hover:bg-slate-50 hover:text-slate-800 transition-all active:scale-95 flex items-center gap-2"
      >
        <span>{{ $t('profile.logout') }}</span>
      </button>
    </div>

    <!-- Stats -->
    <div class="grid grid-cols-2 gap-4">
      <div class="p-8 rounded-[32px] bg-white border border-slate-200 shadow-sm flex flex-col items-center group hover:border-blue-100 transition-colors">
        <span class="text-4xl font-black text-slate-900 mb-1 group-hover:text-blue-600 transition-colors">{{ votesCount }}</span>
        <span class="text-[10px] font-bold uppercase tracking-widest text-slate-400">{{ $t('profile.stats.total_votes') }}</span>
      </div>
      <div class="p-8 rounded-[32px] bg-white border border-slate-200 shadow-sm flex flex-col items-center group hover:border-blue-100 transition-colors">
        <span class="text-4xl font-black text-slate-900 mb-1 group-hover:text-blue-600 transition-colors">{{ createdCount }}</span>
        <span class="text-[10px] font-bold uppercase tracking-widest text-slate-400">{{ $t('profile.stats.questions') }}</span>
      </div>
    </div>

    <!-- History -->
    <div class="space-y-4">
      <div class="flex items-center justify-between px-2">
        <h3 class="text-xs font-black text-slate-900 uppercase tracking-widest">{{ $t('profile.history.title') }}</h3>
        <span class="text-[10px] font-bold text-slate-400">{{ $t('profile.history.count', { n: history?.length }) }}</span>
      </div>

      <div v-if="history?.length" class="grid gap-3">
        <div
          v-for="item in history"
          :key="item.id"
          class="p-3 pr-5 rounded-[24px] bg-white border border-slate-100 shadow-sm flex items-center gap-4 hover:border-blue-200 hover:shadow-md transition-all group"
        >
          <!-- Thumbnail or Icon -->
          <div class="w-16 h-16 rounded-2xl overflow-hidden bg-slate-50 border border-slate-100 shrink-0">
            <img v-if="item.image_url" :src="item.image_url" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500" />
            <div v-else class="w-full h-full flex items-center justify-center bg-slate-50">
              <Layers :size="20" class="text-slate-300" />
            </div>
          </div>

          <div class="flex-1 min-w-0">
            <p class="text-slate-900 font-bold text-sm leading-snug line-clamp-1 mb-1">{{ item.text }}</p>
            <div class="flex items-center gap-2">
              <span 
                class="px-2 py-0.5 rounded-lg text-[9px] font-black uppercase tracking-wider"
                :class="item.userChoice === 'yes' ? 'bg-blue-600 text-white' : 'bg-slate-900 text-white'"
              >
                {{ item.userChoice === 'yes' ? $t('profile.history.voted_yes') : $t('profile.history.voted_no') }}
              </span>
              <span class="text-[9px] font-bold text-slate-400 uppercase tracking-widest">{{ $t('categories.' + (item.category || 'general').toLowerCase()) }}</span>
            </div>
          </div>
          
          <div class="shrink-0 w-8 h-8 rounded-full bg-slate-50 flex items-center justify-center group-hover:bg-blue-50 transition-colors">
            <ChevronRight :size="16" class="text-slate-300 group-hover:text-blue-500 transition-colors" />
          </div>
        </div>
      </div>

      <div v-else class="py-16 flex flex-col items-center justify-center bg-white rounded-[40px] border border-dashed border-slate-200">
        <div class="w-12 h-12 bg-slate-50 rounded-2xl flex items-center justify-center mb-4 text-slate-300">
          <Layers :size="24" />
        </div>
        <p class="text-[11px] font-bold uppercase tracking-widest text-slate-400">
          {{ $t('profile.history.empty') }}
        </p>
      </div>
    </div>

  </div>
</template>

<script setup>
import { computed } from 'vue';
import { useI18n } from 'vue-i18n';
import { User, ChevronRight, Layers } from 'lucide-vue-next';
import { useAuth } from '../composables/useAuth';

const { t } = useI18n();

const { user, logout } = useAuth();

const props = defineProps({
  votesCount: { type: Number, default: 0 },
  createdCount: { type: Number, default: 0 },
  history: { type: Array, default: () => [] },
});

const firstName = computed(() => {
  const fullName = user.value?.user_metadata?.full_name || t('public_profile.default_name');
  return fullName.split(' ')[0];
});
</script>
