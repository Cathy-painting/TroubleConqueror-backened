package com.ruoyi.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * 错题软删除表 trouble_question_deleted
 * 
 * @author ruoyi
 */
public class TroubleQuestionDeleted extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 软删除ID */
    @Excel(name = "软删除ID", cellType = Excel.ColumnType.NUMERIC)
    private Long id;

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

    /** 删除者 */
    @Excel(name = "删除者")
    private String deletedBy;

    /** 删除时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "删除时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date deletedTime;

    /** 原创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "原创建时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date originalCreateTime;

    public Long getId()
    {
        return id;
    }

    public void setId(Long id)
    {
        this.id = id;
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

    public String getDeletedBy()
    {
        return deletedBy;
    }

    public void setDeletedBy(String deletedBy)
    {
        this.deletedBy = deletedBy;
    }

    public Date getDeletedTime()
    {
        return deletedTime;
    }

    public void setDeletedTime(Date deletedTime)
    {
        this.deletedTime = deletedTime;
    }

    public Date getOriginalCreateTime()
    {
        return originalCreateTime;
    }

    public void setOriginalCreateTime(Date originalCreateTime)
    {
        this.originalCreateTime = originalCreateTime;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("questionId", getQuestionId())
            .append("userId", getUserId())
            .append("questionContent", getQuestionContent())
            .append("questionImages", getQuestionImages())
            .append("answerContent", getAnswerContent())
            .append("answerImages", getAnswerImages())
            .append("questionType", getQuestionType())
            .append("tags", getTags())
            .append("deletedBy", getDeletedBy())
            .append("deletedTime", getDeletedTime())
            .append("originalCreateTime", getOriginalCreateTime())
            .toString();
    }
}
