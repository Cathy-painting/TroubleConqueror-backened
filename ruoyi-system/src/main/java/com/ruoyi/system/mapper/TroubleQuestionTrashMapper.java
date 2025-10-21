package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.TroubleQuestionTrash;

/**
 * 错题回收站Mapper接口
 * 
 * @author ruoyi
 */
public interface TroubleQuestionTrashMapper 
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
     * 删除错题回收站
     * 
     * @param trashId 回收站主键
     * @return 结果
     */
    public int deleteTroubleQuestionTrashByTrashId(Long trashId);

    /**
     * 批量删除错题回收站
     * 
     * @param trashIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteTroubleQuestionTrashByTrashIds(Long[] trashIds);

    /**
     * 根据原错题ID查询回收站记录
     * 
     * @param questionId 原错题ID
     * @return 错题回收站
     */
    public TroubleQuestionTrash selectTroubleQuestionTrashByQuestionId(Long questionId);
}


