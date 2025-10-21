package com.ruoyi.system.service.impl;

import java.io.File;
import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.TroubleQuestion;
import com.ruoyi.system.domain.TroubleQuestionTrash;
import com.ruoyi.system.mapper.TroubleQuestionMapper;
import com.ruoyi.system.mapper.TroubleQuestionTrashMapper;
import com.ruoyi.system.service.ITroubleQuestionTrashService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 错题回收站Service业务层处理
 * 
 * @author ruoyi
 */
@Service
public class TroubleQuestionTrashServiceImpl implements ITroubleQuestionTrashService 
{
    @Autowired
    private TroubleQuestionTrashMapper troubleQuestionTrashMapper;

    @Autowired
    private TroubleQuestionMapper troubleQuestionMapper;

    @Value("${ruoyi.profile}")
    private String uploadPath;

    /**
     * 查询错题回收站
     * 
     * @param trashId 回收站主键
     * @return 错题回收站
     */
    @Override
    public TroubleQuestionTrash selectTroubleQuestionTrashByTrashId(Long trashId)
    {
        return troubleQuestionTrashMapper.selectTroubleQuestionTrashByTrashId(trashId);
    }

    /**
     * 查询错题回收站列表
     * 
     * @param troubleQuestionTrash 错题回收站
     * @return 错题回收站
     */
    @Override
    public List<TroubleQuestionTrash> selectTroubleQuestionTrashList(TroubleQuestionTrash troubleQuestionTrash)
    {
        return troubleQuestionTrashMapper.selectTroubleQuestionTrashList(troubleQuestionTrash);
    }

    /**
     * 新增错题回收站
     * 
     * @param troubleQuestionTrash 错题回收站
     * @return 结果
     */
    @Override
    public int insertTroubleQuestionTrash(TroubleQuestionTrash troubleQuestionTrash)
    {
        troubleQuestionTrash.setDeleteTime(DateUtils.parseDateToStr(DateUtils.YYYY_MM_DD_HH_MM_SS, DateUtils.getNowDate()));
        return troubleQuestionTrashMapper.insertTroubleQuestionTrash(troubleQuestionTrash);
    }

    /**
     * 修改错题回收站
     * 
     * @param troubleQuestionTrash 错题回收站
     * @return 结果
     */
    @Override
    public int updateTroubleQuestionTrash(TroubleQuestionTrash troubleQuestionTrash)
    {
        return troubleQuestionTrashMapper.updateTroubleQuestionTrash(troubleQuestionTrash);
    }

    /**
     * 批量删除错题回收站
     * 
     * @param trashIds 需要删除的回收站主键
     * @return 结果
     */
    @Override
    public int deleteTroubleQuestionTrashByTrashIds(Long[] trashIds)
    {
        return troubleQuestionTrashMapper.deleteTroubleQuestionTrashByTrashIds(trashIds);
    }

    /**
     * 删除错题回收站信息
     * 
     * @param trashId 回收站主键
     * @return 结果
     */
    @Override
    public int deleteTroubleQuestionTrashByTrashId(Long trashId)
    {
        return troubleQuestionTrashMapper.deleteTroubleQuestionTrashByTrashId(trashId);
    }

    /**
     * 根据原错题ID查询回收站记录
     * 
     * @param questionId 原错题ID
     * @return 错题回收站
     */
    @Override
    public TroubleQuestionTrash selectTroubleQuestionTrashByQuestionId(Long questionId)
    {
        return troubleQuestionTrashMapper.selectTroubleQuestionTrashByQuestionId(questionId);
    }

    /**
     * 恢复错题
     * 
     * @param trashId 回收站主键
     * @return 结果
     */
    @Override
    @Transactional
    public int restoreQuestion(Long trashId)
    {
        // 查询回收站记录
        TroubleQuestionTrash trash = troubleQuestionTrashMapper.selectTroubleQuestionTrashByTrashId(trashId);
        if (trash == null) {
            return 0;
        }

        // 创建新的错题记录
        TroubleQuestion question = new TroubleQuestion();
        question.setUserId(trash.getUserId());
        question.setQuestionContent(trash.getQuestionContent());
        question.setQuestionImages(trash.getQuestionImages());
        question.setAnswerContent(trash.getAnswerContent());
        question.setAnswerImages(trash.getAnswerImages());
        question.setQuestionType(trash.getQuestionType());
        question.setTags(trash.getTags());
        question.setStatus("0");
        question.setCreateBy(trash.getOriginalCreateBy());
        question.setCreateTime(DateUtils.parseDate(trash.getOriginalCreateTime()));
        question.setUpdateBy(trash.getDeleteBy());
        question.setUpdateTime(DateUtils.getNowDate());
        question.setRemark("从回收站恢复");

        // 插入新记录
        int result = troubleQuestionMapper.insertTroubleQuestion(question);
        
        // 删除回收站记录
        if (result > 0) {
            troubleQuestionTrashMapper.deleteTroubleQuestionTrashByTrashId(trashId);
        }

        return result;
    }

    /**
     * 彻底删除错题（包括图片）
     * 
     * @param trashIds 回收站主键集合
     * @return 结果
     */
    @Override
    @Transactional
    public int permanentlyDeleteQuestions(Long[] trashIds)
    {
        int result = 0;
        for (Long trashId : trashIds) {
            // 查询回收站记录
            TroubleQuestionTrash trash = troubleQuestionTrashMapper.selectTroubleQuestionTrashByTrashId(trashId);
            if (trash != null) {
                // 删除图片文件
                deleteImageFiles(trash.getQuestionImages());
                deleteImageFiles(trash.getAnswerImages());
                
                // 删除回收站记录
                result += troubleQuestionTrashMapper.deleteTroubleQuestionTrashByTrashId(trashId);
            }
        }
        return result;
    }

    /**
     * 删除图片文件
     * 
     * @param imageUrls 图片URL字符串，多个用逗号分隔
     */
    private void deleteImageFiles(String imageUrls)
    {
        if (StringUtils.isEmpty(imageUrls)) {
            return;
        }

        String[] urls = imageUrls.split(",");
        for (String url : urls) {
            if (StringUtils.isNotEmpty(url)) {
                try {
                    // 从URL中提取完整路径
                    String filePath = extractFilePathFromUrl(url);
                    
                    if (StringUtils.isNotEmpty(filePath)) {
                        File file = new File(filePath);
                        if (file.exists() && file.isFile()) {
                            boolean deleted = file.delete();
                            if (deleted) {
                                System.out.println("成功删除图片文件: " + filePath);
                            } else {
                                System.err.println("删除图片文件失败: " + filePath);
                            }
                        } else {
                            System.out.println("图片文件不存在: " + filePath);
                        }
                    }
                } catch (Exception e) {
                    // 记录日志但不抛出异常
                    System.err.println("删除图片文件失败: " + url + ", 错误: " + e.getMessage());
                }
            }
        }
    }

    /**
     * 从URL中提取文件路径
     * 
     * @param url 图片URL
     * @return 文件路径
     */
    private String extractFilePathFromUrl(String url)
    {
        try {
            // 如果URL包含uploadPath，直接提取路径部分
            if (url.contains("/upload/")) {
                String pathPart = url.substring(url.indexOf("/upload/"));
                return uploadPath + pathPart;
            }
            
            // 如果是相对路径，直接拼接
            if (url.startsWith("/upload/")) {
                return uploadPath + url;
            }
            
            // 如果是完整URL，提取文件名并构建路径
            String fileName = url.substring(url.lastIndexOf("/") + 1);
            return uploadPath + "/upload/" + fileName;
            
        } catch (Exception e) {
            System.err.println("解析图片路径失败: " + url + ", 错误: " + e.getMessage());
            return null;
        }
    }
}

