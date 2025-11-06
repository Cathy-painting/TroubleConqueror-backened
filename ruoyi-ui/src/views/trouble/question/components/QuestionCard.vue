<template>
  <div
    class="question-card flat-card"
    :class="{ 'has-image': hasImages }"
    @click="handleClick"
  >
    <!-- 有图片的卡片布局 -->
    <div v-if="hasImages" class="card-with-image">
      <!-- 图片区域 -->
      <div class="image-section">
        <div class="image-container">
          <el-image
            :src="getImageUrl(imageArray[0])"
            fit="cover"
            class="main-image"
            :preview-src-list="previewList"
            :initial-index="0"
          />
          <div v-if="imageCount > 1" class="image-count-badge">
            <i class="el-icon-picture"></i>
            {{ imageCount }}
          </div>
        </div>
      </div>

      <!-- 内容区域 -->
      <div class="content-section">
        <div class="card-header">
          <el-tag
            :type="getTypeTagType(question.questionType)"
            size="small"
            class="flat-tag"
            effect="plain"
          >
            {{ question.questionType || '未区分' }}
          </el-tag>
          <span class="create-time">
            {{ formatTime(question.createTime) }}
          </span>
        </div>

        <h3 class="question-title" :title="question.questionContent">
          {{ question.questionContent }}
        </h3>

        <div class="tags-section" v-if="question.tags">
          <span
            v-for="(tag, idx) in displayTags"
            :key="idx"
            class="tag-chip"
          >
            {{ tag }}
          </span>
        </div>

        <div class="card-actions" @click.stop>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-view"
            @click="handleView"
          >查看</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleEdit"
          >编辑</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-star-on"
            @click="handleFavorite"
            :style="{ color: question.isFavorite ? '#f56c6c' : '#909399' }"
          >收藏</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete"
            style="color: #f56c6c;"
          >删除</el-button>
        </div>
      </div>
    </div>

    <!-- 无图片的卡片布局 -->
    <div v-else class="card-no-image">
      <div class="card-header">
        <div class="header-left">
          <el-tag
            :type="getTypeTagType(question.questionType)"
            size="small"
            class="flat-tag"
            effect="plain"
          >
            {{ question.questionType || '未区分' }}
          </el-tag>
        </div>
        <span class="create-time">
          {{ formatTime(question.createTime) }}
        </span>
      </div>

      <h3 class="question-title" :title="question.questionContent">
        {{ question.questionContent }}
      </h3>

      <div class="tags-section" v-if="question.tags">
        <span
          v-for="(tag, idx) in tagArray"
          :key="idx"
          class="tag-chip"
        >
          {{ tag }}
        </span>
      </div>

      <div class="card-actions" @click.stop>
        <el-button
          size="mini"
          type="text"
          icon="el-icon-view"
          @click="handleView"
        >查看</el-button>
        <el-button
          size="mini"
          type="text"
          icon="el-icon-edit"
          @click="handleEdit"
        >编辑</el-button>
        <el-button
          size="mini"
          type="text"
          icon="el-icon-star-on"
          @click="handleFavorite"
          :style="{ color: question.isFavorite ? '#f56c6c' : '#909399' }"
        >收藏</el-button>
        <el-button
          size="mini"
          type="text"
          icon="el-icon-delete"
          @click="handleDelete"
          style="color: #f56c6c;"
        >删除</el-button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "QuestionCard",
  props: {
    question: {
      type: Object,
      required: true
    }
  },
  emits: ['view', 'edit', 'favorite', 'delete', 'click'],
  computed: {
    hasImages() {
      return this.question.questionImages && this.question.questionImages.trim() !== '';
    },
    imageArray() {
      if (!this.hasImages) return [];
      return this.question.questionImages.split(',').filter(img => img.trim());
    },
    imageCount() {
      return this.imageArray.length;
    },
    previewList() {
      return this.imageArray.map(img => this.getImageUrl(img));
    },
    tagArray() {
      if (!this.question.tags) return [];
      return this.question.tags.split(',').filter(tag => tag.trim());
    },
    displayTags() {
      return this.tagArray.slice(0, 3);
    }
  },
  methods: {
    handleClick() {
      this.$emit('click', this.question);
    },
    handleView() {
      this.$emit('view', this.question);
    },
    handleEdit() {
      this.$emit('edit', this.question);
    },
    handleFavorite() {
      this.$emit('favorite', this.question);
    },
    handleDelete() {
      this.$emit('delete', this.question);
    },
    getImageUrl(imagePath) {
      if (!imagePath) return '';
      if (imagePath.startsWith('http')) {
        return imagePath;
      }
      const baseUrl = process.env.VUE_APP_BASE_API;
      return baseUrl + (imagePath.startsWith('/') ? imagePath : '/' + imagePath);
    },
    formatTime(time) {
      if (!time) return '';
      return this.parseTime(time, '{y}-{m}-{d}');
    },
    getTypeTagType(type) {
      const typeMap = {
        '选择题': 'success',
        '填空题': 'warning',
        '解答题': 'danger',
        '未区分': 'info'
      };
      return typeMap[type] || 'info';
    },
    parseTime(time, pattern) {
      if (!time) return '';
      const date = new Date(time);
      const formatObj = {
        y: date.getFullYear(),
        m: date.getMonth() + 1,
        d: date.getDate(),
        h: date.getHours(),
        i: date.getMinutes(),
        s: date.getSeconds()
      };
      const format = pattern || '{y}-{m}-{d} {h}:{i}:{s}';
      return format.replace(/{(\w+)}/g, (result, key) => {
        const value = formatObj[key];
        return value < 10 ? '0' + value : value;
      });
    }
  }
};
</script>

<style scoped>
.flat-card {
  background: #ffffff;
  border-radius: 0;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12), 0 1px 2px rgba(0, 0, 0, 0.24);
  transition: box-shadow 0.2s ease;
  cursor: pointer;
  overflow: hidden;
  border: 1px solid #e0e0e0;
}

.flat-card:hover {
  box-shadow: 0 3px 6px rgba(0, 0, 0, 0.16), 0 3px 6px rgba(0, 0, 0, 0.23);
}

/* 有图片的卡片 */
.card-with-image {
  display: flex;
  flex-direction: column;
  height: 100%;
}

.image-section {
  width: 100%;
  height: 200px;
  background: #f5f5f5;
  position: relative;
  overflow: hidden;
}

.image-container {
  width: 100%;
  height: 100%;
  position: relative;
}

.main-image {
  width: 100%;
  height: 100%;
  display: block;
}

.main-image >>> .el-image__inner {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.image-count-badge {
  position: absolute;
  top: 8px;
  right: 8px;
  background: rgba(0, 0, 0, 0.6);
  color: #ffffff;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  display: flex;
  align-items: center;
  gap: 4px;
}

.content-section {
  flex: 1;
  padding: 16px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

/* 无图片的卡片 */
.card-no-image {
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 8px;
}

.flat-tag {
  border-radius: 4px;
  border: none;
  font-weight: 500;
}

.create-time {
  font-size: 12px;
  color: #9e9e9e;
}

.question-title {
  font-size: 15px;
  font-weight: 500;
  color: #212121;
  line-height: 1.5;
  margin: 0;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
}

.card-no-image .question-title {
  -webkit-line-clamp: 4;
  font-size: 16px;
}

.tags-section {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  margin-top: auto;
}

.tag-chip {
  display: inline-block;
  padding: 4px 10px;
  background: #f5f5f5;
  color: #616161;
  border-radius: 16px;
  font-size: 12px;
  line-height: 1.4;
}

.card-actions {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-top: 8px;
  flex-wrap: wrap;
}

.card-actions .el-button {
  padding: 4px 8px;
  font-size: 12px;
}

.card-actions .el-button:hover {
  background-color: rgba(33, 150, 243, 0.1);
  border-radius: 4px;
}

@media (max-width: 768px) {
  .image-section {
    height: 180px;
  }

  .content-section {
    padding: 12px;
  }

  .card-no-image {
    padding: 16px;
  }

  .question-title {
    font-size: 14px;
  }
}
</style>