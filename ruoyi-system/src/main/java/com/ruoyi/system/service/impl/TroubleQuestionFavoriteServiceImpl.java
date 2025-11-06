package com.ruoyi.system.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.TroubleQuestionFavoriteMapper;
import com.ruoyi.system.domain.TroubleQuestionFavorite;
import com.ruoyi.system.service.ITroubleQuestionFavoriteService;

/**
 * 错题收藏Service业务层处理
 * 
 * @author ruoyi
 */
@Service
public class TroubleQuestionFavoriteServiceImpl implements ITroubleQuestionFavoriteService 
{
    @Autowired
    private TroubleQuestionFavoriteMapper troubleQuestionFavoriteMapper;

    /**
     * 查询收藏记录
     * 
     * @param favoriteId 收藏ID
     * @return 收藏记录
     */
    @Override
    public TroubleQuestionFavorite selectTroubleQuestionFavoriteByFavoriteId(Long favoriteId)
    {
        return troubleQuestionFavoriteMapper.selectTroubleQuestionFavoriteByFavoriteId(favoriteId);
    }

    /**
     * 查询用户是否收藏了某个错题
     * 
     * @param questionId 错题ID
     * @param userId 用户ID
     * @return 收藏记录
     */
    @Override
    public TroubleQuestionFavorite selectFavoriteByQuestionIdAndUserId(Long questionId, Long userId)
    {
        return troubleQuestionFavoriteMapper.selectFavoriteByQuestionIdAndUserId(questionId, userId);
    }

    /**
     * 检查用户是否收藏了某个错题
     * 
     * @param questionId 错题ID
     * @param userId 用户ID
     * @return true已收藏 false未收藏
     */
    @Override
    public boolean isFavorited(Long questionId, Long userId)
    {
        TroubleQuestionFavorite favorite = troubleQuestionFavoriteMapper.selectFavoriteByQuestionIdAndUserId(questionId, userId);
        return favorite != null;
    }

    /**
     * 查询收藏记录列表
     * 
     * @param troubleQuestionFavorite 收藏记录
     * @return 收藏记录
     */
    @Override
    public List<TroubleQuestionFavorite> selectTroubleQuestionFavoriteList(TroubleQuestionFavorite troubleQuestionFavorite)
    {
        return troubleQuestionFavoriteMapper.selectTroubleQuestionFavoriteList(troubleQuestionFavorite);
    }

    /**
     * 新增收藏
     * 
     * @param troubleQuestionFavorite 收藏记录
     * @return 结果
     */
    @Override
    public int insertTroubleQuestionFavorite(TroubleQuestionFavorite troubleQuestionFavorite)
    {
        troubleQuestionFavorite.setCreateTime(DateUtils.getNowDate());
        return troubleQuestionFavoriteMapper.insertTroubleQuestionFavorite(troubleQuestionFavorite);
    }

    /**
     * 收藏错题（如果已收藏则返回失败）
     * 
     * @param questionId 错题ID
     * @param userId 用户ID
     * @return 结果
     */
    @Override
    public int favoriteQuestion(Long questionId, Long userId)
    {
        // 检查是否已收藏
        TroubleQuestionFavorite existingFavorite = troubleQuestionFavoriteMapper.selectFavoriteByQuestionIdAndUserId(questionId, userId);
        if (existingFavorite != null)
        {
            // 已收藏，返回0表示失败
            return 0;
        }
        
        // 创建新的收藏记录
        TroubleQuestionFavorite favorite = new TroubleQuestionFavorite();
        favorite.setQuestionId(questionId);
        favorite.setUserId(userId);
        favorite.setCreateTime(DateUtils.getNowDate());
        
        return troubleQuestionFavoriteMapper.insertTroubleQuestionFavorite(favorite);
    }

    /**
     * 取消收藏错题
     * 
     * @param questionId 错题ID
     * @param userId 用户ID
     * @return 结果
     */
    @Override
    public int unfavoriteQuestion(Long questionId, Long userId)
    {
        return troubleQuestionFavoriteMapper.deleteFavoriteByQuestionIdAndUserId(questionId, userId);
    }

    /**
     * 删除收藏
     * 
     * @param favoriteId 收藏ID
     * @return 结果
     */
    @Override
    public int deleteTroubleQuestionFavoriteByFavoriteId(Long favoriteId)
    {
        return troubleQuestionFavoriteMapper.deleteTroubleQuestionFavoriteByFavoriteId(favoriteId);
    }

    /**
     * 批量删除收藏
     * 
     * @param favoriteIds 需要删除的收藏ID
     * @return 结果
     */
    @Override
    public int deleteTroubleQuestionFavoriteByFavoriteIds(Long[] favoriteIds)
    {
        return troubleQuestionFavoriteMapper.deleteTroubleQuestionFavoriteByFavoriteIds(favoriteIds);
    }

    /**
     * 根据错题ID删除所有相关收藏
     * 
     * @param questionId 错题ID
     * @return 结果
     */
    @Override
    public int deleteFavoriteByQuestionId(Long questionId)
    {
        return troubleQuestionFavoriteMapper.deleteFavoriteByQuestionId(questionId);
    }
}

