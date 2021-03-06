//
//  XLEmoticonPackage.swift
//  正则表达式
//
//  Created by waterfoxjie on 2018/3/12.
//  Copyright © 2018年 waterfoxjie. All rights reserved.
//

import UIKit
import ObjectMapper

class XLEmoticonPackage: Mappable {
    // 表情包名称
    var groupName: String?
    // 表情包目录，从目录下加载 info.plist 可以创建表情数组
    var directory: String? {
        // 设置目录时，从目录中加载 info.plist
        didSet {
            guard let directory = directory,
                let bundle = Bundle.main.emotionsBundle(),
                // 拿到对应的 info.plist 文件目录
                let plistPath = bundle.path(forResource: "info.plist", ofType: nil, inDirectory: directory),
                let array = NSArray(contentsOfFile: plistPath) as? [[String: String]],
                let modelArray = Mapper<XLEmoticonModel>().mapArray(JSONObject: array)
            else {
                return
            }
            // 设置目录
            for model in modelArray {
                model.directory = directory
            }
            emoticons += modelArray
        }
    }
    // 懒加载表情模型的空数组（使用懒加载可以避免后续解包）
    lazy var emoticons = [XLEmoticonModel]()
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        groupName <- map["groupName"]
        directory <- map["directory"]
    }
}
