package com.ruoyi.system.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * 错题回收站表 trouble_question_trash
 * 
 * @author ruoyi
 */
public class TroubleQuestionTrash extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 回收站ID */
    @Excel(name = "回收站ID", cellType = Excel.ColumnType.NUMERIC)
    private Long trashId;

    /** 原错题ID */
    @Excel(name = "原错题ID", cellType = Excel.ColumnType.NUMERIC)
    private Long questionId;

    /** 用户ID */
    @Excel(name = "用户ID", cellType = Excel.ColumnType.NUMERIC)
    private Long userId;

    /** 题目内容 */
    @Excel(name = "题目内容")
    private String questionContent;

    /** 题目图片 */
    @Excel(name = "题目图片")
    private String questionImages;

    /** 答案内容 */
    @Excel(name = "答案内容")
    private String answerContent;

    /** 答案图片 */
    @Excel(name = "答案图片")
    private String answerImages;

    /** 题目类型 */
    @Excel(name = "题目类型")
    private String questionType;

    /** 标签 */
    @Excel(name = "标签")
    private String tags;

    /** 删除原因 */
    @Excel(name = "删除原因")
    private String deleteReason;

    /** 删除者 */
    @Excel(name = "删除者")
    private String deleteBy;

    /** 删除时间 */
    @Excel(name = "删除时间")
    private String deleteTime;

    /** 原创建时间 */
    @Excel(name = "原创建时间")
    private String originalCreateTime;

    /** 原创建者 */
    @Excel(name = "原创建者")
    private String originalCreateBy;

    public Long getTrashId()
    {
        return trashId;
    }

    public void setTrashId(Long trashId)
    {
        this.trashId = trashId;
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

    public String getQuestionContent()
    {
        return questionContent;
    }

    public void setQuestionContent(String questionContent)
    {
        this.questionContent = questionContent;
    }

    public String getQuestionImages()
    {
        return questionImages;
    }

    public void setQuestionImages(String questionImages)
    {
        this.questionImages = questionImages;
    }

    public String getAnswerContent()
    {
        return answerContent;
    }

    public void setAnswerContent(String answerContent)
    {
        this.answerContent = answerContent;
    }

    public String getAnswerImages()
    {
        return answerImages;
    }

    public void setAnswerImages(String answerImages)
    {
        this.answerImages = answerImages;
    }

    public String getQuestionType()
    {
        return questionType;
    }

    public void setQuestionType(String questionType)
    {
        this.questionType = questionType;
    }

    public String getTags()
    {
        return tags;
    }

    public void setTags(String tags)
    {
        this.tags = tags;
    }

    public String getDeleteReason()
    {
        return deleteReason;
    }

    public void setDeleteReason(String deleteReason)
    {
        this.deleteReason = deleteReason;
    }

    public String getDeleteBy()
    {
        return deleteBy;
    }

    public void setDeleteBy(String deleteBy)
    {
        this.deleteBy = deleteBy;
    }

    public String getDeleteTime()
    {
        return deleteTime;
    }

    public void setDeleteTime(String deleteTime)
    {
        this.deleteTime = deleteTime;
    }

    public String getOriginalCreateTime()
    {
        return originalCreateTime;
    }

    public void setOriginalCreateTime(String originalCreateTime)
    {
        this.originalCreateTime = originalCreateTime;
    }

    public String getOriginalCreateBy()
    {
        return originalCreateBy;
    }

    public void setOriginalCreateBy(String originalCreateBy)
    {
        this.originalCreateBy = originalCreateBy;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("trashId", getTrashId())
            .append("questionId", getQuestionId())
            .append("userId", getUserId())
            .append("questionContent", getQuestionContent())
            .append("questionImages", getQuestionImages())
            .append("answerContent", getAnswerContent())
            .append("answerImages", getAnswerImages())
            .append("questionType", getQuestionType())
            .append("tags", getTags())
            .append("deleteReason", getDeleteReason())
            .append("deleteBy", getDeleteBy())
            .append("deleteTime", getDeleteTime())
            .append("originalCreateTime", getOriginalCreateTime())
            .append("originalCreateBy", getOriginalCreateBy())
            .append("remark", getRemark())
            .toString();
    }
}



