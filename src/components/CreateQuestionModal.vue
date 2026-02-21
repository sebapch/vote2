<template>
  <div class="fixed inset-0 z-[200] flex items-end sm:items-center justify-center">
    <!-- Backdrop -->
    <div class="absolute inset-0 bg-black/20 backdrop-blur-[2px]" @click="$emit('close')"></div>
    
    <!-- Modal Sheet -->
    <div class="relative w-full sm:max-w-md bg-white sm:rounded-3xl rounded-t-3xl overflow-hidden border-t border-slate-200 sm:border shadow-2xl shadow-slate-300/20">
      
      <!-- Mobile drag handle -->
      <div class="w-10 h-1 rounded-full bg-slate-200 mx-auto mt-3 mb-1 sm:hidden"></div>

      <div class="p-6">
        <!-- Header -->
        <div class="flex items-center justify-between mb-6">
          <h2 class="text-base font-bold text-slate-900">{{ $t('create.title') }}</h2>
          <button 
            @click="$emit('close')" 
            class="w-8 h-8 rounded-xl bg-slate-100 flex items-center justify-center text-slate-400 hover:text-slate-700 transition-colors"
          >
            <X :size="16" />
          </button>
        </div>

        <form @submit.prevent="handleSubmit" class="space-y-4">
          <!-- Question textarea -->
          <textarea 
            v-model="form.text"
            :placeholder="$t('create.placeholder')"
            class="w-full bg-slate-50 border border-slate-200 rounded-2xl p-4 text-sm font-medium text-slate-900 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-400 transition-all resize-none leading-relaxed"
            rows="3"
            required
            autofocus
          ></textarea>

          <!-- Image zone -->
          <div>
            <!-- Preview -->
            <div v-if="imagePreview" class="relative rounded-2xl overflow-hidden border border-slate-200">
              <img :src="imagePreview" class="w-full h-36 object-cover" />
              <div class="absolute inset-0 bg-gradient-to-t from-black/30 to-transparent"></div>
              <button 
                type="button"
                @click="clearImage"
                class="absolute top-2.5 right-2.5 w-7 h-7 bg-white rounded-xl border border-slate-200 flex items-center justify-center text-slate-500 hover:text-red-500 transition-colors shadow-sm"
              >
                <X :size="13" />
              </button>
              <span class="absolute bottom-2 left-3 text-[10px] font-bold text-white/80">
                {{ imageSize }} · {{ $t('create.image_compressed') }}
              </span>
            </div>

            <!-- Drop Zone -->
            <div 
              v-else
              class="relative border border-dashed rounded-2xl flex flex-col items-center justify-center gap-2.5 py-6 cursor-pointer transition-all"
              :class="isDragging 
                ? 'border-blue-400 bg-blue-50/50' 
                : 'border-slate-200 hover:border-slate-300 hover:bg-slate-50'"
              @dragover.prevent="isDragging = true"
              @dragleave.prevent="isDragging = false"
              @drop.prevent="onDrop"
              @click="fileInputRef?.click()"
            >
              <div class="w-9 h-9 rounded-xl bg-white border border-slate-200 flex items-center justify-center shadow-sm">
                <ImageIcon :size="18" class="text-slate-400" />
              </div>
              <div class="text-center px-4">
                <p class="text-xs font-semibold text-slate-600">
                  {{ isDragging ? $t('create.image_label') : $t('create.image_label') }}
                </p>
                <p class="text-[10px] text-slate-400 mt-0.5">{{ $t('create.image_hint') }}</p>
              </div>
              <input 
                ref="fileInputRef"
                type="file"
                accept="image/*"
                class="hidden"
                @change="onFileSelect"
              />
            </div>
          </div>

          <!-- Submit -->
          <button 
            type="submit"
            :disabled="!form.text.trim() || isUploading"
            class="w-full py-3.5 bg-slate-900 text-white text-sm font-bold rounded-2xl hover:bg-blue-600 disabled:opacity-30 disabled:cursor-not-allowed transition-all active:scale-[0.98] flex items-center justify-center gap-2"
          >
            <Loader2 v-if="isUploading" :size="16" class="animate-spin" />
            <span>{{ isUploading ? $t('create.uploading') : $t('create.submit') }}</span>
          </button>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue';
import { X, ImageIcon, Loader2 } from 'lucide-vue-next';
import { supabase } from '../lib/supabase';
import { useAuth } from '../composables/useAuth';

const emit = defineEmits(['close', 'create']);
const { user } = useAuth();

const form = reactive({ text: '', category: 'General' });
const imagePreview = ref(null);
const imageBlob = ref(null);
const imageSize = ref(null);
const isDragging = ref(false);
const isUploading = ref(false);
const fileInputRef = ref(null);

const clearImage = () => {
  imagePreview.value = null;
  imageBlob.value = null;
  imageSize.value = null;
};

const formatBytes = (bytes) => {
  if (bytes < 1024) return bytes + ' B';
  if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(0) + ' KB';
  return (bytes / (1024 * 1024)).toFixed(1) + ' MB';
};

const compressImage = (file) => {
  return new Promise((resolve) => {
    const img = new Image();
    const url = URL.createObjectURL(file);
    img.onload = () => {
      const maxWidth = 800;
      const ratio = Math.min(maxWidth / img.width, 1);
      const canvas = document.createElement('canvas');
      canvas.width = Math.round(img.width * ratio);
      canvas.height = Math.round(img.height * ratio);
      canvas.getContext('2d').drawImage(img, 0, 0, canvas.width, canvas.height);
      canvas.toBlob((blob) => {
        URL.revokeObjectURL(url);
        resolve(blob);
      }, 'image/webp', 0.60);
    };
    img.src = url;
  });
};

const processFile = async (file) => {
  if (!file || !file.type.startsWith('image/')) return;
  const compressed = await compressImage(file);
  imagePreview.value = URL.createObjectURL(compressed);
  imageBlob.value = compressed;
  imageSize.value = formatBytes(compressed.size);
};

const onFileSelect = (e) => processFile(e.target.files?.[0]);
const onDrop = (e) => {
  isDragging.value = false;
  processFile(e.dataTransfer?.files?.[0]);
};

const uploadImage = async () => {
  if (!imageBlob.value || !user.value) return null;
  const path = `${user.value.id}_${Date.now()}.webp`;
  const { data, error } = await supabase.storage
    .from('vote-images')
    .upload(path, imageBlob.value, { contentType: 'image/webp', upsert: true });
  if (error) { console.error(error.message); return null; }
  return supabase.storage.from('vote-images').getPublicUrl(data.path).data.publicUrl;
};

const handleSubmit = async () => {
  if (!form.text.trim()) return;
  isUploading.value = true;
  const imageUrl = imageBlob.value ? await uploadImage() : null;
  emit('create', { text: form.text, category: form.category, image: imageUrl });
  isUploading.value = false;
};
</script>
