package com.ruoyi.web.controller.trouble;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.TroubleQuestion;
import com.ruoyi.system.domain.TroubleQuestionTrash;
import com.ruoyi.system.service.ITroubleQuestionService;
import com.ruoyi.system.service.ITroubleQuestionTrashService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 错题测试控制器
 * 
 * @author ruoyi
 */
@RestController
@RequestMapping("/trouble/test")
public class TroubleTestController extends BaseController {

    @Autowired
    private ITroubleQuestionService troubleQuestionService;

    @Autowired
    private ITroubleQuestionTrashService troubleQuestionTrashService;

    /**
     * 获取错题表数据（模拟SQL查询）
     */
    @PreAuthorize("@ss.hasPermi('trouble:question:list')")
    @GetMapping("/sql/trouble_question")
    public AjaxResult getTroubleQuestionData() {
        Long userId = SecurityUtils.getUserId();
        
        TroubleQuestion query = new TroubleQuestion();
        query.setUserId(userId);
        List<TroubleQuestion> questions = troubleQuestionService.selectTroubleQuestionList(query);
        
        Map<String, Object> result = new HashMap<>();
        result.put("sql", "SELECT * FROM trouble_question WHERE user_id = " + userId);
        result.put("count", questions.size());
        result.put("data", questions);
        
        return AjaxResult.success(result);
    }

    /**
     * 获取错题回收站表数据（模拟SQL查询）
     */
    @PreAuthorize("@ss.hasPermi('trouble:trash:list')")
    @GetMapping("/sql/trouble_question_trash")
    public AjaxResult getTroubleQuestionTrashData() {
        Long userId = SecurityUtils.getUserId();
        
        TroubleQuestionTrash query = new TroubleQuestionTrash();
        query.setUserId(userId);
        List<TroubleQuestionTrash> trashList = troubleQuestionTrashService.selectTroubleQuestionTrashList(query);
        
        Map<String, Object> result = new HashMap<>();
        result.put("sql", "SELECT * FROM trouble_question_trash WHERE user_id = " + userId);
        result.put("count", trashList.size());
        result.put("data", trashList);
        
        return AjaxResult.success(result);
    }
}

