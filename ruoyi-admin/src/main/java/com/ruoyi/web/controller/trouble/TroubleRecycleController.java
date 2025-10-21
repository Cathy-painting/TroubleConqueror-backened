package com.ruoyi.web.controller.trouble;

import java.util.List;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.TroubleQuestionDeleted;
import com.ruoyi.system.service.ITroubleQuestionDeletedService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 错题回收站Controller
 * 
 * @author ruoyi
 */
@RestController
@RequestMapping("/trouble/recycle")
public class TroubleRecycleController extends BaseController
{
    @Autowired
    private ITroubleQuestionDeletedService troubleQuestionDeletedService;

    /**
     * 查询软删除错题列表
     */
    @PreAuthorize("@ss.hasPermi('trouble:question:list')")
    @GetMapping("/list")
    public TableDataInfo list(TroubleQuestionDeleted troubleQuestionDeleted)
    {
        startPage();
        List<TroubleQuestionDeleted> list = troubleQuestionDeletedService.selectTroubleQuestionDeletedList(troubleQuestionDeleted);
        return getDataTable(list);
    }

    /**
     * 导出软删除错题列表
     */
    @PreAuthorize("@ss.hasPermi('trouble:question:export')")
    @Log(title = "软删除错题", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, TroubleQuestionDeleted troubleQuestionDeleted)
    {
        List<TroubleQuestionDeleted> list = troubleQuestionDeletedService.selectTroubleQuestionDeletedList(troubleQuestionDeleted);
        ExcelUtil<TroubleQuestionDeleted> util = new ExcelUtil<TroubleQuestionDeleted>(TroubleQuestionDeleted.class);
        util.exportExcel(response, list, "软删除错题数据");
    }

    /**
     * 获取软删除错题详细信息
     */
    @PreAuthorize("@ss.hasPermi('trouble:question:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(troubleQuestionDeletedService.selectTroubleQuestionDeletedById(id));
    }

    /**
     * 恢复错题
     */
    @PreAuthorize("@ss.hasPermi('trouble:question:restore')")
    @Log(title = "恢复错题", businessType = BusinessType.UPDATE)
    @PostMapping("/restore/{ids}")
    public AjaxResult restore(@PathVariable Long[] ids)
    {
        return toAjax(troubleQuestionDeletedService.restoreQuestions(ids));
    }

    /**
     * 彻底删除错题
     */
    @PreAuthorize("@ss.hasPermi('trouble:question:forceDelete')")
    @Log(title = "彻底删除错题", businessType = BusinessType.DELETE)
    @DeleteMapping("/forceDelete/{ids}")
    public AjaxResult forceDelete(@PathVariable Long[] ids)
    {
        return toAjax(troubleQuestionDeletedService.deleteTroubleQuestionDeletedByIds(ids));
    }

    /**
     * 清理过期数据
     */
    @PreAuthorize("@ss.hasPermi('trouble:question:clean')")
    @Log(title = "清理过期数据", businessType = BusinessType.DELETE)
    @PostMapping("/clean")
    public AjaxResult clean()
    {
        return toAjax(troubleQuestionDeletedService.cleanExpiredQuestions());
    }
}
