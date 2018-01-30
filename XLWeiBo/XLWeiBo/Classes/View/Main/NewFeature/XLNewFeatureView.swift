//
//  XLNewFeatureView.swift
//  XLWeiBo
//
//  Created by waterfoxjie on 2018/1/30.
//  Copyright © 2018年 waterfoxjie. All rights reserved.
//

import UIKit
import SnapKit

private let pageNumbers = 4

/// 新特性界面
class XLNewFeatureView: UIView {
    
    lazy var scrollView: UIScrollView = UIScrollView()
    lazy var enterButton: UIButton = UIButton()
    lazy var pageControl: UIPageControl = UIPageControl()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = UIScreen.main.bounds
        setupUI()
        addImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension XLNewFeatureView {
    // 设置初始界面
    private func setupUI() {
        addSubview(scrollView)
        addSubview(enterButton)
        addSubview(pageControl)
        
        // 设置布局
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        enterButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(100)
            make.size.equalTo(CGSize(width: 105, height: 36))
        }
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(-80)
        }
        
        scrollView.backgroundColor = UIColor.clear
        // 弹簧效果
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        enterButton.setTitle("进入微博", for: .normal)
        enterButton.setTitleColor(UIColor.white, for: .normal)
        enterButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        enterButton.setBackgroundImage(UIImage(named: "new_feature_finish_button"), for: .normal)
        enterButton.setBackgroundImage(UIImage(named: "new_feature_finish_button_highlighted"), for: .highlighted)
        enterButton.addTarget(self, action: #selector(clickEnterButton), for: .touchUpInside)
        
        // 当前页码
        pageControl.currentPage = 0
        // 页码总数
        pageControl.numberOfPages = pageNumbers
        // 选中颜色
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        // 未选颜色
        pageControl.pageIndicatorTintColor = UIColor.orange
    }

    // 添加图片视图
    private func addImageView() {
        let rect = UIScreen.main.bounds
        for i in 0..<pageNumbers {
            let imageName = "new_feature_\(i + 1)"
            let imageRect = CGRect(origin: CGPoint(x: CGFloat(i) * rect.width, y: 0), size: rect.size)
            let imageView = UIImageView(frame: imageRect)
            // 设置位置
            imageView.frame.offsetBy(dx: CGFloat(i) * rect.width, dy: 0)
            imageView.image = UIImage(named: imageName)
            scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSize(width: rect.width * CGFloat(pageNumbers), height: rect.height)
    }
}

// MARK: - 按钮点击方法
extension XLNewFeatureView {
    @objc private func clickEnterButton() {
        print("点击点击")
    }
}
