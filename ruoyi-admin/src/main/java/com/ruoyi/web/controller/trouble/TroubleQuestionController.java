package com.ruoyi.web.controller.trouble;

import java.util.List;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.TroubleQuestion;
import com.ruoyi.system.service.ITroubleQuestionService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.utils.SecurityUtils;

/**
 * 错题Controller
 * 
 * @author ruoyi
 */
@RestController
@RequestMapping("/trouble/question")
public class TroubleQuestionController extends BaseController
{
    @Autowired
    private ITroubleQuestionService troubleQuestionService;

    /**
     * 查询错题列表
     */
    @PreAuthorize("@ss.hasPermi('trouble:question:list')")
    @GetMapping("/list")
    public TableDataInfo list(TroubleQuestion troubleQuestion)
    {
        // 只查询当前用户的错题
        troubleQuestion.setUserId(SecurityUtils.getUserId());
        startPage();
        List<TroubleQuestion> list = troubleQuestionService.selectTroubleQuestionList(troubleQuestion);
        return getDataTable(list);
    }

    /**
     * 导出错题列表
     */
    @PreAuthorize("@ss.hasPermi('trouble:question:export')")
    @Log(title = "错题", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, TroubleQuestion troubleQuestion)
    {
        troubleQuestion.setUserId(SecurityUtils.getUserId());
        List<TroubleQuestion> list = troubleQuestionService.selectTroubleQuestionList(troubleQuestion);
        ExcelUtil<TroubleQuestion> util = new ExcelUtil<TroubleQuestion>(TroubleQuestion.class);
        util.exportExcel(response, list, "错题数据");
    }

    /**
     * 获取错题详细信息
     */
    @PreAuthorize("@ss.hasPermi('trouble:question:query')")
    @GetMapping(value = "/{questionId}")
    public AjaxResult getInfo(@PathVariable("questionId") Long questionId)
    {
        TroubleQuestion question = troubleQuestionService.selectTroubleQuestionByQuestionId(questionId);
        // 验证是否属于当前用户
        if (question != null && !question.getUserId().equals(SecurityUtils.getUserId())) {
            return error("无权限访问该错题");
        }
        return success(question);
    }

    /**
     * 新增错题
     */
    @PreAuthorize("@ss.hasPermi('trouble:question:add')")
    @Log(title = "错题", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody TroubleQuestion troubleQuestion)
    {
        // 设置当前用户ID
        troubleQuestion.setUserId(SecurityUtils.getUserId());
        // 设置默认题目类型
        if (troubleQuestion.getQuestionType() == null || troubleQuestion.getQuestionType().isEmpty()) {
            troubleQuestion.setQuestionType("未区分");
        }
        return toAjax(troubleQuestionService.insertTroubleQuestion(troubleQuestion));
    }

    /**
     * 修改错题
     */
    @PreAuthorize("@ss.hasPermi('trouble:question:edit')")
    @Log(title = "错题", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody TroubleQuestion troubleQuestion)
    {
        // 验证是否属于当前用户
        TroubleQuestion existingQuestion = troubleQuestionService.selectTroubleQuestionByQuestionId(troubleQuestion.getQuestionId());
        if (existingQuestion == null || !existingQuestion.getUserId().equals(SecurityUtils.getUserId())) {
            return error("无权限修改该错题");
        }
        troubleQuestion.setUserId(SecurityUtils.getUserId());
        return toAjax(troubleQuestionService.updateTroubleQuestion(troubleQuestion));
    }

    /**
     * 删除错题
     */
    @PreAuthorize("@ss.hasPermi('trouble:question:remove')")
    @Log(title = "错题", businessType = BusinessType.DELETE)
	@DeleteMapping("/{questionIds}")
    public AjaxResult remove(@PathVariable Long[] questionIds)
    {
        // 验证所有错题是否属于当前用户
        for (Long questionId : questionIds) {
            TroubleQuestion question = troubleQuestionService.selectTroubleQuestionByQuestionId(questionId);
            if (question == null || !question.getUserId().equals(SecurityUtils.getUserId())) {
                return error("无权限删除该错题");
            }
        }
        return toAjax(troubleQuestionService.deleteTroubleQuestionByQuestionIds(questionIds));
    }
}


