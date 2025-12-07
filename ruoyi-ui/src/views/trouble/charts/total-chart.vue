<template>
  <div class="app-container">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-left">
          <div class="icon-wrapper">
            <i class="el-icon-data-analysis header-icon"></i>
          </div>
          <div class="header-text">
            <h2 class="header-title">累计错题统计</h2>
            <p class="header-desc">追踪学习进度，洞察错题趋势</p>
          </div>
        </div>
        <el-button
          type="info"
          plain
          icon="el-icon-back"
          size="small"
          @click="goBack"
          class="back-btn"
        >
          返回
        </el-button>
      </div>
    </div>

    <!-- 统计概览 -->
    <div class="stats-overview">
      <div class="stat-card" v-for="(stat, index) in statsCards" :key="index">
        <div class="stat-icon-wrapper" :class="`icon-${stat.type}`">
          <i :class="stat.icon"></i>
        </div>
        <div class="stat-info">
          <div class="stat-label">{{ stat.label }}</div>
          <div class="stat-value" :style="stat.valueStyle">
            {{ stat.value }}
          </div>
        </div>
      </div>
    </div>

    <!-- 图表卡片 -->
    <el-card class="chart-card" :body-style="{ padding: '0' }">
      <!-- 控制栏 -->
      <div class="chart-controls">
        <div class="control-left">
          <div class="view-mode-switch">
            <button
              :class="['mode-btn', { active: viewMode === 'daily' }]"
              @click="viewMode = 'daily'"
            >
              <i class="el-icon-date"></i>
              <span>按日</span>
            </button>
            <button
              :class="['mode-btn', { active: viewMode === 'monthly' }]"
              @click="viewMode = 'monthly'"
            >
              <i class="el-icon-calendar"></i>
              <span>按月</span>
            </button>
          </div>
        </div>

        <div class="control-right">
          <!-- 桌面端：日期选择器 -->
          <div v-if="!isMobileView" class="desktop-date-picker">
            <el-date-picker
              v-if="viewMode === 'daily'"
              v-model="dateRange"
              type="daterange"
              range-separator="至"
              start-placeholder="开始日期"
              end-placeholder="结束日期"
              size="small"
              :picker-options="pickerOptions"
              @change="handleDateChange"
              class="date-picker"
            />
            <el-date-picker
              v-else
              v-model="monthRange"
              type="monthrange"
              range-separator="至"
              start-placeholder="开始月份"
              end-placeholder="结束月份"
              size="small"
              :picker-options="pickerOptions"
              @change="handleDateChange"
              class="date-picker"
            />
          </div>

          <!-- 移动端：快捷选择 -->
          <div v-else class="mobile-date-selector">
            <el-select
              v-model="quickSelectValue"
              size="small"
              @change="handleQuickSelect"
              placeholder="选择时间范围"
              class="quick-select"
            >
              <el-option
                v-for="item in quickSelectOptions"
                :key="item.value"
                :label="item.label"
                :value="item.value"
              >
                <span class="option-label">
                  <i :class="item.icon"></i>
                  {{ item.label }}
                </span>
              </el-option>
            </el-select>
          </div>

          <el-button
            size="small"
            type="primary"
            icon="el-icon-refresh"
            @click="refresh"
            class="refresh-btn"
            circle
          />
        </div>
      </div>

      <!-- 图表区域 -->
      <div v-loading="loading" class="chart-container">
        <div id="totalChart" :style="{ height: chartHeight }"></div>
      </div>
    </el-card>

    <!-- 分类分析 -->
    <div class="analysis-section">
      <div class="section-header">
        <div class="header-left">
          <i class="el-icon-s-data section-icon"></i>
          <div>
            <div class="section-title">分类分析</div>
            <div class="section-desc">按熟练度 / 重要性 / 难度切换查看错题</div>
          </div>
        </div>
      </div>

      <!-- 熟练度 -->
      <div class="category-group">
        <div class="group-title">
          <i class="el-icon-medal"></i>
          熟练度分布
        </div>
        <div class="category-grid">
          <div
            v-for="item in proficiencyItems"
            :key="item.value"
            class="category-card"
            :class="`proficiency-${item.class}`"
            @click="navigateWithFilter('proficiency', item.value)"
          >
            <div class="card-icon">
              <i :class="item.icon"></i>
            </div>
            <div class="card-content">
              <div class="card-label">{{ item.label }}</div>
              <div class="card-value">
                {{ statsBreakdown.proficiency[item.value] || 0 }}
              </div>
              <div class="card-desc">{{ item.desc }}</div>
            </div>
            <div class="card-arrow">
              <i class="el-icon-arrow-right"></i>
            </div>
          </div>
        </div>
      </div>

      <!-- 重要性 -->
      <div class="category-group">
        <div class="group-title">
          <i class="el-icon-star-on"></i>
          重要性分布
        </div>
        <div class="category-grid">
          <div
            v-for="item in importanceItems"
            :key="item.value"
            class="category-card importance-card"
            @click="navigateWithFilter('importance', item.value)"
          >
            <div class="card-icon">
              <i :class="item.icon"></i>
            </div>
            <div class="card-content">
              <div class="card-label">{{ item.label }}</div>
              <div class="card-value">
                {{ statsBreakdown.importance[item.value] || 0 }}
              </div>
              <div class="card-desc">{{ item.desc }}</div>
            </div>
            <div class="card-arrow">
              <i class="el-icon-arrow-right"></i>
            </div>
          </div>
        </div>
      </div>

      <!-- 难度 -->
      <div class="category-group">
        <div class="group-title">
          <i class="el-icon-aim"></i>
          难度分布
        </div>
        <div class="category-grid">
          <div
            v-for="item in difficultyItems"
            :key="item.value"
            class="category-card difficulty-card"
            @click="navigateWithFilter('difficulty', item.value)"
          >
            <div class="card-icon">
              <i :class="item.icon"></i>
            </div>
            <div class="card-content">
              <div class="card-label">{{ item.label }}</div>
              <div class="card-value">
                {{ statsBreakdown.difficulty[item.value] || 0 }}
              </div>
              <div class="card-desc">{{ item.desc }}</div>
            </div>
            <div class="card-arrow">
              <i class="el-icon-arrow-right"></i>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import * as echarts from "echarts";
import { listQuestion } from "@/api/trouble/question";

export default {
  name: "TotalChart",
  data() {
    return {
      loading: false,
      viewMode: "daily",
      dateRange: null,
      monthRange: null,
      allQuestions: [],
      totalsData: [],
      chart: null,
      chartHeight: "400px",
      isMobileView: false,
      quickSelectValue: "thisMonth",
      statsData: {
        total: 0,
        periodNew: 0,
        dailyAvg: 0,
        trend: 0,
      },
      statsBreakdown: {
        proficiency: { 0: 0, 1: 0, 2: 0, 3: 0 },
        importance: { 1: 0, 2: 0, 3: 0 },
        difficulty: { 1: 0, 2: 0, 3: 0 },
      },
      pickerOptions: {
        shortcuts: [
          {
            text: "最近一周",
            onClick(picker) {
              const end = new Date();
              const start = new Date();
              start.setTime(start.getTime() - 3600 * 1000 * 24 * 7);
              picker.$emit("pick", [start, end]);
            },
          },
          {
            text: "最近一个月",
            onClick(picker) {
              const end = new Date();
              const start = new Date();
              start.setTime(start.getTime() - 3600 * 1000 * 24 * 30);
              picker.$emit("pick", [start, end]);
            },
          },
          {
            text: "最近三个月",
            onClick(picker) {
              const end = new Date();
              const start = new Date();
              start.setTime(start.getTime() - 3600 * 1000 * 24 * 90);
              picker.$emit("pick", [start, end]);
            },
          },
        ],
      },
      proficiencyItems: [
        {
          value: 0,
          label: "陌生",
          desc: "优先复习",
          icon: "el-icon-warning-outline",
          class: "unfamiliar",
        },
        {
          value: 1,
          label: "一般",
          desc: "需要关注",
          icon: "el-icon-edit-outline",
          class: "normal",
        },
        {
          value: 2,
          label: "较好",
          desc: "巩固阶段",
          icon: "el-icon-star-off",
          class: "good",
        },
        {
          value: 3,
          label: "熟练",
          desc: "可考虑移除",
          icon: "el-icon-success",
          class: "proficient",
        },
      ],
      importanceItems: [
        { value: 3, label: "高", desc: "优先复习", icon: "el-icon-star-on" },
        { value: 2, label: "中", desc: "次要", icon: "el-icon-s-custom" },
        { value: 1, label: "低", desc: "可稍后处理", icon: "el-icon-star-off" },
      ],
      difficultyItems: [
        {
          value: 3,
          label: "困难",
          desc: "重点攻克",
          icon: "el-icon-lightning",
        },
        { value: 2, label: "中等", desc: "需练习", icon: "el-icon-s-release" },
        {
          value: 1,
          label: "简单",
          desc: "基础题",
          icon: "el-icon-circle-check",
        },
      ],
    };
  },
  computed: {
    statsCards() {
      return [
        {
          type: "total",
          icon: "el-icon-pie-chart",
          label: "累计总数",
          value: this.statsData.total,
        },
        {
          type: "new",
          icon: "el-icon-plus",
          label: "期间新增",
          value: this.statsData.periodNew,
        },
        {
          type: "avg",
          icon: "el-icon-data-line",
          label: "日均增长",
          value: this.statsData.dailyAvg,
        },
        {
          type: "trend",
          icon:
            this.statsData.trend >= 0
              ? "el-icon-top-right"
              : "el-icon-bottom-right",
          label: "趋势变化",
          value: `${this.statsData.trend >= 0 ? "+" : ""}${
            this.statsData.trend
          }%`,
          valueStyle: {
            color: this.statsData.trend >= 0 ? "#67C23A" : "#F56C6C",
          },
        },
      ];
    },
    quickSelectOptions() {
      if (this.viewMode === "daily") {
        return [
          { value: "lastWeek", label: "最近一周", icon: "el-icon-date" },
          { value: "thisMonth", label: "本月", icon: "el-icon-calendar" },
          { value: "lastMonth", label: "上月", icon: "el-icon-time" },
          { value: "last30Days", label: "最近30天", icon: "el-icon-timer" },
          { value: "last90Days", label: "最近90天", icon: "el-icon-date" },
        ];
      } else {
        return [
          {
            value: "last3Months",
            label: "最近3个月",
            icon: "el-icon-calendar",
          },
          { value: "last6Months", label: "最近6个月", icon: "el-icon-date" },
          { value: "thisYear", label: "今年", icon: "el-icon-time" },
          { value: "last12Months", label: "最近12个月", icon: "el-icon-timer" },
        ];
      }
    },
  },
  watch: {
    viewMode() {
      this.initDefaultDateRange();
      this.buildTotals();
    },
  },
  mounted() {
    this.checkMobileView();
    this.initDefaultDateRange();
    this.init();
    this.handleResize();
    window.addEventListener("resize", this.handleResize);
  },
  beforeDestroy() {
    window.removeEventListener("resize", this.handleResize);
    if (this.chart) this.chart.dispose();
  },
  methods: {
    checkMobileView() {
      this.isMobileView = window.innerWidth < 768;
    },
    handleQuickSelect(value) {
      const now = new Date();
      const year = now.getFullYear();
      const month = now.getMonth();

      if (this.viewMode === "daily") {
        let start,
          end = new Date();

        switch (value) {
          case "lastWeek":
            start = new Date();
            start.setDate(start.getDate() - 7);
            break;
          case "thisMonth":
            start = new Date(year, month, 1);
            end = new Date(year, month + 1, 0);
            break;
          case "lastMonth":
            start = new Date(year, month - 1, 1);
            end = new Date(year, month, 0);
            break;
          case "last30Days":
            start = new Date();
            start.setDate(start.getDate() - 30);
            break;
          case "last90Days":
            start = new Date();
            start.setDate(start.getDate() - 90);
            break;
          default:
            start = new Date(year, month, 1);
        }

        this.dateRange = [start, end];
      } else {
        let startMonth,
          endMonth = new Date(year, month, 1);

        switch (value) {
          case "last3Months":
            startMonth = new Date(year, month - 2, 1);
            break;
          case "last6Months":
            startMonth = new Date(year, month - 5, 1);
            break;
          case "thisYear":
            startMonth = new Date(year, 0, 1);
            break;
          case "last12Months":
            startMonth = new Date(year, month - 11, 1);
            break;
          default:
            startMonth = new Date(year, month - 5, 1);
        }

        this.monthRange = [startMonth, endMonth];
      }

      this.buildTotals();
    },
    initDefaultDateRange() {
      const now = new Date();
      const year = now.getFullYear();
      const month = now.getMonth();

      if (this.viewMode === "daily") {
        const start = new Date(year, month, 1);
        const end = new Date(year, month + 1, 0);
        this.dateRange = [start, end];
        this.quickSelectValue = "thisMonth";
      } else {
        const endMonth = new Date(year, month, 1);
        const startMonth = new Date(year, month - 5, 1);
        this.monthRange = [startMonth, endMonth];
        this.quickSelectValue = "last6Months";
      }
    },
    handleDateChange() {
      this.buildTotals();
    },
    async init() {
      this.loading = true;
      try {
        await this.fetchAllQuestions();
        this.buildTotals();
      } catch (err) {
        this.$modal.msgError("加载数据失败");
        if (process.env.NODE_ENV === "development") {
          console.error(err);
        }
      } finally {
        this.loading = false;
      }
    },
    async fetchAllQuestions() {
      const response = await listQuestion({ pageNum: 1, pageSize: 5000 });
      this.allQuestions = response.rows || [];
      this.allQuestions.forEach((q) => {
        if (q.createTime && !(q.createTime instanceof Date)) {
          const d = new Date(q.createTime);
          q._createDate = isNaN(d.getTime()) ? null : d;
        } else {
          q._createDate = q.createTime || null;
        }
      });
    },
    buildTotals() {
      if (this.viewMode === "daily") {
        this.buildDailyTotals();
      } else {
        this.buildMonthlyTotals();
      }
      this.calculateStatsAndBreakdown();
      this.$nextTick(() => this.initChart());
    },
    buildDailyTotals() {
      if (!this.dateRange || !this.dateRange[0] || !this.dateRange[1]) {
        this.totalsData = [];
        return;
      }

      const map = new Map();
      const startDate = new Date(this.dateRange[0]);
      startDate.setHours(0, 0, 0, 0);
      const endDate = new Date(this.dateRange[1]);
      endDate.setHours(23, 59, 59, 999);

      this.allQuestions.forEach((q) => {
        const d = q._createDate;
        if (!d || d < startDate || d > endDate) return;
        const key = this.formatDate(d);
        if (!map.has(key)) map.set(key, 0);
        map.set(key, map.get(key) + 1);
      });

      const list = [];
      const cur = new Date(startDate);
      let cumulative = this.getCumulativeBeforeDate(startDate);

      while (cur <= endDate) {
        const key = this.formatDate(cur);
        const count = map.get(key) || 0;
        cumulative += count;
        list.push({ label: key, count, cumulative });
        cur.setDate(cur.getDate() + 1);
      }
      this.totalsData = list;
    },
    buildMonthlyTotals() {
      if (!this.monthRange || !this.monthRange[0] || !this.monthRange[1]) {
        this.totalsData = [];
        return;
      }

      const map = new Map();
      const startMonth = new Date(this.monthRange[0]);
      startMonth.setDate(1);
      startMonth.setHours(0, 0, 0, 0);
      const endMonth = new Date(this.monthRange[1]);
      endMonth.setMonth(endMonth.getMonth() + 1, 0);
      endMonth.setHours(23, 59, 59, 999);

      this.allQuestions.forEach((q) => {
        const d = q._createDate;
        if (!d || d < startMonth || d > endMonth) return;
        const key = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(
          2,
          "0"
        )}`;
        if (!map.has(key)) map.set(key, 0);
        map.set(key, map.get(key) + 1);
      });

      const list = [];
      const cur = new Date(startMonth);
      let cumulative = this.getCumulativeBeforeDate(startMonth);

      while (cur <= endMonth) {
        const key = `${cur.getFullYear()}-${String(cur.getMonth() + 1).padStart(
          2,
          "0"
        )}`;
        const count = map.get(key) || 0;
        cumulative += count;
        list.push({ label: key, count, cumulative });
        cur.setMonth(cur.getMonth() + 1);
      }
      this.totalsData = list;
    },
    getCumulativeBeforeDate(date) {
      return this.allQuestions.filter((q) => {
        const d = q._createDate;
        return d && d < date;
      }).length;
    },
    calculateStatsAndBreakdown() {
      const total =
        this.totalsData.length > 0
          ? this.totalsData[this.totalsData.length - 1].cumulative
          : 0;
      const periodNew = this.totalsData.reduce(
        (sum, item) => sum + item.count,
        0
      );
      const dailyAvg =
        this.totalsData.length > 0
          ? Math.round(periodNew / this.totalsData.length)
          : 0;

      let trend = 0;
      if (this.totalsData.length >= 4) {
        const mid = Math.floor(this.totalsData.length / 2);
        const firstHalf = this.totalsData.slice(0, mid);
        const secondHalf = this.totalsData.slice(mid);
        const firstAvg =
          firstHalf.reduce((s, r) => s + r.count, 0) / firstHalf.length;
        const secondAvg =
          secondHalf.reduce((s, r) => s + r.count, 0) / secondHalf.length;
        if (firstAvg > 0) {
          trend = Math.round(((secondAvg - firstAvg) / firstAvg) * 100);
        } else {
          trend = secondAvg > 0 ? 100 : 0;
        }
      }

      this.statsData = { total, periodNew, dailyAvg, trend };

      const { startDate, endDate } = this.getRangeStartEnd();
      const prof = { 0: 0, 1: 0, 2: 0, 3: 0 };
      const imp = { 1: 0, 2: 0, 3: 0 };
      const diff = { 1: 0, 2: 0, 3: 0 };

      this.allQuestions.forEach((q) => {
        const d = q._createDate;
        if (!d) return;
        if (startDate && d < startDate) return;
        if (endDate && d > endDate) return;

        const p =
          q.proficiency === undefined || q.proficiency === null
            ? 0
            : Number(q.proficiency);
        if (prof[p] === undefined) prof[p] = 0;
        prof[p]++;

        const im =
          q.importance === undefined || q.importance === null
            ? 2
            : Number(q.importance);
        if (imp[im] === undefined) imp[im] = 0;
        imp[im]++;

        const df =
          q.difficulty === undefined || q.difficulty === null
            ? 2
            : Number(q.difficulty);
        if (diff[df] === undefined) diff[df] = 0;
        diff[df]++;
      });

      this.statsBreakdown = {
        proficiency: prof,
        importance: imp,
        difficulty: diff,
      };
    },
    getRangeStartEnd() {
      if (this.viewMode === "daily") {
        if (!this.dateRange || !this.dateRange[0] || !this.dateRange[1])
          return { startDate: null, endDate: null };
        const s = new Date(this.dateRange[0]);
        s.setHours(0, 0, 0, 0);
        const e = new Date(this.dateRange[1]);
        e.setHours(23, 59, 59, 999);
        return { startDate: s, endDate: e };
      } else {
        if (!this.monthRange || !this.monthRange[0] || !this.monthRange[1])
          return { startDate: null, endDate: null };
        const s = new Date(this.monthRange[0]);
        s.setDate(1);
        s.setHours(0, 0, 0, 0);
        const e = new Date(this.monthRange[1]);
        e.setMonth(e.getMonth() + 1, 0);
        e.setHours(23, 59, 59, 999);
        return { startDate: s, endDate: e };
      }
    },
    navigateWithFilter(filterType, value) {
      const { startDate, endDate } = this.getRangeStartEnd();
      const query = {};
      if (startDate && endDate) {
        query.dateStart = this.formatDate(startDate);
        query.dateEnd = this.formatDate(endDate);
      }
      if (
        filterType === "proficiency" ||
        filterType === "importance" ||
        filterType === "difficulty"
      ) {
        query[filterType] = String(value);
      }
      this.$router.push({ path: "/trouble/question/view", query });
    },
    initChart() {
      const dom = document.getElementById("totalChart");
      if (!dom) return;
      if (this.chart) this.chart.dispose();
      this.chart = echarts.init(dom);

      const labels = this.totalsData.map((d) => d.label);
      const counts = this.totalsData.map((d) => d.count);
      const cumulative = this.totalsData.map((d) => d.cumulative);

      const isMobile = window.innerWidth < 768;

      // 智能标签显示逻辑
      let labelInterval = 0;
      const dataLength = labels.length;

      if (isMobile) {
        if (dataLength > 20) labelInterval = Math.floor(dataLength / 8);
        else if (dataLength > 10) labelInterval = Math.floor(dataLength / 6);
        else labelInterval = 0;
      } else {
        if (dataLength > 30) labelInterval = Math.floor(dataLength / 15);
        else if (dataLength > 15) labelInterval = Math.floor(dataLength / 10);
        else labelInterval = 0;
      }

      const option = {
        backgroundColor: "transparent",
        tooltip: {
          trigger: "axis",
          axisPointer: {
            type: "shadow",
            shadowStyle: {
              color: "rgba(102, 126, 234, 0.1)",
            },
          },
          backgroundColor: "rgba(255,255,255,0.98)",
          borderColor: "#667eea",
          borderWidth: 1,
          textStyle: { color: "#303133", fontSize: isMobile ? 11 : 13 },
          padding: isMobile ? [10, 14] : [14, 18],
          extraCssText:
            "box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2); border-radius: 8px;",
          formatter: (params) => {
            const date = params[0]?.axisValue || "";
            let html = `<div style="font-weight:700;margin-bottom:8px;color:#667eea;font-size:${
              isMobile ? "13px" : "15px"
            };">${date}</div>`;
            params.forEach((p) => {
              const isNew = p.seriesName === "新增";
              const color = isNew ? "#667eea" : "#67C23A";
              const bgColor = isNew
                ? "rgba(102, 126, 234, 0.1)"
                : "rgba(103, 194, 58, 0.1)";
              html += `<div style="line-height:${
                isMobile ? "22px" : "26px"
              };display:flex;align-items:center;gap:8px;padding:4px 6px;border-radius:6px;background:${bgColor};margin-top:4px;">
                <span style="display:inline-block;width:10px;height:10px;border-radius:50%;background:${color};box-shadow:0 2px 4px ${color}44;"></span>
                <span style="color:#606266;font-size:${
                  isMobile ? "11px" : "13px"
                };flex:1;">${p.seriesName}:</span>
                <span style="font-weight:700;color:${color};font-size:${
                isMobile ? "13px" : "15px"
              };">${p.value}</span>
              </div>`;
            });
            return html;
          },
        },
        legend: {
          data: ["新增", "累计"],
          top: isMobile ? 10 : 18,
          right: isMobile ? 16 : 28,
          icon: "roundRect",
          itemWidth: 12,
          itemHeight: 12,
          itemGap: isMobile ? 16 : 24,
          textStyle: {
            color: "#606266",
            fontSize: isMobile ? 12 : 14,
            fontWeight: 500,
          },
        },
        grid: {
          left: isMobile ? "6%" : "3%",
          right: isMobile ? "6%" : "3%",
          bottom: isMobile ? "15%" : "10%",
          top: isMobile ? 50 : 65,
          containLabel: true,
        },
        xAxis: {
          type: "category",
          data: labels,
          axisLine: {
            lineStyle: {
              color: "#E4E7ED",
              width: 2,
            },
          },
          axisLabel: {
            color: "#909399",
            fontSize: isMobile ? 10 : 12,
            fontWeight: 500,
            rotate: 0,
            interval: labelInterval,
            formatter: (value) => {
              // 智能格式化日期显示
              if (this.viewMode === "daily") {
                const parts = value.split("-");
                if (isMobile) {
                  return `${parts[1]}/${parts[2]}`;
                }
                return value;
              }
              return value;
            },
          },
          axisTick: {
            show: true,
            lineStyle: {
              color: "#E4E7ED",
            },
          },
          splitLine: {
            show: false,
          },
        },
        yAxis: [
          {
            type: "value",
            name: isMobile ? "" : "新增数量",
            nameTextStyle: {
              color: "#667eea",
              fontSize: isMobile ? 11 : 13,
              fontWeight: 600,
              padding: [0, 0, 0, isMobile ? 0 : 10],
            },
            position: "left",
            axisLine: { show: false },
            axisLabel: {
              color: "#909399",
              fontSize: isMobile ? 10 : 12,
              fontWeight: 500,
            },
            splitLine: {
              lineStyle: {
                color: "#F2F6FC",
                type: "dashed",
                width: 1,
              },
            },
          },
          {
            type: "value",
            name: isMobile ? "" : "累计数量",
            nameTextStyle: {
              color: "#67C23A",
              fontSize: isMobile ? 11 : 13,
              fontWeight: 600,
              padding: [0, isMobile ? 0 : 10, 0, 0],
            },
            position: "right",
            axisLine: { show: false },
            axisLabel: {
              color: "#909399",
              fontSize: isMobile ? 10 : 12,
              fontWeight: 500,
            },
            splitLine: { show: false },
          },
        ],
        series: [
          {
            name: "新增",
            type: "bar",
            data: counts,
            itemStyle: {
              color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                { offset: 0, color: "#8b9aff" },
                { offset: 0.5, color: "#667eea" },
                { offset: 1, color: "#5568d3" },
              ]),
              borderRadius: [6, 6, 0, 0],
              shadowColor: "rgba(102, 126, 234, 0.3)",
              shadowBlur: 10,
              shadowOffsetY: 4,
            },
            barMaxWidth: isMobile ? 24 : 36,
            emphasis: {
              itemStyle: {
                color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                  { offset: 0, color: "#7685f5" },
                  { offset: 0.5, color: "#5568d3" },
                  { offset: 1, color: "#4558bc" },
                ]),
                shadowColor: "rgba(102, 126, 234, 0.5)",
                shadowBlur: 15,
                shadowOffsetY: 6,
              },
            },
          },
          {
            name: "累计",
            type: "line",
            yAxisIndex: 1,
            data: cumulative,
            smooth: true,
            lineStyle: {
              width: isMobile ? 3 : 4,
              color: "#67C23A",
              shadowColor: "rgba(103, 194, 58, 0.3)",
              shadowBlur: 10,
              shadowOffsetY: 4,
            },
            itemStyle: {
              color: "#67C23A",
              borderWidth: 2,
              borderColor: "#fff",
              shadowColor: "rgba(103, 194, 58, 0.4)",
              shadowBlur: 8,
            },
            symbol: "circle",
            symbolSize: isMobile ? 6 : 8,
            areaStyle: {
              color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                { offset: 0, color: "rgba(103,194,58,0.35)" },
                { offset: 0.7, color: "rgba(103,194,58,0.15)" },
                { offset: 1, color: "rgba(103,194,58,0.05)" },
              ]),
            },
            emphasis: {
              focus: "series",
              itemStyle: {
                color: "#67C23A",
                borderWidth: 3,
                borderColor: "#fff",
                shadowColor: "rgba(103, 194, 58, 0.6)",
                shadowBlur: 12,
              },
              lineStyle: {
                width: isMobile ? 4 : 5,
              },
            },
          },
        ],
        animationDuration: 1200,
        animationEasing: "cubicOut",
        animationDelay: (idx) => idx * 10,
      };

      this.chart.setOption(option);

      if (this.chart && this.chart.on) {
        if (this.chart.off) this.chart.off("click");
        const labelsCopy = labels.slice();
        this.chart.on("click", (params) => {
          if (!params) return;
          const idx = params.dataIndex;
          if (idx === undefined || idx === null) return;
          const label = labelsCopy[idx];
          if (!label) return;

          if (this.viewMode === "daily") {
            const s = new Date(label);
            const e = new Date(label);
            this.$router.push({
              path: "/trouble/question/view",
              query: {
                dateStart: this.formatDate(s),
                dateEnd: this.formatDate(e),
              },
            });
          } else {
            const parts = String(label).split("-");
            const year = parseInt(parts[0], 10) || new Date().getFullYear();
            const month = (parts[1] && parseInt(parts[1], 10)) || 1;
            const s = new Date(year, month - 1, 1);
            s.setHours(0, 0, 0, 0);
            const e = new Date(year, month, 0);
            e.setHours(23, 59, 59, 999);
            this.$router.push({
              path: "/trouble/question/view",
              query: {
                dateStart: this.formatDate(s),
                dateEnd: this.formatDate(e),
              },
            });
          }
        });
      }
    },
    formatDate(date) {
      const d = typeof date === "string" ? new Date(date) : date;
      if (!(d instanceof Date) || isNaN(d.getTime())) return "";
      const y = d.getFullYear();
      const m = String(d.getMonth() + 1).padStart(2, "0");
      const day = String(d.getDate()).padStart(2, "0");
      return `${y}-${m}-${day}`;
    },
    refresh() {
      this.init();
      this.$message.success("刷新成功");
    },
    goBack() {
      this.$router.push("/");
    },
    handleResize() {
      const width = window.innerWidth;
      this.checkMobileView();

      if (width < 576) {
        this.chartHeight = "280px";
      } else if (width < 768) {
        this.chartHeight = "320px";
      } else if (width < 992) {
        this.chartHeight = "360px";
      } else {
        this.chartHeight = "420px";
      }

      if (this.chart) {
        this.chart.resize();
        this.initChart();
      }
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

/* 页面头部 */
.page-header {
  margin-bottom: 20px;
  padding: 20px 24px;
  background: #ffffff;
  border-radius: 16px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
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

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 16px;
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
}

.header-icon {
  font-size: 28px;
  color: #fff;
}

.header-text {
  flex: 1;
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
}

.back-btn {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.back-btn:hover {
  transform: translateX(-4px);
}

/* 统计概览 */
.stats-overview {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  margin-bottom: 20px;
  animation: fadeIn 0.6s ease 0.2s backwards;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.stat-card {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 18px;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.stat-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
}

.stat-icon-wrapper {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 22px;
  color: #fff;
  flex-shrink: 0;
}

.icon-total {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.icon-new {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
}

.icon-avg {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
}

.icon-trend {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
}

.stat-info {
  flex: 1;
  min-width: 0;
}

.stat-label {
  font-size: 12px;
  color: #909399;
  margin-bottom: 4px;
  white-space: nowrap;
}

.stat-value {
  font-size: 26px;
  font-weight: 700;
  color: #303133;
  line-height: 1.2;
}

/* 图表卡片 */
.chart-card {
  border-radius: 16px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  overflow: hidden;
  background: #fff;
  margin-bottom: 20px;
  animation: fadeIn 0.6s ease 0.3s backwards;
}

.chart-controls {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 20px;
  background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
  gap: 12px;
  flex-wrap: wrap;
}

.control-left,
.control-right {
  display: flex;
  align-items: center;
  gap: 12px;
}

.view-mode-switch {
  display: inline-flex;
  background: rgba(255, 255, 255, 0.15);
  border-radius: 10px;
  padding: 4px;
  backdrop-filter: blur(10px);
}

.mode-btn {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 16px;
  border: none;
  background: transparent;
  color: rgba(255, 255, 255, 0.85);
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  font-size: 14px;
  font-weight: 500;
  white-space: nowrap;
}

.mode-btn:hover {
  background: rgba(255, 255, 255, 0.1);
  color: #fff;
}

.mode-btn.active {
  background: #fff;
  color: #667eea;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
}

.mode-btn i {
  font-size: 16px;
}

/* 日期选择器样式 */
.desktop-date-picker,
.mobile-date-selector {
  flex-shrink: 0;
  min-width: 0;
}

.date-picker {
  max-width: 100%;
  min-width: 260px;
}

.quick-select {
  min-width: 180px;
  max-width: 100%;
}

.option-label {
  display: flex;
  align-items: center;
  gap: 8px;
}

.option-label i {
  font-size: 14px;
  color: #667eea;
}

.refresh-btn {
  flex-shrink: 0;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.refresh-btn:hover {
  transform: rotate(180deg);
}

/* 图表容器 */
.chart-container {
  padding: 24px 20px;
  background: linear-gradient(180deg, #fafbfc 0%, #ffffff 100%);
}

/* 分析部分 */
.analysis-section {
  background: #fff;
  border-radius: 16px;
  padding: 24px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  animation: fadeIn 0.6s ease 0.4s backwards;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 20px;
  border-bottom: 2px solid #f0f2f5;
  margin-bottom: 24px;
}

.section-header .header-left {
  display: flex;
  align-items: center;
  gap: 12px;
}

.section-icon {
  font-size: 24px;
  color: #409eff;
}

.section-title {
  font-size: 18px;
  font-weight: 700;
  color: #303133;
  margin-bottom: 2px;
}

.section-desc {
  font-size: 13px;
  color: #909399;
}

.section-tip {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 12px;
  color: #606266;
  background: #f0f9ff;
  padding: 8px 14px;
  border-radius: 8px;
  border-left: 3px solid #409eff;
}

.section-tip i {
  font-size: 14px;
}

/* 分类组 */
.category-group {
  margin-bottom: 28px;
}

.category-group:last-child {
  margin-bottom: 0;
}

.group-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 15px;
  font-weight: 600;
  color: #606266;
  margin-bottom: 14px;
  padding-left: 4px;
}

.group-title i {
  font-size: 18px;
  color: #409eff;
}

/* 分类卡片网格 */
.category-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
  gap: 14px;
}

.category-card {
  display: flex;
  align-items: center;
  padding: 14px 16px;
  border-radius: 12px;
  background: #fff;
  border: 2px solid #f0f2f5;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  gap: 12px;
}

.category-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
  border-color: transparent;
}

.card-icon {
  width: 48px;
  height: 48px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  flex-shrink: 0;
  transition: all 0.3s ease;
}

.category-card:hover .card-icon {
  transform: scale(1.1) rotate(5deg);
}

/* 熟练度样式 */
.proficiency-unfamiliar .card-icon {
  background: linear-gradient(135deg, #ff6b6b, #ee5a6f);
  color: #fff;
}

.proficiency-normal .card-icon {
  background: linear-gradient(135deg, #ffa726, #fb8c00);
  color: #fff;
}

.proficiency-good .card-icon {
  background: linear-gradient(135deg, #66b1ff, #409eff);
  color: #fff;
}

.proficiency-proficient .card-icon {
  background: linear-gradient(135deg, #67c23a, #85ce61);
  color: #fff;
}

/* 重要性样式 */
.importance-card .card-icon {
  background: linear-gradient(135deg, #ffd86f, #fc6076);
  color: #fff;
}

/* 难度样式 */
.difficulty-card .card-icon {
  background: linear-gradient(135deg, #a18cd1, #fbc2eb);
  color: #fff;
}

.card-content {
  flex: 1;
  min-width: 0;
}

.card-label {
  font-size: 14px;
  font-weight: 500;
  color: #909399;
  margin-bottom: 4px;
  transition: color 0.3s ease;
}

.card-value {
  font-size: 28px;
  font-weight: 700;
  color: #303133;
  line-height: 1.2;
  margin-bottom: 2px;
  transition: color 0.3s ease;
}

.card-desc {
  font-size: 12px;
  font-weight: 400;
  color: #c0c4cc;
  transition: color 0.3s ease;
}

.card-arrow {
  font-size: 16px;
  color: #c0c4cc;
  transition: all 0.3s ease;
  flex-shrink: 0;
}

.category-card:hover .card-arrow {
  transform: translateX(4px);
  color: #409eff;
}

/* 响应式设计 */
@media (max-width: 1200px) {
  .category-grid {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (max-width: 992px) {
  .stats-overview {
    grid-template-columns: repeat(2, 1fr);
  }

  .section-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 12px;
  }

  .section-tip {
    align-self: stretch;
  }

  .category-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 12px;
  }
}

@media (max-width: 768px) {
  .app-container {
    padding: 12px;
  }

  .page-header {
    padding: 16px;
    margin-bottom: 16px;
  }

  .header-title {
    font-size: 20px;
  }

  .icon-wrapper {
    width: 48px;
    height: 48px;
  }

  .header-icon {
    font-size: 24px;
  }

  .stats-overview {
    gap: 10px;
    margin-bottom: 16px;
  }

  .stat-card {
    padding: 14px 12px;
    gap: 10px;
  }

  .stat-icon-wrapper {
    width: 40px;
    height: 40px;
    font-size: 18px;
  }

  .stat-label {
    font-size: 11px;
  }

  .stat-value {
    font-size: 20px;
  }

  .chart-card {
    margin-bottom: 16px;
  }

  .chart-controls {
    padding: 12px;
    gap: 10px;
  }

  .control-left {
    width: 100%;
  }

  .control-right {
    width: 100%;
    justify-content: space-between;
  }

  .view-mode-switch {
    width: 100%;
    justify-content: center;
  }

  .mode-btn {
    flex: 1;
    justify-content: center;
    padding: 8px 12px;
    font-size: 13px;
  }

  .quick-select {
    flex: 1;
    min-width: 0;
  }

  .chart-container {
    padding: 18px 14px;
  }

  .analysis-section {
    padding: 16px;
  }

  .section-title {
    font-size: 16px;
  }

  .section-tip span {
    font-size: 11px;
  }

  .category-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 10px;
  }

  .category-card {
    padding: 12px;
    gap: 10px;
  }

  .card-icon {
    width: 42px;
    height: 42px;
    font-size: 20px;
  }

  .card-value {
    font-size: 22px;
  }
}

@media (max-width: 576px) {
  .app-container {
    padding: 10px;
  }

  .stats-overview {
    grid-template-columns: repeat(2, 1fr);
    gap: 8px;
  }

  .stat-card {
    padding: 12px 10px;
    gap: 10px;
  }

  .stat-icon-wrapper {
    width: 36px;
    height: 36px;
    font-size: 16px;
  }

  .stat-label {
    font-size: 10px;
  }

  .stat-value {
    font-size: 18px;
  }

  .header-content {
    flex-wrap: wrap;
  }

  .back-btn {
    margin-left: auto;
  }

  .chart-controls {
    padding: 10px;
  }

  .mode-btn {
    font-size: 12px;
    padding: 7px 10px;
  }

  .section-header {
    padding-bottom: 14px;
    margin-bottom: 16px;
  }

  .section-tip {
    padding: 6px 10px;
  }

  .section-tip span {
    display: none;
  }

  .category-grid {
    grid-template-columns: 1fr;
  }

  .category-card {
    padding: 14px;
  }

  .card-icon {
    width: 46px;
    height: 46px;
    font-size: 22px;
  }

  .card-value {
    font-size: 24px;
  }

  .group-title {
    font-size: 14px;
  }
}

/* Element UI 样式覆盖 */
::v-deep .el-range-editor.el-input__inner {
  background-color: rgba(255, 255, 255, 0.2);
  border-color: rgba(255, 255, 255, 0.3);
  transition: all 0.3s ease;
}

::v-deep .el-range-editor.el-input__inner:hover {
  background-color: rgba(255, 255, 255, 0.25);
  border-color: rgba(255, 255, 255, 0.4);
}

::v-deep .el-range-editor .el-range-separator {
  color: rgba(255, 255, 255, 0.9);
}

::v-deep .el-range-editor .el-range-input {
  background: transparent;
  color: #fff;
}

::v-deep .el-range-editor .el-range-input::placeholder {
  color: rgba(255, 255, 255, 0.7);
}

::v-deep .el-range-editor .el-range__icon {
  color: rgba(255, 255, 255, 0.8);
}

::v-deep .el-range-editor .el-range__close-icon {
  color: rgba(255, 255, 255, 0.8);
}

::v-deep .el-button--primary.is-circle {
  background: rgba(255, 255, 255, 0.2);
  border-color: rgba(255, 255, 255, 0.3);
}

::v-deep .el-button--primary.is-circle:hover {
  background: rgba(255, 255, 255, 0.3);
  border-color: rgba(255, 255, 255, 0.5);
}

/* 移动端下拉选择器优化 */
::v-deep .el-select {
  width: 100%;
}

::v-deep .el-select .el-input__inner {
  background-color: rgba(255, 255, 255, 0.2);
  border-color: rgba(255, 255, 255, 0.3);
  color: #fff;
  font-weight: 500;
}

::v-deep .el-select .el-input__inner::placeholder {
  color: rgba(255, 255, 255, 0.7);
}

::v-deep .el-select .el-input__icon {
  color: rgba(255, 255, 255, 0.8);
}

/* 修复日期选择器弹出层在小屏幕上的显示 */
@media (max-width: 768px) {
  ::v-deep .el-date-editor {
    width: 100%;
    font-size: 12px;
  }

  ::v-deep .el-range-editor .el-range-input {
    font-size: 12px;
  }

  ::v-deep .el-range-separator {
    font-size: 12px;
  }

  ::v-deep .el-picker-panel {
    max-width: calc(100vw - 24px) !important;
    left: 50% !important;
    transform: translateX(-50%) !important;
  }

  ::v-deep .el-picker-panel__body {
    max-width: 100%;
    overflow-x: auto;
  }
}

@media (max-width: 576px) {
  ::v-deep .el-picker-panel {
    max-width: calc(100vw - 20px) !important;
    width: auto !important;
    font-size: 12px;
  }

  ::v-deep .el-picker-panel__content {
    max-width: 100%;
  }

  ::v-deep .el-date-table {
    font-size: 11px;
  }

  ::v-deep .el-month-table {
    font-size: 11px;
  }
}

/* 加载动画优化 */
::v-deep .el-loading-mask {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(8px);
  border-radius: 16px;
}

::v-deep .el-loading-spinner .circular {
  width: 42px;
  height: 42px;
}

::v-deep .el-loading-spinner .path {
  stroke: #667eea;
}

/* 平滑滚动 */
html {
  scroll-behavior: smooth;
}

/* 选中效果 */
::selection {
  background: #667eea;
  color: #fff;
}

/* 触摸设备优化 */
@media (hover: none) and (pointer: coarse) {
  .category-card:active {
    transform: translateY(-2px) scale(0.98);
  }

  .stat-card:active {
    transform: translateY(-2px);
  }

  .mode-btn:active {
    transform: scale(0.95);
  }

  .refresh-btn:active {
    transform: rotate(90deg) scale(0.9);
  }
}

/* 图表优化提示 */
.chart-container {
  position: relative;
}

#totalChart {
  width: 100%;
  cursor: pointer;
}

/* 卡片悬停效果增强 */
.category-card::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  border-radius: 12px;
  background: linear-gradient(
    135deg,
    rgba(102, 126, 234, 0.1),
    rgba(118, 75, 162, 0.1)
  );
  opacity: 0;
  transition: opacity 0.3s ease;
  pointer-events: none;
}

.category-card:hover::before {
  opacity: 1;
}

.category-card {
  position: relative;
  overflow: hidden;
}

/* 性能优化 */
.stat-card,
.category-card,
.chart-card {
  will-change: transform;
}

/* 无障碍优化 */
.mode-btn:focus,
.refresh-btn:focus,
.category-card:focus {
  outline: 2px solid #667eea;
  outline-offset: 2px;
}
</style>
