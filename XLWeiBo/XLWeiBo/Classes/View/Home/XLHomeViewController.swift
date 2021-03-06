//
//  XLHomeViewController.swift
//  XLWeiBo
//
//  Created by waterfoxjie on 2018/1/17.
//  Copyright © 2018年 waterfoxjie. All rights reserved.
//

import UIKit

private let homeListNormalCellID = "homeListNormalCellID"
private let homeListRepostsCellID = "homeListRepostsCellID"

class XLHomeViewController: XLBaseViewController {
    
    // 是否是上拉刷新
    private lazy var isPullup = false
    private lazy var listViewModel = XLHomeListViewModel()
    
    override func baseSetup() {
        super.baseSetup()
        setupNavgation()
        
        // 注册 Cell 原型
        tableView?.register(UINib(nibName: "XLHomeListNormalCell", bundle: nil), forCellReuseIdentifier: homeListNormalCellID)
        tableView?.register(UINib(nibName: "XLHomeListRepostsCell", bundle: nil), forCellReuseIdentifier: homeListRepostsCellID)
        
        // 隐藏底部分割线
        tableView?.separatorStyle = .none
    }
    
    // 设置数据
    override func loadData() {
        self.resfreshC?.beginRefreshing()
        listViewModel.loadHomeList(isPullup: isPullup) { (isSuccess, isReloadData) in
            print("加载数据完成")
            self.resfreshC?.endRefreshing()
            self.isPullup = false
            if isReloadData {
                self.tableView?.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 用户登录了再刷新数据
        XLNetworkManager.shareManager.userLogon ? loadData() : ()
    }
}


// MARK: - 基础设置
extension XLHomeViewController {
    private func setupNavgation() {
        addLeftTitleBarButton(title: "好友", target: self, action: #selector(addFriends))
        // 设置中部按钮
        let title = XLNetworkManager.shareManager.userAccout.screenName
        navigationItem.titleView = XLHomeNavTitleButton(title: title)
    }
}

// MARK: - 按钮点击事件
extension XLHomeViewController {
    @objc private func addFriends() {
        print("好友")
    }
    
    @objc private func navTitleButtonClick(btn: UIButton) {
        btn.isSelected = !btn.isSelected
    }
}

// MARK: - UITableViewDelegate, UITableViewdataSource
extension XLHomeViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.homeList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 取出数据模型，根据模型判断可重用 Cell
        let viewModel = listViewModel.homeList[indexPath.row]
        let cellID = (viewModel.homeModel.retweetedStatus == nil) ? homeListNormalCellID : homeListRepostsCellID
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! XLHomeListCell
        cell.viewModel = viewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return listViewModel.homeList[indexPath.row].cellRowHeight
    }
    
    // 将要显示 cell 代理方法
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 判断 indexPath 是否是最后一组的最后一行
        let row = indexPath.row
        let section = tableView.numberOfSections - 1
        // 没有数据的情况
        if row < 0 || section < 0 {
            return
        }
        let count = tableView.numberOfRows(inSection: section)
        if row == (count - 1) && !isPullup {
            // 做上拉刷新
            isPullup = true
            loadData()
        }
    }
}


