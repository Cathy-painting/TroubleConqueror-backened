package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.TroubleQuestionTrash;

/**
 * 错题回收站Service接口
 * 
 * @author ruoyi
 */
public interface ITroubleQuestionTrashService 
{
    /**
     * 查询错题回收站
     * 
     * @param trashId 回收站主键
     * @return 错题回收站
     */
    public TroubleQuestionTrash selectTroubleQuestionTrashByTrashId(Long trashId);

    /**
     * 查询错题回收站列表
     * 
     * @param troubleQuestionTrash 错题回收站
     * @return 错题回收站集合
     */
    public List<TroubleQuestionTrash> selectTroubleQuestionTrashList(TroubleQuestionTrash troubleQuestionTrash);

    /**
     * 新增错题回收站
     * 
     * @param troubleQuestionTrash 错题回收站
     * @return 结果
     */
    public int insertTroubleQuestionTrash(TroubleQuestionTrash troubleQuestionTrash);

    /**
     * 修改错题回收站
     * 
     * @param troubleQuestionTrash 错题回收站
     * @return 结果
     */
    public int updateTroubleQuestionTrash(TroubleQuestionTrash troubleQuestionTrash);

    /**
     * 批量删除错题回收站
     * 
     * @param trashIds 需要删除的回收站主键集合
     * @return 结果
     */
    public int deleteTroubleQuestionTrashByTrashIds(Long[] trashIds);

    /**
     * 删除错题回收站信息
     * 
     * @param trashId 回收站主键
     * @return 结果
     */
    public int deleteTroubleQuestionTrashByTrashId(Long trashId);

    /**
     * 根据原错题ID查询回收站记录
     * 
     * @param questionId 原错题ID
     * @return 错题回收站
     */
    public TroubleQuestionTrash selectTroubleQuestionTrashByQuestionId(Long questionId);

    /**
     * 恢复错题
     * 
     * @param trashId 回收站主键
     * @return 结果
     */
    public int restoreQuestion(Long trashId);

    /**
     * 彻底删除错题（包括图片）
     * 
     * @param trashIds 回收站主键集合
     * @return 结果
     */
    public int permanentlyDeleteQuestions(Long[] trashIds);
}


