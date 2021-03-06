//
//  XLHomeViewModel.swift
//  XLWeiBo
//
//  Created by waterfoxjie on 2018/2/1.
//  Copyright © 2018年 waterfoxjie. All rights reserved.
//

import UIKit

/// 单条微博视图模型
class XLHomeViewModel {
    // 单条微博数据模型
    var homeModel: XLHomeInfoModel
    // 微博来源
    var sourceString: String?
    // 会员图标
    var gradeImage: UIImage?
    // V 图标
    var verifiedImage: UIImage?
    // 配图视图高度
    var picViewsSize: CGSize = CGSize()
    // 配图视图内容
    var picUrlArray: [XLHomePictureModel]? {
        // 转发的微博正文一定没有图片，所以先看看转发微博中是否有图片，有则返回，没有就返回正文中的配图，都没有则返回 nil
        return homeModel.retweetedStatus?.pictureArray ?? homeModel.pictureArray
    }
    // 微博属性文本
    var wbAttrText: NSAttributedString?
    // 被转发微博属性文本
    var repostsAttrText: NSAttributedString?
    // 底部“转发”文字
    var repostsString: String?
    // 底部“评论”文字
    var commentString: String?
    // 底部“点赞”文字
    var likedString: String?
    // 计算行高
    var cellRowHeight: CGFloat = 0
    
    init(model: XLHomeInfoModel) {
        self.homeModel = model
        
        if let rankNum = model.userModel?.mbRank {
            var gradeImageName = "common_icon_membership_expired"
            if rankNum != 0 {
                gradeImageName = "common_icon_membership_level\(rankNum)"
            }
            gradeImage = UIImage(named: gradeImageName)
        }
        
        // 设置时间、来源
        if let text = model.wbSource?.obtainSource()?.text {
            sourceString = "来自" + text
        }
        
        // -1：没有认证，0：认证用户，2，3，5：企业认证，220：达人
        switch model.userModel?.verifiedType ?? -1 {
        case 0:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2,3,5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            break
        }
        
        // 设置配图视图高度
        let picViewsHeight = calcPicViewsHeight(picCount: model.retweetedStatus?.pictureArray?.count ?? model.pictureArray?.count)
        picViewsSize = CGSize(width: HomeCellLabOrPicWidth, height: picViewsHeight)
        
        // 设置被转发微博文字
        let repostsText = "@\(String(describing: model.retweetedStatus?.userModel?.userNickName ?? "")) : "
            + "\(String(describing: model.retweetedStatus?.wbText ?? ""))"
        // 设置属性文本
        wbAttrText = XLEmoticonManager.shared.emotionString(string: model.wbText ?? "", textFont: wbTextFont)
        repostsAttrText = XLEmoticonManager.shared.emotionString(string: repostsText, textFont: repostsTextFont)
        
        // 底部按钮文字
        repostsString = countString(count: model.repostsCount, defaultString: "转发")
        commentString = countString(count: model.commentsCount, defaultString: "评论")
        likedString = countString(count: model.likedCount, defaultString: "赞")
    
        // 计算行高
        updateRowHeight()
    }
    
    
    /// 修改单张配图视图大小
    ///
    /// - Parameter image: 图片
    func updateSingleImageSize(image: UIImage) {
        var imageSize = CGSize(width: image.size.width * ScreenScale, height: image.size.height * ScreenScale)
        // 处理图片过宽情况（进行等比例缩放）
        if imageSize.width > HomeCellLabOrPicWidth {
            imageSize.width = HomeCellLabOrPicWidth
            imageSize.height = image.size.height * ScreenScale * imageSize.width / image.size.width * ScreenScale
        }
        // 处理图片过长、过窄的情况
        let minWidth: CGFloat = 100
        if imageSize.width < minWidth {
            imageSize.width = minWidth
            // 防止长度过长 / 4
            imageSize.height = image.size.height * ScreenScale * imageSize.width / image.size.width * ScreenScale / 4
        }
        imageSize.height += HomeCellOutterMargin
        picViewsSize = imageSize
        // 更新行高
        updateRowHeight()
    }
    
    
    /// 根据当前视图模型内容计算高度
    func updateRowHeight() {
        // 普通 ：顶部分隔View(12) + 间距(12) + 头像(40) + 间距(12) + 正文(需要计算，字号：15) + 配图视图(需要计算) + 间距(12) + 底部View(35)
        // 转发增加：间距(12) + 转发微博文字(需要计算，字号：14)
        var viewHeight = HomeCellTopViewHeight
        viewHeight += (HomeCellOutterMargin + HomeCellIconSize)
        
        let viewSize = CGSize(width: HomeCellLabOrPicWidth, height: CGFloat(MAXFLOAT))
        /*
          参数1：预尺寸（宽度为控件宽度，高度尽量设置大）
          参数2：类型（.usesLineFragmentOrigin 为多行固定）
        */
        if let weiBoAttrText = wbAttrText {
            let height = weiBoAttrText.boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], context: nil).height
            viewHeight += (height + HomeCellOutterMargin)
        }
        // 转发微博情况下，计算转发微博文高度
        if homeModel.retweetedStatus != nil {
            if let repostsAttrText = repostsAttrText {
                let repostsHeight = repostsAttrText.boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], context: nil).height
                viewHeight += repostsHeight
                viewHeight += 2 * HomeCellOutterMargin
            }
        }
        // 添加配图视图
        viewHeight += picViewsSize.height
        // 添加底部
        viewHeight += (HomeCellOutterMargin + HomeCellBottomViewHeight)
        cellRowHeight = viewHeight
    }
    
    /// 给定一个数字，返回对应的描述结果
    ///
    /// - Parameters:
    ///   - count:         count  数字
    ///   - defaultString: defaultString  默认字符串，转发 / 评论 / 赞
    /// - Returns: 返回描述结果
    private func countString(count: Int, defaultString: String) -> String {
        if count == 0 {
            return defaultString
        }
        if count < 10000 {
            return count.description
        }
        return String(format: "%.2f 万", Double(count) / 10000)
    }
    
    
    /// 返回配图视图高度
    ///
    /// - Parameter picCount: 图片数
    /// - Returns:  返回对应的高度
    private func calcPicViewsHeight(picCount: Int?) -> CGFloat {
        if picCount == 0 || picCount == nil {
            return 0
        }
        // 根据 picCount 知道有多少行
        let row = (picCount! - 1) / HomeCellPicRow + 1
        var picHeight = HomeCellOutterMargin
        picHeight = picHeight + HomeCellPicInnerMargin * CGFloat(row - 1)
        picHeight = picHeight + HomeCellPicItemSize * CGFloat(row)
        return picHeight
    }
    
}
