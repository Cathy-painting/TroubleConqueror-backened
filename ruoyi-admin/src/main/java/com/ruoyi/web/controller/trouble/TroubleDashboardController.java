package com.ruoyi.web.controller.trouble;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.time.LocalDate;
import java.time.DayOfWeek;
import java.util.Set;
import java.util.HashSet;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.TroubleQuestion;
import com.ruoyi.system.domain.TroubleQuestionTrash;
import com.ruoyi.system.service.ITroubleQuestionService;
import com.ruoyi.system.service.ITroubleQuestionTrashService;

/**
 * 错题控制台Controller
 * 
 * 修复了静态方法调用错误，使用实例调用
 * 
 * @author ruoyi
 */
@RestController
@RequestMapping("/trouble/dashboard")
public class TroubleDashboardController extends BaseController {

    @Autowired
    private ITroubleQuestionService troubleQuestionService;

    @Autowired
    private ITroubleQuestionTrashService troubleQuestionTrashService;

    /**
     * 获取错题统计数据
     */
    @GetMapping("/statistics")
    public AjaxResult getStatistics() {
        Long userId = SecurityUtils.getUserId();

        // 总错题数
        int totalQuestions = troubleQuestionService.selectTroubleQuestionList(
            createQuestion(userId, null, null)
        ).size();

        // 今日新增错题数
        LocalDate today = LocalDate.now();
        int todayQuestions = troubleQuestionService.selectTroubleQuestionList(
            createQuestion(userId, today + " 00:00:00", today.plusDays(1) + " 00:00:00")
        ).size();

        // 本周新增错题数
        LocalDate startOfWeek = LocalDate.now().with(DayOfWeek.MONDAY);
        int thisWeekQuestions = troubleQuestionService.selectTroubleQuestionList(
            createQuestion(userId, startOfWeek + " 00:00:00", LocalDate.now().plusDays(1) + " 00:00:00")
        ).size();

        // 标签数量统计
        List<TroubleQuestion> allQuestions = troubleQuestionService.selectTroubleQuestionList(
            createQuestion(userId, null, null)
        );
        Set<String> uniqueTags = new HashSet<>();
        for (TroubleQuestion question : allQuestions) {
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
            createTrash(userId)
        ).size();

        Map<String, Object> statistics = new HashMap<>();
        statistics.put("totalQuestions", totalQuestions);
        statistics.put("todayQuestions", todayQuestions);
        statistics.put("thisWeekQuestions", thisWeekQuestions);
        statistics.put("tagsCount", tagsCount);
        statistics.put("trashCount", trashCount);

        return success(statistics);
    }

    /**
     * 获取最近错题
     */
    @GetMapping("/recent")
    public AjaxResult getRecentQuestions() {
        Long userId = SecurityUtils.getUserId();
        List<TroubleQuestion> recentQuestions = troubleQuestionService.selectTroubleQuestionList(
            createQuestion(userId, null, null)
        );

        if (recentQuestions.size() > 5) {
            recentQuestions = recentQuestions.subList(0, 5);
        }

        return success(recentQuestions);
    }

    /**
     * 获取标签统计
     */
    @GetMapping("/tags")
    public AjaxResult getTagStats() {
        List<Map<String, Object>> tagStats = new ArrayList<>();

        tagStats.add(createTag("数学", 8, "#409EFF"));
        tagStats.add(createTag("语文", 5, "#67C23A"));
        tagStats.add(createTag("英语", 3, "#E6A23C"));
        tagStats.add(createTag("物理", 2, "#F56C6C"));

        return success(tagStats);
    }

    // ----------- 辅助方法 -----------
    private TroubleQuestion createQuestion(Long userId, String beginTime, String endTime) {
        TroubleQuestion q = new TroubleQuestion();
        q.setUserId(userId);
        if (beginTime != null && endTime != null) {
            Map<String, Object> params = new HashMap<>();
            params.put("beginTime", beginTime);
            params.put("endTime", endTime);
            q.setParams(params);
        }
        return q;
    }

    private TroubleQuestionTrash createTrash(Long userId) {
        TroubleQuestionTrash t = new TroubleQuestionTrash();
        t.setUserId(userId);
        return t;
    }

    private Map<String, Object> createTag(String name, int count, String color) {
        Map<String, Object> tag = new HashMap<>();
        tag.put("name", name);
        tag.put("count", count);
        tag.put("color", color);
        return tag;
    }
}

