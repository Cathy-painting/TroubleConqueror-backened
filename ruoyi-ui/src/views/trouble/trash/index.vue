<template>
  <div class="app-container">
    <!-- 页面标题 -->
    <div class="page-header">
      <h2><i class="el-icon-delete"></i> 错题回收站</h2>
      <p class="page-desc">管理已删除的错题，可以恢复或彻底删除</p>
    </div>
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="题目内容" prop="questionContent">
        <el-input
          v-model="queryParams.questionContent"
          placeholder="请输入题目内容"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="题目类型" prop="questionType">
        <el-select v-model="queryParams.questionType" placeholder="请选择题目类型" clearable>
          <el-option label="未区分" value="未区分" />
          <el-option label="选择题" value="选择题" />
          <el-option label="填空题" value="填空题" />
          <el-option label="解答题" value="解答题" />
          <el-option label="其他" value="其他" />
        </el-select>
      </el-form-item>
      <el-form-item label="删除者" prop="deleteBy">
        <el-input
          v-model="queryParams.deleteBy"
          placeholder="请输入删除者"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="info"
          plain
          icon="el-icon-house"
          size="mini"
          @click="goToDashboard"
        >返回主页</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-refresh-left"
          size="mini"
          :disabled="single"
          @click="handleRestore"
          v-hasPermi="['trouble:trash:restore']"
        >恢复</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handlePermanentlyDelete"
          v-hasPermi="['trouble:trash:remove']"
        >彻底删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-delete"
          size="mini"
          @click="handleClearTrash"
          v-hasPermi="['trouble:trash:clear']"
        >清空回收站</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="info"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['trouble:trash:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="trashList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="原错题ID" align="center" prop="questionId" width="100" />
      <el-table-column label="题目内容" align="center" prop="questionContent" :show-overflow-tooltip="true" />
      <el-table-column label="题目图片" align="center" prop="questionImages" width="100">
        <template slot-scope="scope">
            <el-image
              v-if="scope.row.questionImages"
              :src="getImageUrl(scope.row.questionImages.split(',')[0])"
              :preview-src-list="scope.row.questionImages.split(',').map(img => getImageUrl(img))"
              style="width: 60px; height: 60px"
              fit="cover"
            />
            <span v-else>-</span>
        </template>
      </el-table-column>
      <el-table-column label="题目类型" align="center" prop="questionType" width="100" />
      <el-table-column label="标签" align="center" prop="tags" width="150">
        <template slot-scope="scope">
          <el-tag v-for="tag in getTagsArray(scope.row.tags)" :key="tag" size="mini" style="margin-right: 5px;">
            {{ tag }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="删除原因" align="center" prop="deleteReason" width="120" />
      <el-table-column label="删除者" align="center" prop="deleteBy" width="100" />
      <el-table-column label="删除时间" align="center" prop="deleteTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.deleteTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="原创建时间" align="center" prop="originalCreateTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.originalCreateTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-refresh-left"
            @click="handleRestore(scope.row)"
            v-hasPermi="['trouble:trash:restore']"
          >恢复</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handlePermanentlyDelete(scope.row)"
            v-hasPermi="['trouble:trash:remove']"
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

    <!-- 清空回收站确认对话框 -->
    <el-dialog title="清空回收站" :visible.sync="clearDialogVisible" width="400px" append-to-body>
      <div style="text-align: center;">
        <i class="el-icon-warning" style="font-size: 48px; color: #E6A23C; margin-bottom: 20px;"></i>
        <p style="font-size: 16px; margin-bottom: 20px;">确定要清空回收站吗？</p>
        <p style="color: #F56C6C; font-size: 14px;">此操作将彻底删除所有回收站中的错题及其图片，且无法恢复！</p>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button @click="clearDialogVisible = false">取 消</el-button>
        <el-button type="danger" @click="confirmClearTrash">确定清空</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listTrash, getTrash, restoreQuestion, restoreQuestions, permanentlyDelete, clearTrash } from "@/api/trouble/trash";

export default {
  name: "Trash",
  data() {
    return {
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 回收站表格数据
      trashList: [],
      // 清空对话框
      clearDialogVisible: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        questionContent: null,
        questionType: null,
        deleteBy: null,
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 返回主页 */
    goToDashboard() {
      this.$router.push("/trouble/test");
    },
    /** 查询回收站列表 */
    getList() {
      this.loading = true;
      listTrash(this.queryParams).then(response => {
        this.trashList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 获取完整的图片URL */
    getImageUrl(imagePath) {
      if (!imagePath) return '';
      // 如果已经是完整URL，直接返回
      if (imagePath.startsWith('http')) {
        return imagePath;
      }
      // 如果是相对路径，添加baseUrl前缀
      const baseUrl = process.env.VUE_APP_BASE_API;
      return baseUrl + (imagePath.startsWith('/') ? imagePath : '/' + imagePath);
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.trashId)
      this.single = selection.length!==1
      this.multiple = !selection.length
    },
    /** 恢复按钮操作 */
    handleRestore(row) {
      const trashIds = row.trashId || this.ids;
      this.$modal.confirm('是否确认恢复错题编号为"' + trashIds + '"的数据项？').then(function() {
        if (Array.isArray(trashIds)) {
          return restoreQuestions(trashIds);
        } else {
          return restoreQuestion(trashIds);
        }
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("恢复成功");
      }).catch(() => {});
    },
    /** 彻底删除按钮操作 */
    handlePermanentlyDelete(row) {
      const trashIds = row.trashId || this.ids;
      this.$modal.confirm('是否确认彻底删除错题编号为"' + trashIds + '"的数据项？删除后将无法恢复，包括相关图片文件！').then(function() {
        return permanentlyDelete(trashIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 清空回收站 */
    handleClearTrash() {
      this.clearDialogVisible = true;
    },
    /** 确认清空回收站 */
    confirmClearTrash() {
      clearTrash().then(() => {
        this.clearDialogVisible = false;
        this.getList();
        this.$modal.msgSuccess("回收站已清空");
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('trouble/trash/export', {
        ...this.queryParams
      }, `trash_${new Date().getTime()}.xlsx`)
    },
    /** 获取标签数组 */
    getTagsArray(tags) {
      if (!tags) return [];
      return tags.split(',').filter(tag => tag.trim());
    }
  }
};
</script>

<style scoped>
.page-header {
  margin-bottom: 20px;
  padding: 20px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 8px;
  color: white;
}

.page-header h2 {
  margin: 0 0 10px 0;
  font-size: 24px;
  font-weight: bold;
  display: flex;
  align-items: center;
}

.page-header h2 i {
  margin-right: 10px;
  font-size: 28px;
}

.page-desc {
  margin: 0;
  font-size: 14px;
  opacity: 0.9;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .page-header {
    padding: 15px;
    margin-bottom: 15px;
  }

  .page-header h2 {
    font-size: 20px;
  }

  .page-header h2 i {
    font-size: 24px;
  }
}
</style>
