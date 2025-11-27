/**
 * 标签工具类
 * 用于管理用户自定义标签
 */

const CUSTOM_TAGS_KEY = 'trouble_question_custom_tags';

/**
 * 获取所有自定义标签
 * @returns {Array<string>} 自定义标签数组
 */
export function getCustomTags() {
  try {
    const tagsStr = localStorage.getItem(CUSTOM_TAGS_KEY);
    if (!tagsStr) return [];
    const tags = JSON.parse(tagsStr);
    return Array.isArray(tags) ? tags : [];
  } catch (error) {
    console.error('获取自定义标签失败:', error);
    return [];
  }
}

/**
 * 保存自定义标签
 * @param {string|Array<string>} tags 标签或标签数组
 */
export function saveCustomTags(tags) {
  try {
    const customTags = getCustomTags();
    const tagSet = new Set(customTags);
    
    // 支持单个标签或标签数组
    const tagsArray = Array.isArray(tags) ? tags : [tags];
    
    tagsArray.forEach(tag => {
      const trimmedTag = tag.trim();
      if (trimmedTag) {
        tagSet.add(trimmedTag);
      }
    });
    
    const updatedTags = Array.from(tagSet).sort();
    localStorage.setItem(CUSTOM_TAGS_KEY, JSON.stringify(updatedTags));
    return updatedTags;
  } catch (error) {
    console.error('保存自定义标签失败:', error);
    return [];
  }
}

/**
 * 从题目标签中提取并保存自定义标签
 * @param {string} tagsStr 逗号分隔的标签字符串
 */
export function extractAndSaveTags(tagsStr) {
  if (!tagsStr) return;
  
  const tags = tagsStr.split(',').map(tag => tag.trim()).filter(tag => tag);
  if (tags.length > 0) {
    saveCustomTags(tags);
  }
}

/**
 * 获取所有标签（系统标签 + 自定义标签）
 * @param {Array<string>} systemTags 系统预设标签
 * @returns {Array<string>} 所有标签的合并数组
 */
export function getAllTags(systemTags = []) {
  const customTags = getCustomTags();
  const allTagsSet = new Set([...systemTags, ...customTags]);
  return Array.from(allTagsSet).sort();
}

/**
 * 根据输入内容过滤标签（支持模糊匹配）
 * @param {Array<string>} tags 标签数组
 * @param {string} query 搜索关键词
 * @returns {Array<string>} 过滤后的标签数组
 */
export function filterTagsByQuery(tags, query) {
  if (!query || !query.trim()) return tags;
  
  const queryLower = query.trim().toLowerCase();
  return tags.filter(tag => 
    tag.toLowerCase().includes(queryLower)
  );
}

/**
 * 清除所有自定义标签
 */
export function clearCustomTags() {
  try {
    localStorage.removeItem(CUSTOM_TAGS_KEY);
    return true;
  } catch (error) {
    console.error('清除自定义标签失败:', error);
    return false;
  }
}

