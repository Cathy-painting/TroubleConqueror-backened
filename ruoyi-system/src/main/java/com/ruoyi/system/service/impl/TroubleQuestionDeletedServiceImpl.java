package com.ruoyi.system.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.TroubleQuestionDeletedMapper;
import com.ruoyi.system.mapper.TroubleQuestionMapper;
import com.ruoyi.system.domain.TroubleQuestionDeleted;
import com.ruoyi.system.domain.TroubleQuestion;
import com.ruoyi.system.service.ITroubleQuestionDeletedService;

/**
 * 错题软删除Service业务层处理
 * 
 * @author ruoyi
 */
@Service
public class TroubleQuestionDeletedServiceImpl implements ITroubleQuestionDeletedService 
{
    @Autowired
    private TroubleQuestionDeletedMapper troubleQuestionDeletedMapper;

    @Autowired
    private TroubleQuestionMapper troubleQuestionMapper;

    /**
     * 查询软删除错题
     * 
     * @param id 软删除主键
     * @return 软删除错题
     */
    @Override
    public TroubleQuestionDeleted selectTroubleQuestionDeletedById(Long id)
    {
        return troubleQuestionDeletedMapper.selectTroubleQuestionDeletedById(id);
    }

    /**
     * 查询软删除错题列表
     * 
     * @param troubleQuestionDeleted 软删除错题
     * @return 软删除错题
     */
    @Override
    public List<TroubleQuestionDeleted> selectTroubleQuestionDeletedList(TroubleQuestionDeleted troubleQuestionDeleted)
    {
        return troubleQuestionDeletedMapper.selectTroubleQuestionDeletedList(troubleQuestionDeleted);
    }

    /**
     * 新增软删除错题
     * 
     * @param troubleQuestionDeleted 软删除错题
     * @return 结果
     */
    @Override
    public int insertTroubleQuestionDeleted(TroubleQuestionDeleted troubleQuestionDeleted)
    {
        troubleQuestionDeleted.setDeletedTime(DateUtils.getNowDate());
        return troubleQuestionDeletedMapper.insertTroubleQuestionDeleted(troubleQuestionDeleted);
    }

    /**
     * 修改软删除错题
     * 
     * @param troubleQuestionDeleted 软删除错题
     * @return 结果
     */
    @Override
    public int updateTroubleQuestionDeleted(TroubleQuestionDeleted troubleQuestionDeleted)
    {
        return troubleQuestionDeletedMapper.updateTroubleQuestionDeleted(troubleQuestionDeleted);
    }

    /**
     * 批量删除软删除错题
     * 
     * @param ids 需要删除的软删除错题主键
     * @return 结果
     */
    @Override
    public int deleteTroubleQuestionDeletedByIds(Long[] ids)
    {
        return troubleQuestionDeletedMapper.deleteTroubleQuestionDeletedByIds(ids);
    }

    /**
     * 删除软删除错题信息
     * 
     * @param id 软删除错题主键
     * @return 结果
     */
    @Override
    public int deleteTroubleQuestionDeletedById(Long id)
    {
        return troubleQuestionDeletedMapper.deleteTroubleQuestionDeletedById(id);
    }

    /**
     * 恢复错题
     * 
     * @param ids 需要恢复的软删除错题主键
     * @return 结果
     */
    @Override
    public int restoreQuestions(Long[] ids)
    {
        int result = 0;
        for (Long id : ids) {
            // 查询软删除记录
            TroubleQuestionDeleted deleted = troubleQuestionDeletedMapper.selectTroubleQuestionDeletedById(id);
            if (deleted != null) {
                // 创建新的错题记录
                TroubleQuestion question = new TroubleQuestion();
                question.setUserId(deleted.getUserId());
                question.setQuestionContent(deleted.getQuestionContent());
                question.setQuestionImages(deleted.getQuestionImages());
                question.setAnswerContent(deleted.getAnswerContent());
                question.setAnswerImages(deleted.getAnswerImages());
                question.setQuestionType(deleted.getQuestionType());
                question.setTags(deleted.getTags());
                question.setStatus("0");
                question.setCreateBy(SecurityUtils.getUsername());
                question.setCreateTime(DateUtils.getNowDate());
                
                // 插入新记录
                troubleQuestionMapper.insertTroubleQuestion(question);
                
                // 删除软删除记录
                troubleQuestionDeletedMapper.deleteTroubleQuestionDeletedById(id);
                result++;
            }
        }
        return result;
    }

    /**
     * 清理过期数据
     * 
     * @return 结果
     */
    @Override
    public int cleanExpiredQuestions()
    {
        // 查询30天前的软删除记录
        List<TroubleQuestionDeleted> expiredList = troubleQuestionDeletedMapper.selectExpiredDeletedQuestions(30);
        
        int result = 0;
        for (TroubleQuestionDeleted deleted : expiredList) {
            // 这里可以添加删除图片文件的逻辑
            // TODO: 删除对应的图片文件
            
            // 删除软删除记录
            troubleQuestionDeletedMapper.deleteTroubleQuestionDeletedById(deleted.getId());
            result++;
        }
        return result;
    }
}
