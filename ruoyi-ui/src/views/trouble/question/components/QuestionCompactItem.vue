<template>
  <div
    class="question-compact-item"
    @click="handleClick"
  >
    <div class="compact-content">
      <div class="compact-left">
        <div class="compact-icon" v-if="!hasImages">
          <i class="el-icon-document"></i>
        </div>
        <div class="compact-image" v-else>
          <el-image
            :src="getImageUrl(imageArray[0])"
            fit="cover"
            class="compact-img"
          />
        </div>
        <div class="compact-info">
          <div class="compact-header">
            <el-tag
              :type="getTypeTagType(question.questionType)"
              size="mini"
              class="compact-tag"
              effect="plain"
            >
              {{ question.questionType || '未区分' }}
            </el-tag>
            <span class="compact-time">{{ formatTime(question.createTime) }}</span>
          </div>
          <div class="compact-title" :title="question.questionContent">
            {{ question.questionContent }}
          </div>
        </div>
      </div>
      <div class="compact-right">
        <div class="compact-tags" v-if="question.tags">
          <span
            v-for="(tag, idx) in tagArray.slice(0, 2)"
            :key="idx"
            class="compact-tag-item"
          >
            {{ tag }}
          </span>
        </div>
        <div class="compact-actions" @click.stop>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-view"
            @click="handleView"
            title="查看"
          ></el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleEdit"
            title="编辑"
          ></el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-star-on"
            @click="handleFavorite"
            :style="{ color: question.isFavorite ? '#f56c6c' : '#909399' }"
            title="收藏"
          ></el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete"
            style="color: #f56c6c;"
            title="删除"
          ></el-button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "QuestionCompactItem",
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
    tagArray() {
      if (!this.question.tags) return [];
      return this.question.tags.split(',').filter(tag => tag.trim());
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
        d: date.getDate()
      };
      const format = pattern || '{y}-{m}-{d}';
      return format.replace(/{(\w+)}/g, (result, key) => {
        const value = formatObj[key];
        return value < 10 ? '0' + value : value;
      });
    }
  }
};
</script>

<style scoped>
.question-compact-item {
  background: #ffffff;
  border-bottom: 1px solid #e0e0e0;
  cursor: pointer;
  transition: background-color 0.2s ease;
}

.question-compact-item:hover {
  background: #f5f5f5;
}

.question-compact-item:last-child {
  border-bottom: none;
}

.compact-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 16px;
  gap: 16px;
}

.compact-left {
  display: flex;
  align-items: center;
  gap: 12px;
  flex: 1;
  min-width: 0;
}

.compact-icon {
  width: 32px;
  height: 32px;
  flex-shrink: 0;
  background: #f5f5f5;
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #757575;
  font-size: 16px;
}

.compact-image {
  width: 50px;
  height: 38px;
  flex-shrink: 0;
  background: #f5f5f5;
  border-radius: 4px;
  overflow: hidden;
}

.compact-img {
  width: 100%;
  height: 100%;
}

.compact-img >>> .el-image__inner {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.compact-info {
  flex: 1;
  min-width: 0;
}

.compact-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 4px;
}

.compact-tag {
  font-size: 11px;
  padding: 0 6px;
  height: 18px;
  line-height: 18px;
}

.compact-time {
  font-size: 11px;
  color: #9e9e9e;
}

.compact-title {
  font-size: 13px;
  color: #212121;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 1;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
}

.compact-right {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-shrink: 0;
}

.compact-tags {
  display: flex;
  gap: 6px;
}

.compact-tag-item {
  display: inline-block;
  padding: 2px 6px;
  background: #f5f5f5;
  color: #616161;
  border-radius: 10px;
  font-size: 10px;
  line-height: 1.4;
}

.compact-actions {
  display: flex;
  align-items: center;
  gap: 4px;
}

.compact-actions .el-button {
  padding: 4px;
  font-size: 14px;
}

.compact-actions .el-button:hover {
  background-color: rgba(33, 150, 243, 0.1);
  border-radius: 4px;
}

@media (max-width: 768px) {
  .compact-content {
    padding: 10px 12px;
    gap: 12px;
  }

  .compact-image {
    width: 40px;
    height: 30px;
  }

  .compact-icon {
    width: 28px;
    height: 28px;
    font-size: 14px;
  }

  .compact-title {
    font-size: 12px;
  }

  .compact-tags {
    display: none;
  }
}
</style>
