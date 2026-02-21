<template>
  <div class="w-full flex flex-col items-center justify-center min-h-screen bg-[#F4F4F7] px-6">
    <h1 class="text-5xl font-black text-slate-900 tracking-tighter mb-16 select-none">
      VOTE<span class="text-blue-600">.</span>
    </h1>

    <div class="relative mb-12">
      <div class="w-20 h-20 bg-white rounded-3xl flex items-center justify-center shadow-xl shadow-slate-200 border border-slate-100">
        <LogIn :size="32" class="text-blue-600" />
      </div>
      <div class="absolute -top-2 -right-2 w-6 h-6 bg-blue-600 rounded-full border-4 border-[#F4F4F7]"></div>
    </div>

    <div class="w-full max-w-sm text-center">
      <h2 class="text-2xl font-bold text-slate-900 mb-3 tracking-tight">Toma el control</h2>
      <p class="text-slate-500 mb-12 leading-relaxed text-sm font-medium">
        Únete a la comunidad para votar y proponer nuevas ideas de forma anónima y segura.
      </p>

      <button
        @click="loginWithGoogle"
        class="w-full py-4 bg-slate-900 text-white font-bold rounded-2xl flex items-center justify-center gap-3 hover:bg-slate-800 transition-all active:scale-[0.98] shadow-lg shadow-slate-200"
      >
        <svg class="w-5 h-5 shrink-0" viewBox="0 0 24 24">
          <path fill="currentColor" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
          <path fill="currentColor" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
          <path fill="currentColor" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
          <path fill="currentColor" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
        </svg>
        Entrar con Google
      </button>
    </div>
  </div>
</template>

<script setup>
import { LogIn } from 'lucide-vue-next';
import { useAuth } from '../composables/useAuth';

const { loginWithGoogle } = useAuth();
</script>
