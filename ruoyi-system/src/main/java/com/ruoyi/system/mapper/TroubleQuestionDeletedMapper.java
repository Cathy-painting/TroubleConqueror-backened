package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.TroubleQuestionDeleted;

/**
 * 错题软删除Mapper接口
 * 
 * @author ruoyi
 */
public interface TroubleQuestionDeletedMapper 
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
     * 删除软删除错题
     * 
     * @param id 软删除主键
     * @return 结果
     */
    public int deleteTroubleQuestionDeletedById(Long id);

    /**
     * 批量删除软删除错题
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteTroubleQuestionDeletedByIds(Long[] ids);

    /**
     * 恢复错题
     * 
     * @param id 软删除主键
     * @return 结果
     */
    public int restoreQuestionById(Long id);

    /**
     * 查询超过指定天数的软删除记录
     * 
     * @param days 天数
     * @return 软删除错题集合
     */
    public List<TroubleQuestionDeleted> selectExpiredDeletedQuestions(int days);
}
