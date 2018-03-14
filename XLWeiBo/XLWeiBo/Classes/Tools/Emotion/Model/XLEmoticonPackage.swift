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
    var directory: String? 
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        groupName <- map["groupName"]
        directory <- map["directory"]
    }
}
