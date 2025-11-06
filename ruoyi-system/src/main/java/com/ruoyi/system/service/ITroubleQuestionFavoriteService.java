package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.TroubleQuestionFavorite;

/**
 * 错题收藏Service接口
 * 
 * @author ruoyi
 */
public interface ITroubleQuestionFavoriteService 
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
    public TroubleQuestionFavorite selectFavoriteByQuestionIdAndUserId(Long questionId, Long userId);

    /**
     * 检查用户是否收藏了某个错题
     * 
     * @param questionId 错题ID
     * @param userId 用户ID
     * @return true已收藏 false未收藏
     */
    public boolean isFavorited(Long questionId, Long userId);

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
     * 收藏错题（如果已收藏则返回失败）
     * 
     * @param questionId 错题ID
     * @param userId 用户ID
     * @return 结果
     */
    public int favoriteQuestion(Long questionId, Long userId);

    /**
     * 取消收藏错题
     * 
     * @param questionId 错题ID
     * @param userId 用户ID
     * @return 结果
     */
    public int unfavoriteQuestion(Long questionId, Long userId);

    /**
     * 删除收藏
     * 
     * @param favoriteId 收藏ID
     * @return 结果
     */
    public int deleteTroubleQuestionFavoriteByFavoriteId(Long favoriteId);

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

