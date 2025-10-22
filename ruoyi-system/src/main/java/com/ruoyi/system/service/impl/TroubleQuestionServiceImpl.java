package com.ruoyi.system.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.TroubleQuestion;
import com.ruoyi.system.domain.TroubleQuestionTrash;
import com.ruoyi.system.mapper.TroubleQuestionMapper;
import com.ruoyi.system.mapper.TroubleQuestionTrashMapper;
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
    private TroubleQuestionTrashMapper troubleQuestionTrashMapper;

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
        troubleQuestion.setCreateBy(SecurityUtils.getUsername());
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
        troubleQuestion.setUpdateBy(SecurityUtils.getUsername());
        troubleQuestion.setUpdateTime(DateUtils.getNowDate());
        return troubleQuestionMapper.updateTroubleQuestion(troubleQuestion);
    }

    /**
     * 批量删除错题（软删除）
     * 
     * @param questionIds 需要删除的错题主键
     * @return 结果
     */
    @Override
    @Transactional
    public int deleteTroubleQuestionByQuestionIds(Long[] questionIds)
    {
        int result = 0;
        for (Long questionId : questionIds) {
            result += softDeleteQuestion(questionId);
        }
        return result;
    }

    /**
     * 删除错题信息（软删除）
     * 
     * @param questionId 错题主键
     * @return 结果
     */
    @Override
    @Transactional
    public int deleteTroubleQuestionByQuestionId(Long questionId)
    {
        return softDeleteQuestion(questionId);
    }

    /**
     * 软删除错题
     * 
     * @param questionId 错题主键
     * @return 结果
     */
    private int softDeleteQuestion(Long questionId)
    {
        // 查询原错题记录
        TroubleQuestion question = troubleQuestionMapper.selectTroubleQuestionByQuestionId(questionId);
        if (question == null) {
            return 0;
        }

        // 创建回收站记录
        TroubleQuestionTrash trash = new TroubleQuestionTrash();
        trash.setQuestionId(question.getQuestionId());
        trash.setUserId(question.getUserId());
        trash.setQuestionContent(question.getQuestionContent());
        trash.setQuestionImages(question.getQuestionImages());
        trash.setAnswerContent(question.getAnswerContent());
        trash.setAnswerImages(question.getAnswerImages());
        trash.setQuestionType(question.getQuestionType());
        trash.setTags(question.getTags());
        trash.setDeleteReason("用户删除");
        trash.setDeleteBy(SecurityUtils.getUsername());
        trash.setDeleteTime(DateUtils.parseDateToStr(DateUtils.YYYY_MM_DD_HH_MM_SS, DateUtils.getNowDate()));
        trash.setOriginalCreateTime(DateUtils.parseDateToStr(DateUtils.YYYY_MM_DD_HH_MM_SS, question.getCreateTime()));
        trash.setOriginalCreateBy(question.getCreateBy());
        trash.setRemark("软删除记录");

        // 插入回收站
        int result = troubleQuestionTrashMapper.insertTroubleQuestionTrash(trash);
        
        // 删除原记录
        if (result > 0) {
            troubleQuestionMapper.deleteTroubleQuestionByQuestionId(questionId);
        }

        return result;
    }

    /**
     * 基于OCR识别结果创建错题
     * 
     * @param ocrText OCR识别的文本
     * @param imagePath 图片路径
     * @param userId 用户ID
     * @param questionType 题目类型
     * @param tags 标签
     * @return 错题对象
     */
    @Override
    public TroubleQuestion createQuestionFromOcr(String ocrText, String imagePath, Long userId, String questionType, String tags)
    {
        TroubleQuestion question = new TroubleQuestion();
        question.setUserId(userId);
        question.setQuestionContent(ocrText);
        question.setQuestionImages(imagePath);
        question.setQuestionType(questionType != null ? questionType : "OCR识别");
        question.setTags(tags != null ? tags : "OCR");
        question.setStatus("0");
        question.setCreateBy(SecurityUtils.getUsername());
        question.setCreateTime(DateUtils.getNowDate());
        
        // 插入数据库
        int result = troubleQuestionMapper.insertTroubleQuestion(question);
        
        return result > 0 ? question : null;
    }
}
