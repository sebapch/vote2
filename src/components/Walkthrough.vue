<template>
  <div class="fixed inset-0 z-[1000] flex items-center justify-center bg-slate-900/40 backdrop-blur-md p-6">
    <div class="w-full max-w-sm bg-white rounded-[40px] shadow-2xl p-8 flex flex-col items-center text-center animate-in zoom-in-95 duration-300">
      
      <!-- Welcome Icon -->
      <div class="w-20 h-20 bg-blue-50 rounded-3xl flex items-center justify-center mb-8 shadow-inner border border-blue-100/50">
        <Sparkles class="text-blue-600" :size="38" />
      </div>

      <h2 class="text-2xl font-black text-slate-900 tracking-tight mb-8">
        {{ $t('onboarding.welcome') }}
      </h2>

      <div class="space-y-6 mb-10 w-full">
        <!-- Step 1 -->
        <div class="flex items-start gap-4 text-left group">
          <div class="w-8 h-8 rounded-xl bg-slate-50 border border-slate-100 flex items-center justify-center shrink-0 group-hover:bg-blue-50 group-hover:border-blue-100 transition-colors">
            <Layers class="text-slate-400 group-hover:text-blue-500" :size="16" />
          </div>
          <p class="text-sm font-medium text-slate-600 leading-snug pt-1">
            {{ $t('onboarding.step1') }}
          </p>
        </div>

        <!-- Step 2 -->
        <div class="flex items-start gap-4 text-left group">
          <div class="w-8 h-8 rounded-xl bg-slate-50 border border-slate-100 flex items-center justify-center shrink-0 group-hover:bg-blue-50 group-hover:border-blue-100 transition-colors">
            <Plus class="text-slate-400 group-hover:text-blue-500" :size="16" />
          </div>
          <p class="text-sm font-medium text-slate-600 leading-snug pt-1">
            {{ $t('onboarding.step2') }}
          </p>
        </div>

        <!-- Step 3 -->
        <div class="flex items-start gap-4 text-left group">
          <div class="w-8 h-8 rounded-xl bg-slate-50 border border-slate-100 flex items-center justify-center shrink-0 group-hover:bg-blue-50 group-hover:border-blue-100 transition-colors">
            <BarChart3 class="text-slate-400 group-hover:text-blue-500" :size="16" />
          </div>
          <p class="text-sm font-medium text-slate-600 leading-snug pt-1">
            {{ $t('onboarding.step3') }}
          </p>
        </div>
      </div>

      <button
        @click="$emit('finish')"
        class="w-full py-4 bg-slate-900 text-white font-black rounded-2xl shadow-xl shadow-slate-200 hover:bg-blue-600 hover:-translate-y-0.5 active:scale-95 transition-all uppercase tracking-widest text-[11px]"
      >
        {{ $t('onboarding.finish') }}
      </button>
    </div>
  </div>
</template>

<script setup>
import { Sparkles, Layers, Plus, BarChart3 } from 'lucide-vue-next';

defineEmits(['finish']);
</script>
