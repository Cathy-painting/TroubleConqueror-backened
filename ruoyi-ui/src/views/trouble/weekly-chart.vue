<template>
  <div class="app-container">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-left">
          <i class="el-icon-data-analysis header-icon"></i>
          <h2 class="header-title">本周新增错题统计</h2>
        </div>
        <p class="header-desc">查看本周每日新增错题的详细数据和趋势分析</p>
      </div>
    </div>

    <!-- 返回按钮 -->
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="info"
          plain
          icon="el-icon-back"
          size="mini"
          @click="goBack"
        >返回首页</el-button>
      </el-col>
    </el-row>

    <!-- 统计概览 -->
    <el-row :gutter="16" class="stats-overview">
      <el-col :xs="24" :sm="12" :md="6">
        <el-card class="overview-card">
          <div class="overview-content">
            <div class="overview-label">本周总计</div>
            <div class="overview-value">{{ weeklyStats.total }}</div>
            <i class="el-icon-data-line overview-icon"></i>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="12" :md="6">
        <el-card class="overview-card">
          <div class="overview-content">
            <div class="overview-label">日均新增</div>
            <div class="overview-value">{{ weeklyStats.average }}</div>
            <i class="el-icon-data-analysis overview-icon"></i>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="12" :md="6">
        <el-card class="overview-card">
          <div class="overview-content">
            <div class="overview-label">最高峰值</div>
            <div class="overview-value">{{ weeklyStats.max }}</div>
            <i class="el-icon-top overview-icon"></i>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="12" :md="6">
        <el-card class="overview-card">
          <div class="overview-content">
            <div class="overview-label">增长趋势</div>
            <div class="overview-value trend" :class="weeklyStats.trend > 0 ? 'trend-up' : 'trend-down'">
              <i :class="weeklyStats.trend > 0 ? 'el-icon-top' : 'el-icon-bottom'"></i>
              {{ Math.abs(weeklyStats.trend) }}%
            </div>
            <i class="el-icon-s-data overview-icon"></i>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 图表区域 -->
    <el-card class="chart-card">
      <div slot="header" class="clearfix">
        <span class="card-title">📊 本周每日新增错题趋势图</span>
      </div>
      <div v-loading="loading" class="chart-container">
        <div id="weeklyChart" :style="{ height: chartHeight }"></div>
      </div>
    </el-card>

    <!-- 熟练度统计 -->
    <el-card class="proficiency-card">
      <div slot="header" class="clearfix">
        <span class="card-title">📊 本周错题熟练度统计</span>
      </div>
      <el-row :gutter="16">
        <el-col :xs="24" :sm="12" :md="6">
          <div class="proficiency-item proficiency-proficient" @click="handleProficiencyClick(3)">
            <div class="proficiency-icon">
              <i class="el-icon-success"></i>
            </div>
            <div class="proficiency-content">
              <div class="proficiency-label">熟练</div>
              <div class="proficiency-value">{{ proficiencyStats.proficient }}</div>
              <div class="proficiency-desc">已熟练掌握的错题</div>
            </div>
          </div>
        </el-col>
        <el-col :xs="24" :sm="12" :md="6">
          <div class="proficiency-item proficiency-good" @click="handleProficiencyClick(2)">
            <div class="proficiency-icon">
              <i class="el-icon-check"></i>
            </div>
            <div class="proficiency-content">
              <div class="proficiency-label">较好</div>
              <div class="proficiency-value">{{ proficiencyStats.good }}</div>
              <div class="proficiency-desc">掌握程度较好的错题</div>
            </div>
          </div>
        </el-col>
        <el-col :xs="24" :sm="12" :md="6">
          <div class="proficiency-item proficiency-normal" @click="handleProficiencyClick(1)">
            <div class="proficiency-icon">
              <i class="el-icon-warning"></i>
            </div>
            <div class="proficiency-content">
              <div class="proficiency-label">一般</div>
              <div class="proficiency-value">{{ proficiencyStats.normal }}</div>
              <div class="proficiency-desc">掌握程度一般的错题</div>
            </div>
          </div>
        </el-col>
        <el-col :xs="24" :sm="12" :md="6">
          <div class="proficiency-item proficiency-unfamiliar" @click="handleProficiencyClick(0)">
            <div class="proficiency-icon">
              <i class="el-icon-question"></i>
            </div>
            <div class="proficiency-content">
              <div class="proficiency-label">陌生</div>
              <div class="proficiency-value">{{ proficiencyStats.unfamiliar }}</div>
              <div class="proficiency-desc">需要重点复习的错题</div>
            </div>
          </div>
        </el-col>
      </el-row>
      <div class="proficiency-tip">
        <i class="el-icon-info"></i>
        <span>提示：熟练度标签可以帮助您判断是否应该删除错题。熟练度越高，说明掌握程度越好，可以考虑删除。</span>
      </div>
    </el-card>

    <!-- 详细数据表格 -->
    <el-card class="table-card">
      <div slot="header" class="clearfix">
        <span class="card-title">📋 本周详细数据列表</span>
      </div>
      <el-table :data="weeklyData" stripe style="width: 100%">
        <el-table-column prop="date" label="日期" width="150" align="center">
          <template slot-scope="scope">
            <i class="el-icon-date"></i> {{ scope.row.date }}
          </template>
        </el-table-column>
        <el-table-column prop="dayOfWeek" label="星期" width="100" align="center">
          <template slot-scope="scope">
            <el-tag size="small" :type="scope.row.isToday ? 'success' : 'info'">
              {{ scope.row.dayOfWeek }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="count" label="新增数量" width="120" align="center">
          <template slot-scope="scope">
            <span class="count-number">{{ scope.row.count }}</span>
          </template>
        </el-table-column>
        <el-table-column label="占比" width="150" align="center">
          <template slot-scope="scope">
            <el-progress 
              :percentage="calculatePercentage(scope.row.count)" 
              :color="getProgressColor(scope.row.count)"
            ></el-progress>
          </template>
        </el-table-column>
        <el-table-column label="趋势" align="center">
          <template slot-scope="scope">
            <div class="trend-info">
              <i v-if="scope.row.trend > 0" class="el-icon-top trend-up-icon"></i>
              <i v-else-if="scope.row.trend < 0" class="el-icon-bottom trend-down-icon"></i>
              <i v-else class="el-icon-minus trend-stable-icon"></i>
              <span :class="getTrendClass(scope.row.trend)">
                {{ scope.row.trend > 0 ? '+' : '' }}{{ scope.row.trend !== 0 ? scope.row.trend : '持平' }}
              </span>
            </div>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script>
import * as echarts from 'echarts';
import { listQuestion } from "@/api/trouble/question";

export default {
  name: "WeeklyChart",
  data() {
    return {
      loading: true,
      weeklyData: [],
      weeklyStats: {
        total: 0,
        average: 0,
        max: 0,
        trend: 0
      },
      proficiencyStats: {
        proficient: 0,  // 熟练
        good: 0,        // 较好
        normal: 0,      // 一般
        unfamiliar: 0   // 陌生
      },
      chart: null,
      chartHeight: '400px'
    };
  },
  mounted() {
    this.initData();
    this.handleResize();
    window.addEventListener('resize', this.handleResize);
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.handleResize);
    if (this.chart) {
      this.chart.dispose();
    }
  },
  methods: {
    /** 初始化数据 */
    async initData() {
      this.loading = true;
      try {
        await this.fetchWeeklyData();
        this.calculateStats();
        this.$nextTick(() => {
          this.initChart();
        });
      } catch (error) {
        this.$modal.msgError("加载数据失败");
        if (process.env.NODE_ENV === 'development') {
          console.error(error);
        }
      } finally {
        this.loading = false;
      }
    },

    /** 获取本周数据 */
    async fetchWeeklyData() {
      const today = new Date();
      const dayOfWeek = today.getDay() || 7; // 将周日(0)转换为7
      const dates = [];
      
      // 生成本周七天的日期（从周一到周日）
      for (let i = 1; i <= 7; i++) {
        const date = new Date(today);
        date.setDate(today.getDate() - (dayOfWeek - i));
        dates.push(date);
      }

      // 获取当前用户的所有错题
      const response = await listQuestion({ pageNum: 1, pageSize: 1000 });
      const questions = response.rows || [];

      // 统计本周的错题（用于熟练度统计）
      const weekStart = new Date(today);
      weekStart.setDate(today.getDate() - (dayOfWeek - 1));
      weekStart.setHours(0, 0, 0, 0);
      
      const weekEnd = new Date(weekStart);
      weekEnd.setDate(weekStart.getDate() + 7);
      weekEnd.setHours(23, 59, 59, 999);

      // 筛选本周的错题
      const thisWeekQuestions = questions.filter(q => {
        const createDate = new Date(q.createTime);
        return createDate >= weekStart && createDate < weekEnd;
      });

      // 统计熟练度
      this.proficiencyStats = {
        proficient: thisWeekQuestions.filter(q => q.proficiency === 3).length,
        good: thisWeekQuestions.filter(q => q.proficiency === 2).length,
        normal: thisWeekQuestions.filter(q => q.proficiency === 1).length,
        unfamiliar: thisWeekQuestions.filter(q => q.proficiency === 0 || q.proficiency === null || q.proficiency === undefined).length
      };

      // 统计每天的数量
      this.weeklyData = dates.map((date, index) => {
        const dateStr = this.formatDate(date);
        const count = questions.filter(q => {
          const createDate = new Date(q.createTime);
          return this.formatDate(createDate) === dateStr;
        }).length;

        const prevCount = index > 0 ? this.weeklyData[index - 1]?.count || 0 : 0;
        const trend = index > 0 ? count - prevCount : 0;

        return {
          date: dateStr,
          dayOfWeek: this.getDayOfWeek(date.getDay()),
          count: count,
          trend: trend,
          isToday: this.formatDate(date) === this.formatDate(today)
        };
      });
    },

    /** 计算统计数据 */
    calculateStats() {
      const counts = this.weeklyData.map(d => d.count);
      this.weeklyStats.total = counts.reduce((a, b) => a + b, 0);
      this.weeklyStats.average = Math.round(this.weeklyStats.total / 7);
      this.weeklyStats.max = Math.max(...counts);
      
      // 计算趋势（本周与上周对比，这里简化为前3天vs后3天）
      const firstHalf = counts.slice(0, 3).reduce((a, b) => a + b, 0);
      const secondHalf = counts.slice(4, 7).reduce((a, b) => a + b, 0);
      if (firstHalf > 0) {
        this.weeklyStats.trend = Math.round(((secondHalf - firstHalf) / firstHalf) * 100);
      } else {
        this.weeklyStats.trend = secondHalf > 0 ? 100 : 0;
      }
    },

    /** 初始化图表 */
    initChart() {
      const chartDom = document.getElementById('weeklyChart');
      if (!chartDom) return;

      this.chart = echarts.init(chartDom);
      
      const option = {
        title: {
          text: '本周新增错题趋势',
          left: 'center',
          textStyle: {
            color: '#2c3e50',
            fontSize: 16,
            fontWeight: 600
          }
        },
        tooltip: {
          trigger: 'axis',
          backgroundColor: 'rgba(255, 255, 255, 0.95)',
          borderColor: '#2a5298',
          borderWidth: 1,
          textStyle: {
            color: '#2c3e50'
          },
          formatter: (params) => {
            const data = params[0];
            return `
              <div style="padding: 8px;">
                <div style="font-weight: 600; margin-bottom: 8px;">${data.name}</div>
                <div style="color: #2a5298;">新增错题: ${data.value} 道</div>
              </div>
            `;
          }
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        },
        xAxis: {
          type: 'category',
          data: this.weeklyData.map(d => d.dayOfWeek),
          axisLine: {
            lineStyle: {
              color: '#d4e8f7'
            }
          },
          axisLabel: {
            color: '#5a6c7d',
            fontSize: 12
          }
        },
        yAxis: {
          type: 'value',
          name: '错题数量',
          nameTextStyle: {
            color: '#5a6c7d',
            fontSize: 12
          },
          axisLine: {
            lineStyle: {
              color: '#d4e8f7'
            }
          },
          axisLabel: {
            color: '#5a6c7d'
          },
          splitLine: {
            lineStyle: {
              color: '#e8f1f8',
              type: 'dashed'
            }
          }
        },
        series: [
          {
            name: '新增错题',
            type: 'line',
            data: this.weeklyData.map(d => d.count),
            smooth: true,
            lineStyle: {
              width: 3,
              color: {
                type: 'linear',
                x: 0,
                y: 0,
                x2: 1,
                y2: 0,
                colorStops: [
                  { offset: 0, color: '#1e3c72' },
                  { offset: 1, color: '#2a5298' }
                ]
              }
            },
            areaStyle: {
              color: {
                type: 'linear',
                x: 0,
                y: 0,
                x2: 0,
                y2: 1,
                colorStops: [
                  { offset: 0, color: 'rgba(42, 82, 152, 0.3)' },
                  { offset: 1, color: 'rgba(42, 82, 152, 0.05)' }
                ]
              }
            },
            itemStyle: {
              color: '#2a5298',
              borderColor: '#ffffff',
              borderWidth: 2
            },
            emphasis: {
              itemStyle: {
                color: '#1e3c72',
                borderWidth: 3
              }
            }
          }
        ]
      };

      this.chart.setOption(option);
    },

    /** 响应式处理 */
    handleResize() {
      if (window.innerWidth < 768) {
        this.chartHeight = '300px';
      } else {
        this.chartHeight = '400px';
      }
      
      if (this.chart) {
        this.chart.resize();
      }
    },

    /** 格式化日期 */
    formatDate(date) {
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, '0');
      const day = String(date.getDate()).padStart(2, '0');
      return `${year}-${month}-${day}`;
    },

    /** 获取星期 */
    getDayOfWeek(day) {
      const days = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
      return days[day];
    },

    /** 计算百分比 */
    calculatePercentage(count) {
      if (this.weeklyStats.total === 0) return 0;
      return Math.round((count / this.weeklyStats.total) * 100);
    },

    /** 获取进度条颜色 */
    getProgressColor(count) {
      const percentage = this.calculatePercentage(count);
      if (percentage >= 30) return '#2a5298';
      if (percentage >= 20) return '#4a9ff5';
      return '#90caf9';
    },

    /** 获取趋势类名 */
    getTrendClass(trend) {
      if (trend > 0) return 'trend-up-text';
      if (trend < 0) return 'trend-down-text';
      return 'trend-stable-text';
    },

    /** 返回首页 */
    goBack() {
      this.$router.push('/');
    },

    /** 处理熟练度点击 */
    handleProficiencyClick(proficiency) {
      // 获取本周的开始和结束时间
      const today = new Date();
      const dayOfWeek = today.getDay() || 7;
      const weekStart = new Date(today);
      weekStart.setDate(today.getDate() - (dayOfWeek - 1));
      weekStart.setHours(0, 0, 0, 0);
      
      const weekEnd = new Date(weekStart);
      weekEnd.setDate(weekStart.getDate() + 7);
      weekEnd.setHours(23, 59, 59, 999);

      // 跳转到错题列表页面，并筛选对应熟练度的题目，同时传递时间范围参数
      this.$router.push({
        path: '/trouble/question/view',
        query: {
          proficiency: proficiency,
          weekStart: weekStart.toISOString(),
          weekEnd: weekEnd.toISOString()
        }
      });
    }
  }
};
</script>

<style scoped>
/* 蓝色系美化 - 本周统计页面 */
::v-deep .app-container {
  background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 50%, #90caf9 100%);
  min-height: calc(100vh - 50px);
  padding: 20px;
  position: relative;
  overflow: hidden;
}

/* 背景装饰元素 */
::v-deep .app-container::before {
  content: '';
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle, rgba(33, 150, 243, 0.1) 0%, transparent 70%);
  animation: rotate 30s linear infinite;
  z-index: 0;
}

::v-deep .app-container > * {
  position: relative;
  z-index: 1;
}

@keyframes rotate {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

/* 页面头部 */
.page-header {
  margin-bottom: 24px;
  padding: 24px;
  background: rgba(255, 255, 255, 0.98);
  backdrop-filter: blur(15px);
  border-radius: 16px;
  box-shadow: 0 10px 40px rgba(30, 60, 114, 0.25);
  animation: slideIn 0.6s ease-out;
}

@keyframes slideIn {
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
  flex-direction: column;
  gap: 8px;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 12px;
}

.header-icon {
  font-size: 32px;
  background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.header-title {
  margin: 0;
  font-size: 24px;
  font-weight: 600;
  background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.header-desc {
  margin: 0;
  font-size: 14px;
  color: #7a8a9a;
  padding-left: 44px;
}

/* 操作按钮区 */
.mb8 {
  margin-bottom: 16px;
  padding: 20px;
  background: rgba(255, 255, 255, 0.98);
  backdrop-filter: blur(15px);
  border-radius: 12px;
  box-shadow: 0 6px 28px rgba(30, 60, 114, 0.18);
}

::v-deep .el-button {
  border-radius: 10px;
  font-weight: 600;
  font-size: 15px;
  padding: 12px 24px;
  transition: all 0.3s;
  letter-spacing: 0.5px;
  color: #ffffff;
}

::v-deep .el-button i {
  font-size: 16px;
  margin-right: 6px;
}

::v-deep .el-button--info {
  background: linear-gradient(135deg, #5a6c7d 0%, #7a8a9a 100%);
  border: none;
  box-shadow: 0 4px 12px rgba(90, 108, 125, 0.25);
}

::v-deep .el-button--info:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 24px rgba(90, 108, 125, 0.4);
}

/* 统计概览卡片 */
.stats-overview {
  margin-bottom: 24px;
}

::v-deep .overview-card {
  border-radius: 12px;
  border: none;
  box-shadow: 0 4px 20px rgba(30, 60, 114, 0.15);
  background: rgba(255, 255, 255, 0.98);
  backdrop-filter: blur(15px);
  transition: all 0.3s;
}

::v-deep .overview-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 32px rgba(30, 60, 114, 0.25);
}

.overview-content {
  position: relative;
  padding: 20px;
  padding-right: 60px;
}

.overview-label {
  font-size: 14px;
  color: #7a8a9a;
  margin-bottom: 8px;
}

.overview-value {
  font-size: 28px;
  font-weight: 700;
  background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.overview-value.trend {
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 24px;
}

.trend-up {
  color: #67c23a !important;
  -webkit-text-fill-color: #67c23a !important;
}

.trend-down {
  color: #f56c6c !important;
  -webkit-text-fill-color: #f56c6c !important;
}

.overview-icon {
  position: absolute;
  top: 50%;
  right: 16px;
  transform: translateY(-50%);
  font-size: 42px;
  color: rgba(42, 82, 152, 0.12);
}

/* 图表卡片 */
.chart-card,
.table-card {
  margin-bottom: 24px;
  border-radius: 16px;
  border: none;
  box-shadow: 0 6px 28px rgba(30, 60, 114, 0.18);
  background: rgba(255, 255, 255, 0.98);
  backdrop-filter: blur(15px);
}

::v-deep .chart-card .el-card__header,
::v-deep .table-card .el-card__header {
  background: linear-gradient(135deg, #f8fbff 0%, #ffffff 100%);
  border-bottom: 2px solid #e8f1f8;
  padding: 16px 20px;
}

.card-title {
  font-size: 16px;
  font-weight: 600;
  color: #2c3e50;
}

.chart-container {
  padding: 20px;
  min-height: 400px;
}

#weeklyChart {
  width: 100%;
}

/* 表格样式 */
::v-deep .el-table {
  background: transparent;
}

::v-deep .el-table th {
  background: linear-gradient(135deg, #f8fbff 0%, #ffffff 100%);
  color: #2c3e50;
  font-weight: 600;
}

::v-deep .el-table td {
  border-bottom: 1px solid #e8f1f8;
}

.count-number {
  font-size: 18px;
  font-weight: 700;
  color: #2a5298;
}

.trend-info {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 4px;
}

.trend-up-icon {
  color: #67c23a;
  font-size: 16px;
}

.trend-down-icon {
  color: #f56c6c;
  font-size: 16px;
}

.trend-stable-icon {
  color: #909399;
  font-size: 16px;
}

.trend-up-text {
  color: #67c23a;
  font-weight: 600;
}

.trend-down-text {
  color: #f56c6c;
  font-weight: 600;
}

.trend-stable-text {
  color: #909399;
  font-weight: 600;
}

/* 熟练度统计卡片 */
.proficiency-card {
  margin-bottom: 24px;
  border-radius: 16px;
  border: none;
  box-shadow: 0 6px 28px rgba(30, 60, 114, 0.18);
  background: rgba(255, 255, 255, 0.98);
  backdrop-filter: blur(15px);
}

::v-deep .proficiency-card .el-card__header {
  background: linear-gradient(135deg, #f8fbff 0%, #ffffff 100%);
  border-bottom: 2px solid #e8f1f8;
  padding: 16px 20px;
}

.proficiency-item {
  display: flex;
  align-items: center;
  padding: 20px;
  border-radius: 12px;
  background: #ffffff;
  box-shadow: 0 4px 12px rgba(30, 60, 114, 0.1);
  transition: all 0.3s;
  margin-bottom: 16px;
  cursor: pointer;
  position: relative;
}

.proficiency-item:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(30, 60, 114, 0.2);
}

.proficiency-item:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(30, 60, 114, 0.2);
}

.proficiency-icon {
  font-size: 48px;
  margin-right: 16px;
  flex-shrink: 0;
}

.proficiency-proficient .proficiency-icon {
  color: #67c23a;
}

.proficiency-good .proficiency-icon {
  color: #409eff;
}

.proficiency-normal .proficiency-icon {
  color: #e6a23c;
}

.proficiency-unfamiliar .proficiency-icon {
  color: #f56c6c;
}

.proficiency-content {
  flex: 1;
}

.proficiency-label {
  font-size: 14px;
  color: #7a8a9a;
  margin-bottom: 8px;
}

.proficiency-value {
  font-size: 32px;
  font-weight: 700;
  margin-bottom: 4px;
}

.proficiency-proficient .proficiency-value {
  color: #67c23a;
}

.proficiency-good .proficiency-value {
  color: #409eff;
}

.proficiency-normal .proficiency-value {
  color: #e6a23c;
}

.proficiency-unfamiliar .proficiency-value {
  color: #f56c6c;
}

.proficiency-desc {
  font-size: 12px;
  color: #909399;
}

.proficiency-item::after {
  content: '点击查看';
  position: absolute;
  bottom: 8px;
  right: 12px;
  font-size: 11px;
  color: #909399;
  opacity: 0;
  transition: opacity 0.3s;
}

.proficiency-item:hover::after {
  opacity: 1;
}

.proficiency-tip {
  margin-top: 20px;
  padding: 12px 16px;
  background: #f0f9ff;
  border-left: 4px solid #409eff;
  border-radius: 4px;
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
  color: #606266;
}

.proficiency-tip i {
  font-size: 16px;
  color: #409eff;
}

/* 响应式设计 */
@media (max-width: 768px) {
  ::v-deep .app-container {
    padding: 12px;
  }

  .page-header {
    padding: 16px;
  }

  .header-icon {
    font-size: 24px;
  }

  .header-title {
    font-size: 20px;
  }

  .header-desc {
    padding-left: 36px;
    font-size: 13px;
  }

  .mb8 {
    padding: 12px;
  }

  .overview-value {
    font-size: 24px;
  }

  .chart-container {
    padding: 10px;
  }
}
</style>

