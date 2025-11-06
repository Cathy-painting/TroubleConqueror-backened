package com.ruoyi.system.domain;

import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * 错题收藏关联表 trouble_question_favorite
 * 
 * @author ruoyi
 */
public class TroubleQuestionFavorite extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 收藏ID */
    private Long favoriteId;

    /** 错题ID */
    private Long questionId;

    /** 用户ID */
    private Long userId;

    public Long getFavoriteId()
    {
        return favoriteId;
    }

    public void setFavoriteId(Long favoriteId)
    {
        this.favoriteId = favoriteId;
    }

    public Long getQuestionId()
    {
        return questionId;
    }

    public void setQuestionId(Long questionId)
    {
        this.questionId = questionId;
    }

    public Long getUserId()
    {
        return userId;
    }

    public void setUserId(Long userId)
    {
        this.userId = userId;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("favoriteId", getFavoriteId())
            .append("questionId", getQuestionId())
            .append("userId", getUserId())
            .append("createTime", getCreateTime())
            .toString();
    }
}

