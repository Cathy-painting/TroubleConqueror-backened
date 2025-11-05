<template>
  <div
    class="question-list-item"
    :class="{ 'has-image': hasImages }"
    @click="handleClick"
  >
    <!-- 有图片的列表项 -->
    <div v-if="hasImages" class="list-item-with-image">
      <div class="item-image">
        <el-image
          :src="getImageUrl(imageArray[0])"
          fit="cover"
          class="list-image"
          :preview-src-list="previewList"
          :initial-index="0"
        />
        <div v-if="imageCount > 1" class="image-count">
          <i class="el-icon-picture"></i>
          {{ imageCount }}
        </div>
      </div>
      <div class="item-content">
        <div class="item-header">
          <el-tag
            :type="getTypeTagType(question.questionType)"
            size="small"
            class="item-type-tag"
            effect="plain"
          >
            {{ question.questionType || '未区分' }}
          </el-tag>
          <span class="item-time">{{ formatTime(question.createTime) }}</span>
        </div>
        <div class="item-title" :title="question.questionContent">
          {{ question.questionContent }}
        </div>
        <div class="item-footer">
          <div class="item-tags" v-if="question.tags">
            <span
              v-for="(tag, idx) in tagArray.slice(0, 3)"
              :key="idx"
              class="item-tag"
            >
              {{ tag }}
            </span>
          </div>
          <span class="item-view">查看详情 <i class="el-icon-arrow-right"></i></span>
        </div>
      </div>
    </div>

    <!-- 无图片的列表项 -->
    <div v-else class="list-item-no-image">
      <div class="item-icon">
        <i class="el-icon-document"></i>
      </div>
      <div class="item-content">
        <div class="item-header">
          <el-tag
            :type="getTypeTagType(question.questionType)"
            size="small"
            class="item-type-tag"
            effect="plain"
          >
            {{ question.questionType || '未区分' }}
          </el-tag>
          <span class="item-time">{{ formatTime(question.createTime) }}</span>
        </div>
        <div class="item-title" :title="question.questionContent">
          {{ question.questionContent }}
        </div>
        <div class="item-footer">
          <div class="item-tags" v-if="question.tags">
            <span
              v-for="(tag, idx) in tagArray"
              :key="idx"
              class="item-tag"
            >
              {{ tag }}
            </span>
          </div>
          <span class="item-view">查看详情 <i class="el-icon-arrow-right"></i></span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "QuestionListItem",
  props: {
    question: {
      type: Object,
      required: true
    }
  },
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
    }
  },
  methods: {
    handleClick() {
      this.$emit('click', this.question);
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
.question-list-item {
  background: #ffffff;
  border: 1px solid #e0e0e0;
  border-radius: 0;
  cursor: pointer;
  transition: all 0.2s ease;
  margin-bottom: 1px;
}

.question-list-item:hover {
  background: #fafafa;
  border-color: #2196f3;
  box-shadow: 0 2px 4px rgba(33, 150, 243, 0.1);
}

/* 有图片的列表项 */
.list-item-with-image {
  display: flex;
  align-items: stretch;
  padding: 12px;
  gap: 16px;
}

.item-image {
  width: 120px;
  height: 90px;
  flex-shrink: 0;
  background: #f5f5f5;
  position: relative;
  overflow: hidden;
  border-radius: 4px;
}

.list-image {
  width: 100%;
  height: 100%;
}

.list-image >>> .el-image__inner {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.image-count {
  position: absolute;
  top: 4px;
  right: 4px;
  background: rgba(0, 0, 0, 0.6);
  color: #ffffff;
  padding: 2px 6px;
  border-radius: 3px;
  font-size: 11px;
  display: flex;
  align-items: center;
  gap: 2px;
}

.item-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 8px;
  min-width: 0;
}

/* 无图片的列表项 */
.list-item-no-image {
  display: flex;
  align-items: flex-start;
  padding: 16px;
  gap: 16px;
}

.item-icon {
  width: 40px;
  height: 40px;
  flex-shrink: 0;
  background: #f5f5f5;
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #757575;
  font-size: 20px;
}

.item-header {
  display: flex;
  align-items: center;
  gap: 12px;
}

.item-type-tag {
  border-radius: 4px;
  font-weight: 500;
}

.item-time {
  font-size: 12px;
  color: #9e9e9e;
}

.item-title {
  font-size: 14px;
  font-weight: 500;
  color: #212121;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
  flex: 1;
}

.list-item-no-image .item-title {
  -webkit-line-clamp: 3;
}

.item-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.item-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  flex: 1;
}

.item-tag {
  display: inline-block;
  padding: 2px 8px;
  background: #f5f5f5;
  color: #616161;
  border-radius: 12px;
  font-size: 11px;
  line-height: 1.4;
}

.item-view {
  color: #2196f3;
  font-size: 12px;
  font-weight: 500;
  display: flex;
  align-items: center;
  gap: 4px;
  flex-shrink: 0;
}

.item-view i {
  transition: transform 0.2s;
}

.question-list-item:hover .item-view i {
  transform: translateX(2px);
}

@media (max-width: 768px) {
  .list-item-with-image {
    flex-direction: column;
    padding: 12px;
  }

  .item-image {
    width: 100%;
    height: 150px;
  }

  .list-item-no-image {
    padding: 12px;
  }

  .item-footer {
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
  }
}
</style>
