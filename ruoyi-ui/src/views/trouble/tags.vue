<template>
  <div class="tags-page app-container">
    <!-- Header -->
    <div class="page-header">
      <div class="header-left">
        <div class="icon-wrapper">
          <i class="el-icon-collection-tag header-icon"></i>
        </div>
        <div class="header-text">
          <h2 class="header-title">标签分析</h2>
          <p class="header-desc">
            交互式标签云、饼图与错题列表 — 支持搜索、筛选与响应式布局
          </p>
        </div>
      </div>

      <div class="header-actions">
        <el-input
          v-model="keyword"
          placeholder="搜索题目内容 / 标签"
          size="small"
          clearable
          @clear="onSearchClear"
          @keyup.enter.native="onSearch"
          class="search-input"
        >
          <i slot="prefix" class="el-input__icon el-icon-search"></i>
        </el-input>

        <el-button
          type="primary"
          size="small"
          icon="el-icon-refresh"
          @click="refresh"
          class="action-btn"
        >
          刷新
        </el-button>
        <el-button
          type="info"
          plain
          size="small"
          icon="el-icon-back"
          @click="goBack"
          class="action-btn back-btn"
        >
          返回
        </el-button>
      </div>
    </div>

    <!-- Overview -->
    <el-row :gutter="16" class="overview-row">
      <el-col :xs="12" :sm="6" :md="6">
        <div class="overview-card card-1">
          <div class="card-icon">
            <i class="el-icon-collection"></i>
          </div>
          <div class="card-content">
            <div class="label">标签总数</div>
            <div class="value">{{ tagsCount }}</div>
            <div class="sub">不同标签数量</div>
          </div>
        </div>
      </el-col>

      <el-col :xs="12" :sm="6" :md="6">
        <div class="overview-card card-2">
          <div class="card-icon">
            <i class="el-icon-document"></i>
          </div>
          <div class="card-content">
            <div class="label">错题总数</div>
            <div class="value">{{ totalQuestions }}</div>
            <div class="sub">全部错题数量</div>
          </div>
        </div>
      </el-col>

      <el-col :xs="12" :sm="6" :md="6">
        <div class="overview-card card-3">
          <div class="card-icon">
            <i class="el-icon-search"></i>
          </div>
          <div class="card-content">
            <div class="label">命中筛选</div>
            <div class="value">{{ filteredCount }}</div>
            <div class="sub">当前筛选结果</div>
          </div>
        </div>
      </el-col>

      <el-col :xs="12" :sm="6" :md="6">
        <div class="overview-card card-4">
          <div class="card-icon">
            <i class="el-icon-star-on"></i>
          </div>
          <div class="card-content">
            <div class="label">活跃标签</div>
            <div class="value truncate">{{ topTagLabel }}</div>
            <div class="sub">出现最多的标签</div>
          </div>
        </div>
      </el-col>
    </el-row>

    <!-- Main content: tag cloud + charts + list -->
    <el-row :gutter="16" class="main-row">
      <el-col :xs="24" :lg="10" class="left-panel">
        <!-- Tag Cloud Card -->
        <el-card class="panel-card tag-cloud-card" shadow="hover">
          <div slot="header" class="card-header">
            <div class="header-title-wrap">
              <i class="el-icon-price-tag"></i>
              <span>标签云</span>
            </div>
            <el-button
              size="mini"
              type="text"
              @click="clearTagFilter"
              v-if="activeTagFilter"
              class="clear-btn"
            >
              <i class="el-icon-close"></i> 清除筛选
            </el-button>
          </div>

          <div class="tag-cloud" ref="tagCloud">
            <template v-if="tagItems.length">
              <a
                v-for="tag in tagItems"
                :key="tag.name"
                class="tag-chip"
                :class="[
                  `weight-${tag.weight}`,
                  { active: activeTagFilter === tag.name },
                ]"
                @click.prevent="goToViewWithTag(tag.name)"
                @mouseenter="hoverTag(tag)"
                @mouseleave="hoverTag(null)"
                :title="`${tag.name} — ${tag.count} 道题`"
              >
                <span class="tag-text">{{ tag.name }}</span>
                <span class="tag-count">{{ tag.count }}</span>
              </a>
            </template>
            <div v-else class="empty-cloud">
              <i class="el-icon-info"></i>
              <p>暂无标签数据</p>
            </div>
          </div>

          <div class="legend-bar">
            <div class="legend-item">
              <span class="legend-dot high"></span>
              <span class="legend-label">高频 (5-4)</span>
            </div>
            <div class="legend-item">
              <span class="legend-dot mid"></span>
              <span class="legend-label">中频 (3-2)</span>
            </div>
            <div class="legend-item">
              <span class="legend-dot low"></span>
              <span class="legend-label">低频 (1)</span>
            </div>
          </div>
        </el-card>

        <!-- Pie Chart Card -->
        <el-card class="panel-card pie-card" shadow="hover">
          <div slot="header" class="card-header">
            <div class="header-title-wrap">
              <i class="el-icon-pie-chart"></i>
              <span>标签占比</span>
            </div>
            <el-radio-group
              v-model="pieMode"
              size="mini"
              class="pie-mode-switch"
            >
              <el-radio-button label="top10">Top 10</el-radio-button>
              <el-radio-button label="all">全部</el-radio-button>
            </el-radio-group>
          </div>

          <div class="chart-wrapper" v-loading="!pieChart">
            <div ref="pieContainer" id="tagsPieChart"></div>
          </div>
        </el-card>
      </el-col>

      <el-col :xs="24" :lg="14" class="right-panel">
        <el-card class="panel-card list-card" shadow="hover">
          <div slot="header" class="card-header">
            <div class="header-title-wrap">
              <i class="el-icon-document-copy"></i>
              <span>错题列表</span>
              <el-tag
                v-if="activeTagFilter"
                type="primary"
                size="small"
                closable
                @close="clearTagFilter"
                class="filter-tag"
              >
                {{ activeTagFilter }}
              </el-tag>
            </div>
            <el-button
              size="mini"
              type="text"
              @click="clearAllFilters"
              class="clear-btn"
              v-if="hasActiveFilters"
            >
              <i class="el-icon-delete"></i> 清除所有
            </el-button>
          </div>

          <div class="table-toolbar">
            <div class="toolbar-left">
              <el-select
                v-model="sortOrder"
                size="small"
                placeholder="排序"
                @change="applySort"
                class="toolbar-select"
              >
                <el-option label="最新优先" value="new">
                  <i class="el-icon-sort-down"></i> 最新优先
                </el-option>
                <el-option label="最早优先" value="old">
                  <i class="el-icon-sort-up"></i> 最早优先
                </el-option>
              </el-select>

              <el-select
                v-model="proficiencyFilter"
                size="small"
                placeholder="熟练度"
                @change="applyFilters"
                class="toolbar-select"
                clearable
              >
                <el-option label="全部熟练度" :value="null"></el-option>
                <el-option label="陌生" :value="0">
                  <span class="prof-option prof-0">⭐ 陌生</span>
                </el-option>
                <el-option label="一般" :value="1">
                  <span class="prof-option prof-1">⭐⭐ 一般</span>
                </el-option>
                <el-option label="较好" :value="2">
                  <span class="prof-option prof-2">⭐⭐⭐ 较好</span>
                </el-option>
                <el-option label="熟练" :value="3">
                  <span class="prof-option prof-3">⭐⭐⭐ 熟练</span>
                </el-option>
              </el-select>
            </div>

            <el-button size="small" @click="toggleCompact" class="compact-btn">
              <i :class="compact ? 'el-icon-zoom-in' : 'el-icon-zoom-out'"></i>
              {{ compact ? "展开" : "紧凑" }}
            </el-button>
          </div>

          <el-table
            :data="pagedQuestions"
            stripe
            :row-key="(row) => row.questionId"
            style="width: 100%"
            size="medium"
            :class="{ 'compact-table': compact }"
            empty-text="暂无数据"
          >
            <el-table-column
              prop="questionContent"
              label="题目内容"
              min-width="300"
            >
              <template #default="{ row }">
                <div class="q-content">
                  <div
                    class="q-text"
                    v-html="
                      highlightKeyword(truncate(row.questionContent, 160))
                    "
                  ></div>
                  <div class="q-meta">
                    <div class="q-tags">
                      <el-tag
                        v-for="t in getTagsArray(row.tags)"
                        :key="t"
                        size="mini"
                        class="meta-tag"
                        @click="goToViewWithTag(t)"
                      >
                        {{ t }}
                      </el-tag>
                    </div>
                    <span class="meta-time">
                      <i class="el-icon-time"></i>
                      {{ formatTime(row.createTime) }}
                    </span>
                  </div>
                </div>
              </template>
            </el-table-column>

            <el-table-column
              prop="proficiency"
              width="130"
              label="熟练度"
              align="center"
            >
              <template #default="{ row }">
                <el-rate
                  :value="row.proficiency || 0"
                  disabled
                  show-score
                  max="3"
                  :colors="['#ff6b6b', '#ffa726', '#67c23a']"
                />
              </template>
            </el-table-column>

            <el-table-column
              label="操作"
              width="140"
              fixed="right"
              align="center"
            >
              <template #default="{ row }">
                <el-button
                  type="text"
                  size="small"
                  @click="viewQuestion(row)"
                  class="action-link"
                >
                  <i class="el-icon-view"></i> 查看
                </el-button>
                <el-button
                  type="text"
                  size="small"
                  @click="editQuestion(row)"
                  class="action-link"
                >
                  <i class="el-icon-edit"></i> 编辑
                </el-button>
              </template>
            </el-table-column>
          </el-table>

          <div class="pagination-wrap">
            <el-pagination
              background
              layout="total, sizes, prev, pager, next, jumper"
              :page-sizes="[5, 10, 20, 50]"
              :page-size.sync="pageSize"
              :current-page.sync="currentPage"
              :total="filteredCount"
              @size-change="onPageSizeChange"
              @current-change="onPageChange"
            />
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import * as echarts from "echarts";
import { listQuestion } from "@/api/trouble/question";

export default {
  name: "TroubleTags",
  data() {
    return {
      loading: false,
      questions: [],
      keyword: "",
      activeTagFilter: null,
      tagItems: [],
      pieMode: "top10",
      currentPage: 1,
      pageSize: 10,
      sortOrder: "new",
      proficiencyFilter: null,
      compact: false,
      pieChart: null,
      hoveredTag: null,
    };
  },
  computed: {
    totalQuestions() {
      return this.questions.length;
    },
    tagsCount() {
      return this.tagItems.length;
    },
    filteredQuestions() {
      let list = this.questions.slice();

      if (this.keyword && this.keyword.trim()) {
        const k = this.keyword.trim().toLowerCase();
        list = list.filter(
          (q) =>
            (q.questionContent || "").toLowerCase().includes(k) ||
            (q.tags || "").toLowerCase().includes(k)
        );
      }

      if (this.activeTagFilter) {
        list = list.filter((q) => {
          if (!q.tags) return false;
          return q.tags
            .split(/[,;，；\s]+/)
            .map((t) => t.trim())
            .filter(Boolean)
            .includes(this.activeTagFilter);
        });
      }

      if (
        this.proficiencyFilter !== null &&
        this.proficiencyFilter !== undefined
      ) {
        list = list.filter(
          (q) => Number(q.proficiency) === Number(this.proficiencyFilter)
        );
      }

      list.sort((a, b) => {
        const ta = new Date(a.createTime).getTime() || 0;
        const tb = new Date(b.createTime).getTime() || 0;
        return this.sortOrder === "old" ? ta - tb : tb - ta;
      });

      return list;
    },
    filteredCount() {
      return this.filteredQuestions.length;
    },
    pagedQuestions() {
      const start = (this.currentPage - 1) * this.pageSize;
      return this.filteredQuestions.slice(start, start + this.pageSize);
    },
    topTagLabel() {
      const top = this.tagItems[0];
      return top ? `${top.name} (${top.count})` : "无";
    },
    hasActiveFilters() {
      return (
        this.keyword || this.activeTagFilter || this.proficiencyFilter !== null
      );
    },
  },
  mounted() {
    this.init();
    window.addEventListener("resize", this.debounceResize);
  },
  beforeDestroy() {
    window.removeEventListener("resize", this.debounceResize);
    if (this.pieChart) {
      this.pieChart.dispose();
      this.pieChart = null;
    }
  },
  methods: {
    async init() {
      this.loading = true;
      try {
        const resp = await listQuestion({ pageNum: 1, pageSize: 5000 });
        const rows = resp.rows || resp || [];
        this.questions = rows.map((q) => ({ ...q, tags: q.tags || "" }));
        this.buildTagStats();
        this.$nextTick(() => {
          this.initPieChart();
          this.renderTagCloudLayout();
        });
      } catch (err) {
        console.error("加载标签数据失败", err);
        this.$message &&
          this.$message.error &&
          this.$message.error("加载标签数据失败");
      } finally {
        this.loading = false;
      }
    },

    buildTagStats() {
      const map = new Map();
      this.questions.forEach((q) => {
        if (!q.tags) return;
        q.tags
          .split(/[,;，；\s]+/)
          .map((t) => (t ? t.trim() : ""))
          .filter(Boolean)
          .forEach((name) => {
            map.set(name, (map.get(name) || 0) + 1);
          });
      });

      const arr = Array.from(map.entries()).map(([name, count]) => ({
        name,
        count,
      }));
      arr.sort((a, b) => b.count - a.count);

      const counts = arr.map((r) => r.count);
      const max = Math.max(...counts, 1);
      const min = Math.min(...counts, 0);
      const spread = Math.max(1, max - min);
      this.tagItems = arr.map((r) => {
        const weight = 1 + Math.round(((r.count - min) / spread) * 4);
        return { ...r, weight };
      });
    },

    goToViewWithTag(tagName) {
      if (!tagName) return;
      this.$router.push({
        path: "/trouble/question/view",
        query: { tags: tagName },
      });
    },

    clearTagFilter() {
      this.activeTagFilter = null;
      if (this.pieChart) {
        this.pieChart.dispatchAction({ type: "downplay", seriesIndex: 0 });
      }
    },

    hoverTag(tag) {
      this.hoveredTag = tag;
      if (tag && this.pieChart) {
        this.pieChart.dispatchAction({
          type: "highlight",
          seriesIndex: 0,
          name: tag.name,
        });
      } else if (this.pieChart) {
        this.pieChart.dispatchAction({ type: "downplay", seriesIndex: 0 });
      }
    },

    initPieChart() {
      const dom = document.getElementById("tagsPieChart");
      if (!dom) return;
      if (this.pieChart) {
        this.pieChart.dispose();
      }
      this.pieChart = echarts.init(dom);
      this.updatePieChart();

      this.pieChart.on("click", (params) => {
        if (params && params.name) {
          this.goToViewWithTag(params.name);
        }
      });
    },

    updatePieChart() {
      if (!this.pieChart) return;

      const data = (
        this.pieMode === "top10" ? this.tagItems.slice(0, 10) : this.tagItems
      ).map((t) => ({
        name: t.name,
        value: t.count,
      }));

      const isMobile = window.innerWidth < 768;

      const colors = [
        "#667eea",
        "#764ba2",
        "#f093fb",
        "#4facfe",
        "#43e97b",
        "#fa709a",
        "#fee140",
        "#30cfd0",
        "#a8edea",
        "#fed6e3",
      ];

      const option = {
        backgroundColor: "transparent",
        title: {
          show: false,
        },
        tooltip: {
          trigger: "item",
          formatter: "{b}<br/>{c} 道题 ({d}%)",
          backgroundColor: "rgba(255,255,255,0.98)",
          borderColor: "#667eea",
          borderWidth: 1,
          textStyle: { color: "#303133", fontSize: isMobile ? 11 : 13 },
          padding: isMobile ? [8, 12] : [12, 16],
          extraCssText:
            "box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2); border-radius: 8px;",
        },
        legend: {
          orient: "vertical",
          left: isMobile ? 8 : 12,
          top: isMobile ? 20 : 30,
          textStyle: {
            fontSize: isMobile ? 11 : 12,
            color: "#606266",
          },
          itemWidth: isMobile ? 10 : 12,
          itemHeight: isMobile ? 10 : 12,
          itemGap: isMobile ? 8 : 10,
          icon: "circle",
          formatter: (name) => {
            const item = data.find((d) => d.name === name);
            if (isMobile && name.length > 6) {
              return name.substring(0, 6) + "...";
            }
            return name;
          },
        },
        series: [
          {
            name: "标签占比",
            type: "pie",
            radius: isMobile ? ["35%", "60%"] : ["40%", "70%"],
            center: isMobile ? ["70%", "50%"] : ["65%", "50%"],
            avoidLabelOverlap: true,
            itemStyle: {
              borderRadius: 8,
              borderColor: "#fff",
              borderWidth: 2,
              shadowBlur: 10,
              shadowColor: "rgba(0, 0, 0, 0.1)",
            },
            label: {
              show: false,
            },
            emphasis: {
              label: {
                show: true,
                fontSize: isMobile ? 13 : 16,
                fontWeight: "bold",
                formatter: (p) => `{b|${p.name}}\n{c|${p.value} 道题}`,
                rich: {
                  b: {
                    fontSize: isMobile ? 13 : 15,
                    fontWeight: "bold",
                    color: "#303133",
                    lineHeight: 20,
                  },
                  c: {
                    fontSize: isMobile ? 11 : 13,
                    color: "#909399",
                    lineHeight: 18,
                  },
                },
              },
              itemStyle: {
                shadowBlur: 20,
                shadowColor: "rgba(0, 0, 0, 0.2)",
              },
            },
            labelLine: {
              show: false,
            },
            data,
            color: colors,
          },
        ],
        animationDuration: 1000,
        animationEasing: "cubicOut",
      };

      this.pieChart.setOption(option);
    },

    onSearch() {
      this.currentPage = 1;
    },

    onSearchClear() {
      this.keyword = "";
      this.onSearch();
    },

    applyFilters() {
      this.currentPage = 1;
    },

    applySort() {
      this.currentPage = 1;
    },

    clearAllFilters() {
      this.keyword = "";
      this.activeTagFilter = null;
      this.proficiencyFilter = null;
      this.sortOrder = "new";
      this.currentPage = 1;
      if (this.pieChart) {
        this.pieChart.dispatchAction({ type: "downplay", seriesIndex: 0 });
      }
      this.$message.success("已清除所有筛选");
    },

    onPageChange(page) {
      this.currentPage = page;
      this.$nextTick(() => {
        const el = this.$el.querySelector(".list-card");
        if (el) el.scrollIntoView({ behavior: "smooth", block: "start" });
      });
    },

    onPageSizeChange(size) {
      this.pageSize = size;
      this.currentPage = 1;
    },

    viewQuestion(row) {
      this.$router.push({
        path: "/trouble/question/view",
        query: { questionId: row.questionId },
      });
    },

    editQuestion(row) {
      this.$router.push({
        path: "/trouble/question",
        query: { editId: row.questionId },
      });
    },

    formatTime(t) {
      try {
        const d = new Date(t);
        if (isNaN(d.getTime())) return "";
        const now = new Date();
        const diff = now - d;
        const days = Math.floor(diff / (1000 * 60 * 60 * 24));

        if (days === 0) return "今天";
        if (days === 1) return "昨天";
        if (days < 7) return `${days}天前`;

        return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(
          2,
          "0"
        )}-${String(d.getDate()).padStart(2, "0")}`;
      } catch (e) {
        return "";
      }
    },

    getTagsArray(tags) {
      if (!tags) return [];
      return tags
        .split(/[,;，；\s]+/)
        .map((t) => t.trim())
        .filter(Boolean);
    },

    truncate(text, len) {
      if (!text) return "";
      return text.length > len ? text.substring(0, len) + "..." : text;
    },

    highlightKeyword(text) {
      if (!this.keyword || !this.keyword.trim() || !text) return text;
      const k = this.keyword.trim();
      const regex = new RegExp(`(${k})`, "gi");
      return text.replace(regex, '<mark class="highlight">$1</mark>');
    },

    renderTagCloudLayout() {
      const nodes = this.$refs.tagCloud
        ? this.$refs.tagCloud.querySelectorAll(".tag-chip")
        : [];
      nodes.forEach((n, idx) => {
        n.style.transform = "scale(0.8) translateY(10px)";
        n.style.opacity = "0";
        setTimeout(() => {
          n.style.transition = "all 0.3s cubic-bezier(0.4, 0, 0.2, 1)";
          n.style.transform = "scale(1) translateY(0)";
          n.style.opacity = "1";
        }, 30 * idx);
      });
    },

    refresh() {
      this.init();
      this.$message &&
        this.$message.success &&
        this.$message.success("刷新成功");
    },

    toggleCompact() {
      this.compact = !this.compact;
    },

    debounceResize: (function () {
      let timer = null;
      return function () {
        if (timer) clearTimeout(timer);
        timer = setTimeout(() => {
          if (this.pieChart) {
            this.pieChart.resize();
            this.updatePieChart();
          }
        }, 200);
      };
    })(),

    goBack() {
      if (window.history.length > 1) {
        this.$router.go(-1);
      } else {
        this.$router.push("/trouble/dashboard");
      }
    },
  },
  watch: {
    pieMode() {
      this.updatePieChart();
    },
  },
};
</script>

<style scoped>
* {
  box-sizing: border-box;
}

.app-container {
  padding: 16px;
  max-width: 1400px;
  margin: 0 auto;
  min-height: 100vh;
  background: linear-gradient(135deg, #f5f7fa 0%, #e8ecf1 100%);
}

/* ========== Header ========== */
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 24px;
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  margin-bottom: 20px;
  animation: fadeInDown 0.6s ease;
}

@keyframes fadeInDown {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.header-left {
  display: flex;
  gap: 16px;
  align-items: center;
  flex: 1;
  min-width: 0;
}

.icon-wrapper {
  width: 56px;
  height: 56px;
  border-radius: 14px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
  flex-shrink: 0;
}

.header-icon {
  font-size: 28px;
  color: #fff;
}

.header-text {
  flex: 1;
  min-width: 0;
}

.header-title {
  margin: 0 0 4px 0;
  font-size: 24px;
  font-weight: 700;
  color: #303133;
  letter-spacing: -0.5px;
}

.header-desc {
  margin: 0;
  font-size: 14px;
  color: #909399;
  line-height: 1.5;
}

.header-actions {
  display: flex;
  gap: 10px;
  align-items: center;
  flex-shrink: 0;
}

.search-input {
  width: 280px;
}

.action-btn {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  padding: 6px 10px;
  border-radius: 6px;
}

/* Overview cards */
.overview-row {
  margin-bottom: 12px;
}
.overview-card {
  display: flex;
  gap: 12px;
  align-items: center;
  padding: 12px;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
}
.card-icon {
  width: 46px;
  height: 46px;
  border-radius: 10px;
  background: linear-gradient(135deg, #76b0ff 0%, #8e6cc8 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  flex-shrink: 0;
}
.card-content .label {
  font-size: 12px;
  color: #909399;
}
.card-content .value {
  font-size: 18px;
  font-weight: 700;
  color: #303133;
}
.card-content .sub {
  font-size: 12px;
  color: #bfc7d6;
}

/* Panels */
.panel-card {
  margin-bottom: 16px;
}
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  border-bottom: 1px solid #f0f3f7;
}
.header-title-wrap {
  display: flex;
  gap: 8px;
  align-items: center;
  font-weight: 600;
  color: #303133;
}
.clear-btn {
  color: #909399;
}

/* Tag cloud */
.tag-cloud {
  padding: 16px;
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  min-height: 120px;
  align-items: flex-start;
  background: transparent;
}
.tag-chip {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 6px 10px;
  border-radius: 18px;
  background: rgba(0, 0, 0, 0.04);
  color: #303133;
  text-decoration: none;
  cursor: pointer;
  transition: transform 0.15s ease, background 0.15s ease, box-shadow 0.15s ease;
  user-select: none;
}
.tag-chip:hover {
  transform: translateY(-4px);
  box-shadow: 0 6px 14px rgba(102, 126, 234, 0.08);
}
.tag-chip .tag-text {
  font-weight: 600;
  margin-right: 4px;
}
.tag-chip .tag-count {
  font-size: 12px;
  color: #909399;
  background: rgba(255, 255, 255, 0.6);
  padding: 2px 6px;
  border-radius: 10px;
}

/* weight classes (scale font-size slightly) */
.weight-1 {
  font-size: 12px;
  opacity: 0.9;
}
.weight-2 {
  font-size: 14px;
}
.weight-3 {
  font-size: 16px;
}
.weight-4 {
  font-size: 18px;
}
.weight-5 {
  font-size: 20px;
  font-weight: 700;
}

/* active tag */
.tag-chip.active {
  background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
  color: #fff;
  box-shadow: 0 8px 20px rgba(102, 126, 234, 0.12);
}

/* legend */
.legend-bar {
  display: flex;
  gap: 12px;
  padding: 10px 16px 16px 16px;
  align-items: center;
}
.legend-item {
  display: flex;
  gap: 6px;
  align-items: center;
  color: #606266;
  font-size: 13px;
}
.legend-dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  display: inline-block;
}
.legend-dot.high {
  background: #667eea;
}
.legend-dot.mid {
  background: #f093fb;
}
.legend-dot.low {
  background: #fee140;
}

/* Pie chart wrapper */
.chart-wrapper {
  min-height: 260px;
  padding: 12px 16px;
}

/* List card toolbar */
.table-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  border-bottom: 1px solid #f0f3f7;
  gap: 10px;
}
.toolbar-left {
  display: flex;
  gap: 8px;
  align-items: center;
}
.toolbar-select {
  min-width: 160px;
}
.compact-btn {
  margin-left: auto;
}

/* table compact mode */
.compact-table .q-content {
  padding: 8px 6px;
}
.q-content {
  padding: 12px 8px;
}
.q-text {
  color: #303133;
  line-height: 1.6;
}
.q-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 8px;
  margin-top: 8px;
}
.q-tags .meta-tag {
  cursor: pointer;
  margin-right: 6px;
}

/* pagination */
.pagination-wrap {
  padding: 12px 16px;
  display: flex;
  justify-content: center;
}

/* responsive */
@media (max-width: 992px) {
  .search-input {
    width: 200px;
  }
  .header-title {
    font-size: 20px;
  }
  .chart-wrapper {
    min-height: 220px;
  }
}

@media (max-width: 768px) {
  .app-container {
    padding: 12px;
  }
  .left-panel,
  .right-panel {
    width: 100%;
  }
  .main-row {
    display: block;
  }
  .search-input {
    width: 160px;
  }
  .tag-cloud {
    min-height: 100px;
    gap: 6px;
  }
  .card-header {
    padding: 10px 12px;
  }
  .chart-wrapper {
    min-height: 200px;
  }
}

@media (max-width: 576px) {
  .page-header {
    flex-direction: column;
    align-items: stretch;
    gap: 12px;
    padding: 16px;
  }
  .header-actions {
    justify-content: flex-end;
  }
  .search-input {
    width: 100%;
  }
  .legend-bar {
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
  }
  .tag-chip {
    padding: 6px 8px;
    border-radius: 14px;
  }
  .overview-row .el-col {
    margin-bottom: 8px;
  }
}

/* accessibility */
@media (hover: none) and (pointer: coarse) {
  .tag-chip:active {
    transform: none;
  }
  .action-btn:active {
    transform: none;
  }
}
</style>
