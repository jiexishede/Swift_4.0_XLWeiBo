//
//  XLHomeCellPicturesView.swift
//  XLWeiBo
//
//  Created by waterfoxjie on 2018/2/2.
//  Copyright © 2018年 waterfoxjie. All rights reserved.
//

import UIKit

class XLHomeCellPicturesView: UIView {
    
    // 图片 View 高度约束
    @IBOutlet weak var picturesViewHeight: NSLayoutConstraint!
    
    // 模型数据
    var viewModel: XLHomeViewModel? {
        didSet {
            updateViewSize()
            urlArray = viewModel?.picUrlArray
        }
    }
    
    // 配图视图数组
    private var urlArray: [XLHomePictureModel]? {
        didSet {
            // 设置不可见以及清除数据
            for iv in subviews {
                iv.isHidden = true
            }
            // 设置数值
            guard let urls = urlArray else {
                return
            }
            var number = 0
            for picModel in urls {
                if number > subviews.count {
                    break
                }
                // 只有四张图片时，显示上做处理
                if number == 2 && urls.count == 4 {
                    // 跳过一张图片显示
                    number = number + 1
                }
                let picImageView = subviews[number] as! UIImageView
                picImageView.xl_setImage(urlString: picModel.thumbnailPic, placeholderImage: UIImage(named: "avatar_default_big"))
                number = number + 1
                picImageView.isHidden = false
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
}

// MARK: - 初始化 UI
extension XLHomeCellPicturesView {
    private func setupUI() {
        backgroundColor = superview?.backgroundColor
        // 创建 9 个 UIImageView
        clipsToBounds = true
        for i in 0..<HomeCellPicMaxViewCount {
            let picImageView = UIImageView()
            addSubview(picImageView)
            // 设置位置
            let cloum = i / HomeCellPicRow
            let row = i % HomeCellPicRow
            let topMargin = HomeCellOutterMargin + (HomeCellPicItemSize + HomeCellPicInnerMargin) * CGFloat(cloum)
            let leftMargin = (HomeCellPicInnerMargin + HomeCellPicItemSize) * CGFloat(row)
            picImageView.frame = CGRect(x: leftMargin, y: topMargin, width: HomeCellPicItemSize, height: HomeCellPicItemSize)
            picImageView.contentMode = .scaleAspectFill
            picImageView.clipsToBounds = true
        }
    }
}

// MARK: - 自定义方法实现
extension XLHomeCellPicturesView {
    private func updateViewSize() {
        guard let urlArray = viewModel?.picUrlArray else {
            return
        }
        // 获取到第一个控件视图，并修改其大小
        let picView = subviews.first
        if urlArray.count == 1 {
            let size = viewModel?.picViewsSize ?? CGSize()
            // 单图：根据图像大小，修改第一个视图的大小
            picView?.frame.size = CGSize(width: size.width, height: size.height - HomeCellOutterMargin)
        } else {
            // 多图：恢复原来的大小
            picView?.frame.size = CGSize(width: HomeCellPicItemSize, height: HomeCellPicItemSize)
        }
        picturesViewHeight.constant = viewModel?.picViewsSize.height ?? 0
    }
}
