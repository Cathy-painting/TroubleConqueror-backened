package com.ruoyi.web.controller.trouble;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.TroubleQuestion;
import com.ruoyi.system.domain.TroubleQuestionTrash;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.service.ITroubleQuestionService;
import com.ruoyi.system.service.ITroubleQuestionTrashService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;
import java.time.LocalDate;
import java.time.DayOfWeek;
import java.time.Instant;
import java.time.ZoneId;
import java.util.List;
import java.util.Set;
import java.util.HashSet;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 错题统计Controller
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/trouble")
public class TroubleStatisticsController extends BaseController
{
    private static final Logger log = LoggerFactory.getLogger(TroubleStatisticsController.class);

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

    // 获取用户所有错题（用于统计）
    List<TroubleQuestion> allQuestions =
        troubleQuestionService.selectTroubleQuestionList(
            new TroubleQuestion() {{
                setUserId(userId);
            }}
        );

    // 总错题数
    int totalQuestions = allQuestions.size();

    // 计算今日与本周新增（基于 createTime 字段）
    int todayQuestions = 0;
    int thisWeekQuestions = 0;
    LocalDate today = LocalDate.now();
    LocalDate startOfWeek = today.with(DayOfWeek.MONDAY);

    for (TroubleQuestion q : allQuestions) {
        if (q.getCreateTime() == null) {
            continue;
        }
        LocalDate createDate = Instant.ofEpochMilli(q.getCreateTime().getTime())
                                     .atZone(ZoneId.systemDefault())
                                     .toLocalDate();
        if (createDate.equals(today)) {
            todayQuestions++;
        }
        if (!createDate.isBefore(startOfWeek) && !createDate.isAfter(today)) {
            thisWeekQuestions++;
        }
    }

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
        new TroubleQuestionTrash() {{
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
