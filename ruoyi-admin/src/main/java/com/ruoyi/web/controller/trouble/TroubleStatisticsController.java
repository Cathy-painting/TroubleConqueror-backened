package com.ruoyi.web.controller.trouble;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.service.ITroubleQuestionService;
import com.ruoyi.system.service.ITroubleQuestionTrashService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

/**
 * 错题统计Controller
 * 
 * @author ruoyi
 */
@RestController
@RequestMapping("/trouble")
public class TroubleStatisticsController extends BaseController
{
    @Autowired
    private ITroubleQuestionService troubleQuestionService;

    @Autowired
    private ITroubleQuestionTrashService troubleQuestionTrashService;

    /**
     * 获取错题统计数据
     */
    @GetMapping("/statistics")
    public AjaxResult getStatistics()
    {
        Long userId = SecurityUtils.getUserId();
        
        // 总错题数
        int totalQuestions = troubleQuestionService.selectTroubleQuestionList(
            new com.ruoyi.system.domain.TroubleQuestion() {{
                setUserId(userId);
            }}
        ).size();

        // 今日新增错题数
        int todayQuestions = troubleQuestionService.selectTroubleQuestionList(
            new com.ruoyi.system.domain.TroubleQuestion() {{
                setUserId(userId);
                setParams(new HashMap<String, Object>() {{
                    put("beginTime", java.time.LocalDate.now().toString());
                    put("endTime", java.time.LocalDate.now().toString());
                }});
            }}
        ).size();

        // 本周新增错题数
        java.time.LocalDate startOfWeek = java.time.LocalDate.now().with(java.time.DayOfWeek.MONDAY);
        java.time.LocalDate endOfWeek = startOfWeek.plusDays(6);
        
        int thisWeekQuestions = troubleQuestionService.selectTroubleQuestionList(
            new com.ruoyi.system.domain.TroubleQuestion() {{
                setUserId(userId);
                setParams(new HashMap<String, Object>() {{
                    put("beginTime", startOfWeek.toString());
                    put("endTime", endOfWeek.toString());
                }});
            }}
        ).size();

        // 标签数量统计
        java.util.List<com.ruoyi.system.domain.TroubleQuestion> allQuestions = 
            troubleQuestionService.selectTroubleQuestionList(
                new com.ruoyi.system.domain.TroubleQuestion() {{
                    setUserId(userId);
                }}
            );
        
        java.util.Set<String> uniqueTags = new java.util.HashSet<>();
        for (com.ruoyi.system.domain.TroubleQuestion question : allQuestions) {
            if (question.getTags() != null && !question.getTags().trim().isEmpty()) {
                String[] tags = question.getTags().split(",");
                for (String tag : tags) {
                    if (!tag.trim().isEmpty()) {
                        uniqueTags.add(tag.trim());
                    }
                }
            }
        }
        int tagsCount = uniqueTags.size();

        // 回收站数量
        int trashCount = troubleQuestionTrashService.selectTroubleQuestionTrashList(
            new com.ruoyi.system.domain.TroubleQuestionTrash() {{
                setUserId(userId);
            }}
        ).size();

        Map<String, Object> statistics = new HashMap<>();
        statistics.put("totalQuestions", totalQuestions);
        statistics.put("todayQuestions", todayQuestions);
        statistics.put("thisWeekQuestions", thisWeekQuestions);
        statistics.put("tagsCount", tagsCount);
        statistics.put("trashCount", trashCount);

        return success(statistics);
    }
}



