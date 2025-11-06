package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.TroubleQuestion;

/**
 * 错题Mapper接口
 * 
 * @author ruoyi
 */
public interface TroubleQuestionMapper 
{
    /**
     * 查询错题
     * 
     * @param questionId 错题主键
     * @return 错题
     */
    public TroubleQuestion selectTroubleQuestionByQuestionId(Long questionId);

    /**
     * 查询错题列表
     * 
     * @param troubleQuestion 错题
     * @return 错题集合
     */
    public List<TroubleQuestion> selectTroubleQuestionList(TroubleQuestion troubleQuestion);

    /**
     * 查询收藏的错题列表
     * 
     * @param troubleQuestion 错题
     * @return 错题集合
     */
    public List<TroubleQuestion> selectFavoriteQuestionList(TroubleQuestion troubleQuestion);

    /**
     * 新增错题
     * 
     * @param troubleQuestion 错题
     * @return 结果
     */
    public int insertTroubleQuestion(TroubleQuestion troubleQuestion);

    /**
     * 修改错题
     * 
     * @param troubleQuestion 错题
     * @return 结果
     */
    public int updateTroubleQuestion(TroubleQuestion troubleQuestion);

    /**
     * 删除错题
     * 
     * @param questionId 错题主键
     * @return 结果
     */
    public int deleteTroubleQuestionByQuestionId(Long questionId);

    /**
     * 批量删除错题
     * 
     * @param questionIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteTroubleQuestionByQuestionIds(Long[] questionIds);
}



