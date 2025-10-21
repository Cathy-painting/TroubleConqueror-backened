package com.ruoyi.system.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.TroubleQuestionMapper;
import com.ruoyi.system.mapper.TroubleQuestionDeletedMapper;
import com.ruoyi.system.domain.TroubleQuestion;
import com.ruoyi.system.domain.TroubleQuestionDeleted;
import com.ruoyi.system.service.ITroubleQuestionService;

/**
 * 错题Service业务层处理
 * 
 * @author ruoyi
 */
@Service
public class TroubleQuestionServiceImpl implements ITroubleQuestionService 
{
    @Autowired
    private TroubleQuestionMapper troubleQuestionMapper;

    @Autowired
    private TroubleQuestionDeletedMapper troubleQuestionDeletedMapper;

    /**
     * 查询错题
     * 
     * @param questionId 错题主键
     * @return 错题
     */
    @Override
    public TroubleQuestion selectTroubleQuestionByQuestionId(Long questionId)
    {
        return troubleQuestionMapper.selectTroubleQuestionByQuestionId(questionId);
    }

    /**
     * 查询错题列表
     * 
     * @param troubleQuestion 错题
     * @return 错题
     */
    @Override
    public List<TroubleQuestion> selectTroubleQuestionList(TroubleQuestion troubleQuestion)
    {
        return troubleQuestionMapper.selectTroubleQuestionList(troubleQuestion);
    }

    /**
     * 新增错题
     * 
     * @param troubleQuestion 错题
     * @return 结果
     */
    @Override
    public int insertTroubleQuestion(TroubleQuestion troubleQuestion)
    {
        troubleQuestion.setCreateTime(DateUtils.getNowDate());
        return troubleQuestionMapper.insertTroubleQuestion(troubleQuestion);
    }

    /**
     * 修改错题
     * 
     * @param troubleQuestion 错题
     * @return 结果
     */
    @Override
    public int updateTroubleQuestion(TroubleQuestion troubleQuestion)
    {
        troubleQuestion.setUpdateTime(DateUtils.getNowDate());
        return troubleQuestionMapper.updateTroubleQuestion(troubleQuestion);
    }

    /**
     * 批量删除错题
     * 
     * @param questionIds 需要删除的错题主键
     * @return 结果
     */
    @Override
    public int deleteTroubleQuestionByQuestionIds(Long[] questionIds)
    {
        return troubleQuestionMapper.deleteTroubleQuestionByQuestionIds(questionIds);
    }

    /**
     * 删除错题信息
     * 
     * @param questionId 错题主键
     * @return 结果
     */
    @Override
    public int deleteTroubleQuestionByQuestionId(Long questionId)
    {
        return troubleQuestionMapper.deleteTroubleQuestionByQuestionId(questionId);
    }

    /**
     * 软删除错题
     * 
     * @param questionIds 需要软删除的错题主键
     * @return 结果
     */
    @Override
    public int softDeleteTroubleQuestionByQuestionIds(Long[] questionIds)
    {
        int result = 0;
        for (Long questionId : questionIds) {
            // 查询原错题信息
            TroubleQuestion question = troubleQuestionMapper.selectTroubleQuestionByQuestionId(questionId);
            if (question != null) {
                // 创建软删除记录
                TroubleQuestionDeleted deleted = new TroubleQuestionDeleted();
                deleted.setQuestionId(question.getQuestionId());
                deleted.setUserId(question.getUserId());
                deleted.setQuestionContent(question.getQuestionContent());
                deleted.setQuestionImages(question.getQuestionImages());
                deleted.setAnswerContent(question.getAnswerContent());
                deleted.setAnswerImages(question.getAnswerImages());
                deleted.setQuestionType(question.getQuestionType());
                deleted.setTags(question.getTags());
                deleted.setDeletedBy(SecurityUtils.getUsername());
                deleted.setDeletedTime(DateUtils.getNowDate());
                deleted.setOriginalCreateTime(question.getCreateTime());
                
                // 插入软删除表
                troubleQuestionDeletedMapper.insertTroubleQuestionDeleted(deleted);
                
                // 从原表删除
                troubleQuestionMapper.deleteTroubleQuestionByQuestionId(questionId);
                result++;
            }
        }
        return result;
    }
}
