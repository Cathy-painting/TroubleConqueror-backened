package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.TroubleQuestionDeleted;

/**
 * 错题软删除Service接口
 * 
 * @author ruoyi
 */
public interface ITroubleQuestionDeletedService 
{
    /**
     * 查询软删除错题
     * 
     * @param id 软删除主键
     * @return 软删除错题
     */
    public TroubleQuestionDeleted selectTroubleQuestionDeletedById(Long id);

    /**
     * 查询软删除错题列表
     * 
     * @param troubleQuestionDeleted 软删除错题
     * @return 软删除错题集合
     */
    public List<TroubleQuestionDeleted> selectTroubleQuestionDeletedList(TroubleQuestionDeleted troubleQuestionDeleted);

    /**
     * 新增软删除错题
     * 
     * @param troubleQuestionDeleted 软删除错题
     * @return 结果
     */
    public int insertTroubleQuestionDeleted(TroubleQuestionDeleted troubleQuestionDeleted);

    /**
     * 修改软删除错题
     * 
     * @param troubleQuestionDeleted 软删除错题
     * @return 结果
     */
    public int updateTroubleQuestionDeleted(TroubleQuestionDeleted troubleQuestionDeleted);

    /**
     * 批量删除软删除错题
     * 
     * @param ids 需要删除的软删除错题主键集合
     * @return 结果
     */
    public int deleteTroubleQuestionDeletedByIds(Long[] ids);

    /**
     * 删除软删除错题信息
     * 
     * @param id 软删除错题主键
     * @return 结果
     */
    public int deleteTroubleQuestionDeletedById(Long id);

    /**
     * 恢复错题
     * 
     * @param ids 需要恢复的软删除错题主键集合
     * @return 结果
     */
    public int restoreQuestions(Long[] ids);

    /**
     * 清理过期数据
     * 
     * @return 结果
     */
    public int cleanExpiredQuestions();
}
