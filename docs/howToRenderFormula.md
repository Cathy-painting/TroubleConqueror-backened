# 数学公式渲染指南

## 📖 在组件中使用

### 方法1: 直接导入函数

```vue
<template>
  <div>
    <!-- 显示原始内容 -->
    <el-input v-model="questionContent" type="textarea" />

    <!-- 预览渲染后的公式 -->
    <div class="math-preview">
      <div class="preview-label">预览:</div>
      <div class="preview-content" v-html="renderedContent"></div>
    </div>
  </div>
</template>

<script>
import { renderMathContent } from "@/utils/mathRender";

export default {
  data() {
    return {
      questionContent: "解方程 $x^2 + 2x + 1 = 0$",
      renderedContent: "",
    };
  },
  watch: {
    // 监听内容变化,自动渲染
    questionContent: {
      handler(newVal) {
        this.renderedContent = renderMathContent(newVal);
      },
      immediate: true,
    },
  },
  methods: {
    // 或者在方法中手动渲染
    updatePreview() {
      this.renderedContent = renderMathContent(this.questionContent);
    },
  },
};
</script>
```

### 方法2: 使用 Mixin

```vue
<template>
  <div>
    <div v-html="renderMath(questionContent)"></div>
  </div>
</template>

<script>
import { MathRenderMixin } from "@/utils/mathRender";

export default {
  mixins: [MathRenderMixin],
  data() {
    return {
      questionContent: "求导: $f(x) = x^3 + 2x^2 + x + 1$",
    };
  },
};
</script>
```

### 方法3: 使用防抖优化性能

对于频繁输入的场景,建议使用防抖:

```vue
<template>
  <div>
    <el-input v-model="content" type="textarea" @input="debouncedRender" />
    <div v-html="rendered"></div>
  </div>
</template>

<script>
import { renderMathContent } from "@/utils/mathRender";

export default {
  data() {
    return {
      content: "",
      rendered: "",
      renderTimer: null,
    };
  },
  methods: {
    debouncedRender() {
      if (this.renderTimer) {
        clearTimeout(this.renderTimer);
      }
      this.renderTimer = setTimeout(() => {
        this.rendered = renderMathContent(this.content);
      }, 500); // 500ms防抖
    },
  },
  beforeDestroy() {
    if (this.renderTimer) {
      clearTimeout(this.renderTimer);
    }
  },
};
</script>
```

---

## 🎨 样式配置

在组件或全局样式中添加:

```css
/* 数学公式预览区域 */
.math-preview {
  margin-top: 12px;
  padding: 16px;
  background: #f8fbff;
  border: 1px solid #d4e8f7;
  border-radius: 8px;
  transition: all 0.3s;
}

.math-preview:hover {
  border-color: #2a5298;
  box-shadow: 0 2px 8px rgba(42, 82, 152, 0.1);
}

.preview-label {
  font-size: 13px;
  color: #7a8a9a;
  margin-bottom: 8px;
  font-weight: 500;
}

.preview-content {
  font-size: 15px;
  line-height: 1.8;
  color: #2c3e50;
  min-height: 24px;
}

/* KaTeX 公式样式优化 */
.preview-content .katex {
  font-size: 1.1em;
}

/* 公式渲染失败或未加载时的样式 */
.math-fallback {
  color: #e67e22;
  background: #fef5e7;
  padding: 2px 6px;
  border-radius: 4px;
  font-family: "Courier New", monospace;
}

.math-error {
  color: #e74c3c;
  background: #fadbd8;
  padding: 2px 6px;
  border-radius: 4px;
  font-family: "Courier New", monospace;
}
```

## 🔍 调试技巧

如果公式没有正确渲染,检查:

1. KaTeX CDN 是否正确加载 (F12 控制台检查)
2. 公式语法是否正确 (参考 [KaTeX文档](https://katex.org/docs/supported.html))
3. 是否正确使用了 `v-html` 指令
4. 浏览器控制台是否有错误信息

---

## 📚 更多资源

- [KaTeX 官方文档](https://katex.org/)
- [支持的LaTeX函数列表](https://katex.org/docs/supported.html)
- [LaTeX 数学符号速查](https://www.cmor-faculty.rice.edu/~heinken/latex/symbols.pdf)
