<template>
  <header class="app-header fixed top-0 left-0 right-0 h-16 flex justify-center items-center z-[110] border-b border-slate-200/60">
    <div class="w-full max-w-5xl px-6 flex justify-between items-center">
      <h1
        @click="$emit('navigate', 'feed')"
        class="text-xl font-extrabold tracking-tighter text-slate-900 cursor-pointer active:scale-95 transition-transform select-none"
      >
        VOTE<span class="text-blue-600">.</span>
      </h1>

      <div class="flex items-center gap-4">
        <button
          @click="toggleLocale"
          class="text-[10px] font-black uppercase tracking-widest px-2.5 py-1.5 rounded-lg bg-white border border-slate-200 text-slate-500 hover:text-blue-600 transition-colors"
        >
          {{ locale === 'es' ? 'EN' : 'ES' }}
        </button>

        <button
          @click="$emit('navigate', 'profile')"
          class="w-8 h-8 rounded-full border-2 transition-all overflow-hidden flex items-center justify-center bg-slate-50 relative"
          :class="activeTab === 'profile' ? 'border-blue-600 shadow-sm' : 'border-slate-200'"
        >
          <img
            v-if="user?.user_metadata?.avatar_url && !avatarError"
            :src="user.user_metadata.avatar_url"
            class="w-full h-full object-cover"
            @error="avatarError = true"
          />
          <User v-else :size="16" class="text-slate-300" />
        </button>
      </div>
    </div>
  </header>
</template>

<script setup>
import { ref } from 'vue';
import { User } from 'lucide-vue-next';
import { useI18n } from 'vue-i18n';
import { useAuth } from '../composables/useAuth';

const { user } = useAuth();
const { locale } = useI18n();
const avatarError = ref(false);

const toggleLocale = () => {
  locale.value = locale.value === 'es' ? 'en' : 'es';
};

defineProps({ activeTab: String });
defineEmits(['navigate']);
</script>

<style scoped>
.app-header {
  background: rgba(244, 244, 247, 0.75);
  backdrop-filter: blur(20px) saturate(180%);
  -webkit-backdrop-filter: blur(20px) saturate(180%);
}
</style>
