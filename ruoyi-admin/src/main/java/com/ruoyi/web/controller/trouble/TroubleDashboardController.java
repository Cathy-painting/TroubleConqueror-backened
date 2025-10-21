package com.ruoyi.web.controller.trouble;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.service.ITroubleQuestionService;
import com.ruoyi.system.domain.TroubleQuestion;

/**
 * 错题控制台Controller
 * 
 * @author ruoyi
 */
@RestController
@RequestMapping("/trouble/dashboard")
public class TroubleDashboardController extends BaseController
{
    @Autowired
    private ITroubleQuestionService troubleQuestionService;

    /**
     * 获取错题统计数据
     */
    @GetMapping("/stats")
    public AjaxResult getStats()
    {
        Long userId = SecurityUtils.getUserId();
        
        // 查询当前用户的错题统计
        TroubleQuestion query = new TroubleQuestion();
        query.setUserId(userId);
        
        // 总错题数（只统计正常状态的错题，不包括软删除）
        List<TroubleQuestion> allQuestions = troubleQuestionService.selectTroubleQuestionList(query);
        int totalQuestions = allQuestions.size();
        
        // 今日新增（按创建时间统计）
        int todayQuestions = 0;
        int thisWeekQuestions = 0;
        java.util.Calendar calendar = java.util.Calendar.getInstance();
        java.util.Date today = new java.util.Date();
        java.util.Date weekAgo = new java.util.Date(today.getTime() - 7 * 24 * 60 * 60 * 1000);
        
        for (TroubleQuestion question : allQuestions) {
            if (question.getCreateTime() != null) {
                // 今日新增
                if (isSameDay(question.getCreateTime(), today)) {
                    todayQuestions++;
                }
                // 本周新增
                if (question.getCreateTime().after(weekAgo)) {
                    thisWeekQuestions++;
                }
            }
        }
        
        // 标签数量（统计所有标签）
        Set<String> allTags = new HashSet<>();
        for (TroubleQuestion question : allQuestions) {
            if (question.getTags() != null && !question.getTags().isEmpty()) {
                String[] tags = question.getTags().split(",");
                for (String tag : tags) {
                    if (!tag.trim().isEmpty()) {
                        allTags.add(tag.trim());
                    }
                }
            }
        }
        int tagsCount = allTags.size();
        
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalQuestions", totalQuestions);
        stats.put("todayQuestions", todayQuestions);
        stats.put("thisWeekQuestions", thisWeekQuestions);
        stats.put("tagsCount", tagsCount);
        
        return success(stats);
    }
    
    /**
     * 判断两个日期是否为同一天
     */
    private boolean isSameDay(java.util.Date date1, java.util.Date date2) {
        if (date1 == null || date2 == null) {
            return false;
        }
        java.util.Calendar cal1 = java.util.Calendar.getInstance();
        java.util.Calendar cal2 = java.util.Calendar.getInstance();
        cal1.setTime(date1);
        cal2.setTime(date2);
        return cal1.get(java.util.Calendar.YEAR) == cal2.get(java.util.Calendar.YEAR) &&
               cal1.get(java.util.Calendar.DAY_OF_YEAR) == cal2.get(java.util.Calendar.DAY_OF_YEAR);
    }

    /**
     * 获取最近错题
     */
    @GetMapping("/recent")
    public AjaxResult getRecentQuestions()
    {
        Long userId = SecurityUtils.getUserId();
        
        TroubleQuestion query = new TroubleQuestion();
        query.setUserId(userId);
        
        // 查询最近5条错题
        List<TroubleQuestion> recentQuestions = troubleQuestionService.selectTroubleQuestionList(query);
        
        // 限制返回数量
        if (recentQuestions.size() > 5) {
            recentQuestions = recentQuestions.subList(0, 5);
        }
        
        return success(recentQuestions);
    }

    /**
     * 获取标签统计
     */
    @GetMapping("/tags")
    public AjaxResult getTagStats()
    {
        Long userId = SecurityUtils.getUserId();
        
        // 模拟标签统计数据
        List<Map<String, Object>> tagStats = new ArrayList<>();
        
        Map<String, Object> tag1 = new HashMap<>();
        tag1.put("name", "数学");
        tag1.put("count", 8);
        tag1.put("color", "#409EFF");
        tagStats.add(tag1);
        
        Map<String, Object> tag2 = new HashMap<>();
        tag2.put("name", "语文");
        tag2.put("count", 5);
        tag2.put("color", "#67C23A");
        tagStats.add(tag2);
        
        Map<String, Object> tag3 = new HashMap<>();
        tag3.put("name", "英语");
        tag3.put("count", 3);
        tag3.put("color", "#E6A23C");
        tagStats.add(tag3);
        
        Map<String, Object> tag4 = new HashMap<>();
        tag4.put("name", "物理");
        tag4.put("count", 2);
        tag4.put("color", "#F56C6C");
        tagStats.add(tag4);
        
        return success(tagStats);
    }
}
