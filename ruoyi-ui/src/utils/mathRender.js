/**
 * 渲染包含数学公式的文本内容
 * @param {string} content - 原始文本
 * @returns {string} - 渲染后的HTML字符串
 */
export function renderMathContent(content) {
  if (!content) return "";

  const escapeHtml = (text) => {
    return text
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#039;");
  };

  const parts = [];
  let lastIndex = 0;
  const regex = /\$([^$]+)\$/g;
  let match;

  while ((match = regex.exec(content)) !== null) {
    if (match.index > lastIndex) {
      const text = content.substring(lastIndex, match.index);
      parts.push({ type: "text", content: escapeHtml(text) });
    }
    parts.push({ type: "math", content: match[1] });
    lastIndex = regex.lastIndex;
  }

  if (lastIndex < content.length) {
    const text = content.substring(lastIndex);
    parts.push({ type: "text", content: escapeHtml(text) });
  }

  if (parts.length === 0) {
    return escapeHtml(content).replace(/\n/g, "<br>");
  }

  const renderedParts = parts.map((part) => {
    if (part.type === "text") {
      return part.content.replace(/\n/g, "<br>");
    } else {
      try {
        if (typeof katex !== "undefined") {
          return katex.renderToString(part.content, {
            throwOnError: false,
            displayMode: false,
            output: "html",
          });
        } else {
          return `<span class="math-fallback">$${escapeHtml(
            part.content
          )}$</span>`;
        }
      } catch (e) {
        console.warn("公式渲染失败:", part.content, e);
        return `<span class="math-error">$${escapeHtml(part.content)}$</span>`;
      }
    }
  });

  return renderedParts.join("");
}

/**
 * Vue Mixin - 在组件中混入使用
 */
export const MathRenderMixin = {
  methods: {
    renderMath(content) {
      return renderMathContent(content);
    },
  },
};
