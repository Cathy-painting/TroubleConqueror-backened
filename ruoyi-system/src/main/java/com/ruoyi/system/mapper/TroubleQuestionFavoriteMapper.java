package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.TroubleQuestionFavorite;
import org.apache.ibatis.annotations.Param;

/**
 * 错题收藏Mapper接口
 * 
 * @author ruoyi
 */
public interface TroubleQuestionFavoriteMapper 
{
    /**
     * 查询收藏记录
     * 
     * @param favoriteId 收藏ID
     * @return 收藏记录
     */
    public TroubleQuestionFavorite selectTroubleQuestionFavoriteByFavoriteId(Long favoriteId);

    /**
     * 查询用户是否收藏了某个错题
     * 
     * @param questionId 错题ID
     * @param userId 用户ID
     * @return 收藏记录
     */
    public TroubleQuestionFavorite selectFavoriteByQuestionIdAndUserId(@Param("questionId") Long questionId, @Param("userId") Long userId);

    /**
     * 查询收藏记录列表
     * 
     * @param troubleQuestionFavorite 收藏记录
     * @return 收藏记录集合
     */
    public List<TroubleQuestionFavorite> selectTroubleQuestionFavoriteList(TroubleQuestionFavorite troubleQuestionFavorite);

    /**
     * 新增收藏
     * 
     * @param troubleQuestionFavorite 收藏记录
     * @return 结果
     */
    public int insertTroubleQuestionFavorite(TroubleQuestionFavorite troubleQuestionFavorite);

    /**
     * 删除收藏
     * 
     * @param favoriteId 收藏ID
     * @return 结果
     */
    public int deleteTroubleQuestionFavoriteByFavoriteId(Long favoriteId);

    /**
     * 根据错题ID和用户ID删除收藏
     * 
     * @param questionId 错题ID
     * @param userId 用户ID
     * @return 结果
     */
    public int deleteFavoriteByQuestionIdAndUserId(@Param("questionId") Long questionId, @Param("userId") Long userId);

    /**
     * 批量删除收藏
     * 
     * @param favoriteIds 需要删除的收藏ID
     * @return 结果
     */
    public int deleteTroubleQuestionFavoriteByFavoriteIds(Long[] favoriteIds);

    /**
     * 根据错题ID删除所有相关收藏
     * 
     * @param questionId 错题ID
     * @return 结果
     */
    public int deleteFavoriteByQuestionId(Long questionId);
}

