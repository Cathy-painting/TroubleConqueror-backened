package com.ruoyi.quartz.task;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import com.ruoyi.system.service.ITroubleQuestionDeletedService;

/**
 * 错题清理定时任务
 * 
 * @author ruoyi
 */
@Component("troubleCleanTask")
public class TroubleCleanTask
{
    @Autowired
    private ITroubleQuestionDeletedService troubleQuestionDeletedService;

    /**
     * 清理过期的软删除错题
     * 每月1号凌晨2点执行
     */
    public void cleanExpiredQuestions()
    {
        try
        {
            int result = troubleQuestionDeletedService.cleanExpiredQuestions();
            System.out.println("定时清理任务执行完成，清理了 " + result + " 条过期数据");
        }
        catch (Exception e)
        {
            System.err.println("定时清理任务执行失败：" + e.getMessage());
        }
    }
}
