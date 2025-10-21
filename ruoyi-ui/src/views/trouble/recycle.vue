<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="题目内容" prop="questionContent">
        <el-input
          v-model="queryParams.questionContent"
          placeholder="请输入题目内容"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="删除者" prop="deletedBy">
        <el-input
          v-model="queryParams.deletedBy"
          placeholder="请输入删除者"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="删除时间">
        <el-date-picker
          v-model="dateRange"
          style="width: 240px"
          value-format="yyyy-MM-dd"
          type="daterange"
          range-separator="-"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
        ></el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-refresh-left"
          size="mini"
          :disabled="multiple"
          @click="handleRestore"
          v-hasPermi="['trouble:question:restore']"
        >批量恢复</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleForceDelete"
          v-hasPermi="['trouble:question:forceDelete']"
        >彻底删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-delete"
          size="mini"
          @click="handleCleanExpired"
          v-hasPermi="['trouble:question:clean']"
        >清理过期</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="deletedList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="原错题ID" align="center" prop="questionId" width="100" />
      <el-table-column label="题目内容" align="center" prop="questionContent" :show-overflow-tooltip="true" />
      <el-table-column label="题目图片" align="center" prop="questionImages" width="100">
        <template slot-scope="scope">
          <el-image
            v-if="scope.row.questionImages"
            :src="scope.row.questionImages.split(',')[0]"
            :preview-src-list="scope.row.questionImages.split(',')"
            style="width: 60px; height: 60px"
            fit="cover"
          />
        </template>
      </el-table-column>
      <el-table-column label="答案内容" align="center" prop="answerContent" :show-overflow-tooltip="true" />
      <el-table-column label="题目类型" align="center" prop="questionType" width="100" />
      <el-table-column label="标签" align="center" prop="tags" width="150" />
      <el-table-column label="删除者" align="center" prop="deletedBy" width="100" />
      <el-table-column label="删除时间" align="center" prop="deletedTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.deletedTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="原创建时间" align="center" prop="originalCreateTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.originalCreateTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="200">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-view"
            @click="handleView(scope.row)"
            v-hasPermi="['trouble:question:query']"
          >查看</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-refresh-left"
            @click="handleRestore(scope.row)"
            v-hasPermi="['trouble:question:restore']"
          >恢复</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleForceDelete(scope.row)"
            v-hasPermi="['trouble:question:forceDelete']"
          >彻底删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    
    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 查看详情对话框 -->
    <el-dialog title="错题详情" :visible.sync="viewDialogVisible" width="800px" append-to-body>
      <el-form ref="viewForm" :model="viewForm" label-width="100px">
        <el-form-item label="题目内容">
          <el-input v-model="viewForm.questionContent" type="textarea" :rows="4" readonly />
        </el-form-item>
        <el-form-item label="题目图片" v-if="viewForm.questionImages">
          <el-image
            v-for="(image, index) in viewForm.questionImages.split(',')"
            :key="index"
            :src="image"
            :preview-src-list="viewForm.questionImages.split(',')"
            style="width: 100px; height: 100px; margin-right: 10px;"
            fit="cover"
          />
        </el-form-item>
        <el-form-item label="答案内容" v-if="viewForm.answerContent">
          <el-input v-model="viewForm.answerContent" type="textarea" :rows="3" readonly />
        </el-form-item>
        <el-form-item label="答案图片" v-if="viewForm.answerImages">
          <el-image
            v-for="(image, index) in viewForm.answerImages.split(',')"
            :key="index"
            :src="image"
            :preview-src-list="viewForm.answerImages.split(',')"
            style="width: 100px; height: 100px; margin-right: 10px;"
            fit="cover"
          />
        </el-form-item>
        <el-form-item label="题目类型">
          <el-tag>{{ viewForm.questionType }}</el-tag>
        </el-form-item>
        <el-form-item label="标签" v-if="viewForm.tags">
          <el-tag v-for="tag in viewForm.tags.split(',')" :key="tag" style="margin-right: 5px;">
            {{ tag }}
          </el-tag>
        </el-form-item>
        <el-form-item label="删除信息">
          <p>删除者：{{ viewForm.deletedBy }}</p>
          <p>删除时间：{{ parseTime(viewForm.deletedTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</p>
          <p>原创建时间：{{ parseTime(viewForm.originalCreateTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</p>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
import { listDeletedQuestions, restoreQuestion, forceDeleteQuestion, cleanExpiredQuestions } from "@/api/trouble/recycle";

export default {
  name: "Recycle",
  data() {
    return {
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 软删除错题表格数据
      deletedList: [],
      // 日期范围
      dateRange: [],
      // 查看对话框
      viewDialogVisible: false,
      // 查看表单
      viewForm: {},
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        questionContent: null,
        deletedBy: null,
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询软删除错题列表 */
    getList() {
      this.loading = true;
      listDeletedQuestions(this.queryParams).then(response => {
        this.deletedList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    // 取消按钮
    cancel() {
      this.viewDialogVisible = false;
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.dateRange = [];
      this.resetForm("queryForm");
      this.handleQuery();
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.id)
      this.multiple = !selection.length
    },
    /** 查看详情 */
    handleView(row) {
      this.viewForm = Object.assign({}, row);
      this.viewDialogVisible = true;
    },
    /** 恢复错题 */
    handleRestore(row) {
      const ids = row.id || this.ids;
      this.$modal.confirm('是否确认恢复错题？').then(function() {
        return restoreQuestion(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("恢复成功");
      }).catch(() => {});
    },
    /** 彻底删除 */
    handleForceDelete(row) {
      const ids = row.id || this.ids;
      this.$modal.confirm('彻底删除后将无法恢复，是否确认彻底删除？').then(function() {
        return forceDeleteQuestion(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("彻底删除成功");
      }).catch(() => {});
    },
    /** 清理过期数据 */
    handleCleanExpired() {
      this.$modal.confirm('是否确认清理30天前的软删除数据？').then(function() {
        return cleanExpiredQuestions();
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("清理成功");
      }).catch(() => {});
    }
  }
};
</script>
