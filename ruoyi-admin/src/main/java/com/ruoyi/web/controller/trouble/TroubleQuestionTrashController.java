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
import com.ruoyi.system.domain.TroubleQuestionTrash;
import com.ruoyi.system.service.ITroubleQuestionTrashService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 错题回收站Controller
 * 
 * @author ruoyi
 */
@RestController
@RequestMapping("/trouble/trash")
public class TroubleQuestionTrashController extends BaseController
{
    @Autowired
    private ITroubleQuestionTrashService troubleQuestionTrashService;

    /**
     * 查询错题回收站列表
     */
    @PreAuthorize("@ss.hasPermi('trouble:trash:list')")
    @GetMapping("/list")
    public TableDataInfo list(TroubleQuestionTrash troubleQuestionTrash)
    {
        startPage();
        List<TroubleQuestionTrash> list = troubleQuestionTrashService.selectTroubleQuestionTrashList(troubleQuestionTrash);
        return getDataTable(list);
    }

    /**
     * 导出错题回收站列表
     */
    @PreAuthorize("@ss.hasPermi('trouble:trash:export')")
    @Log(title = "错题回收站", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, TroubleQuestionTrash troubleQuestionTrash)
    {
        List<TroubleQuestionTrash> list = troubleQuestionTrashService.selectTroubleQuestionTrashList(troubleQuestionTrash);
        ExcelUtil<TroubleQuestionTrash> util = new ExcelUtil<TroubleQuestionTrash>(TroubleQuestionTrash.class);
        util.exportExcel(response, list, "错题回收站数据");
    }

    /**
     * 获取错题回收站详细信息
     */
    @PreAuthorize("@ss.hasPermi('trouble:trash:query')")
    @GetMapping(value = "/{trashId}")
    public AjaxResult getInfo(@PathVariable("trashId") Long trashId)
    {
        return success(troubleQuestionTrashService.selectTroubleQuestionTrashByTrashId(trashId));
    }

    /**
     * 恢复错题
     */
    @PreAuthorize("@ss.hasPermi('trouble:trash:restore')")
    @Log(title = "错题回收站", businessType = BusinessType.UPDATE)
    @PostMapping("/restore/{trashId}")
    public AjaxResult restore(@PathVariable Long trashId)
    {
        return toAjax(troubleQuestionTrashService.restoreQuestion(trashId));
    }

    /**
     * 批量恢复错题
     */
    @PreAuthorize("@ss.hasPermi('trouble:trash:restore')")
    @Log(title = "错题回收站", businessType = BusinessType.UPDATE)
    @PostMapping("/restore")
    public AjaxResult restoreBatch(@RequestBody Long[] trashIds)
    {
        int result = 0;
        for (Long trashId : trashIds) {
            result += troubleQuestionTrashService.restoreQuestion(trashId);
        }
        return toAjax(result);
    }

    /**
     * 彻底删除错题
     */
    @PreAuthorize("@ss.hasPermi('trouble:trash:remove')")
    @Log(title = "错题回收站", businessType = BusinessType.DELETE)
    @DeleteMapping("/{trashIds}")
    public AjaxResult remove(@PathVariable Long[] trashIds)
    {
        return toAjax(troubleQuestionTrashService.permanentlyDeleteQuestions(trashIds));
    }

    /**
     * 清空回收站
     */
    @PreAuthorize("@ss.hasPermi('trouble:trash:clear')")
    @Log(title = "错题回收站", businessType = BusinessType.DELETE)
    @PostMapping("/clear")
    public AjaxResult clearTrash()
    {
        // 查询所有回收站记录
        TroubleQuestionTrash query = new TroubleQuestionTrash();
        List<TroubleQuestionTrash> allTrash = troubleQuestionTrashService.selectTroubleQuestionTrashList(query);
        
        if (allTrash.isEmpty()) {
            return success("回收站已经是空的");
        }
        
        // 获取所有ID
        Long[] trashIds = allTrash.stream().map(TroubleQuestionTrash::getTrashId).toArray(Long[]::new);
        
        return toAjax(troubleQuestionTrashService.permanentlyDeleteQuestions(trashIds));
    }
}



