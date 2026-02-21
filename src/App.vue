<template>
  <div class="min-h-screen w-full bg-[#F4F4F7] text-slate-900">

    <!-- Auth not yet resolved: show blank or spinner -->
    <div v-if="!authInitialized" class="flex items-center justify-center min-h-screen">
      <div class="flex flex-col items-center gap-3 opacity-30">
        <div class="w-8 h-8 border-[3px] border-slate-300 border-t-blue-600 rounded-full animate-spin"></div>
        <p class="font-bold text-[10px] uppercase tracking-widest text-slate-500">{{ $t('app.loading') }}</p>
      </div>
    </div>

    <!-- Auth resolved: not logged in -->
    <LoginView v-else-if="!user" />

    <!-- Auth resolved: logged in -->
    <template v-else>
      <AppHeader :activeTab="currentTab" @navigate="currentTab = $event" />

      <main class="w-full flex items-center justify-center pt-16 pb-24 min-h-screen px-4">
        <!-- Data loading -->
        <div v-if="loading" class="flex flex-col items-center gap-3 opacity-30">
          <div class="w-8 h-8 border-[3px] border-slate-300 border-t-blue-600 rounded-full animate-spin"></div>
          <p class="font-bold text-[10px] uppercase tracking-widest text-slate-500">{{ $t('app.syncing') }}</p>
        </div>

        <template v-else>
          <FeedView
            v-if="currentTab === 'feed'"
            ref="feedRef"
            @reload="handleReload"
          />
          <ResultsView
            v-else-if="currentTab === 'results'"
            :questions="questions"
          />
          <ProfileView
            v-else-if="currentTab === 'profile'"
            :votesCount="userVotes.length"
            :createdCount="userCreatedCount"
            :history="profileHistory"
          />
        </template>
      </main>

      <BottomNav
        :activeTab="currentTab"
        @navigate="currentTab = $event"
        @openCreate="showCreateModal = true"
      />

      <CreateQuestionModal
        v-if="showCreateModal"
        @close="showCreateModal = false"
        @create="handleCreate"
      />
    </template>

  </div>
</template>

<script setup>
import { ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import { useAuth } from './composables/useAuth'
import { useVoteData } from './composables/useVoteData'

import LoginView from './views/LoginView.vue'
import FeedView from './views/FeedView.vue'
import AppHeader from './components/AppHeader.vue'
import BottomNav from './components/BottomNav.vue'
import ResultsView from './components/ResultsView.vue'
import ProfileView from './components/ProfileView.vue'
import CreateQuestionModal from './components/CreateQuestionModal.vue'

const { user, authInitialized } = useAuth()
const { questions, userVotes, userCreatedCount, profileHistory, loading, fetchData, createQuestion, clearData } = useVoteData()

const currentTab = ref('feed')
const showCreateModal = ref(false)
const feedRef = ref(null)
const { locale } = useI18n()

// Single watcher: fetch when user logs in, clear when logs out
watch(user, (newUser, oldUser) => {
  if (newUser && newUser.id !== oldUser?.id) {
    fetchData()
  } else if (!newUser) {
    clearData()
  }
}, { immediate: true })

// Watch for language changes to refetch filtered questions
watch(locale, async () => {
  if (user.value) {
    await fetchData()
    feedRef.value?.reset()
  }
})

const handleReload = async () => {
  await fetchData()
  feedRef.value?.reset()
}

const handleCreate = async (payload) => {
  const created = await createQuestion(payload)
  if (created) {
    showCreateModal.value = false
    currentTab.value = 'feed'
    feedRef.value?.reset()
  }
}
</script>
