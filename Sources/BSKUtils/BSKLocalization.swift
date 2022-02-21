//
//  String+Localization.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2019/6/27.
//  Copyright © 2019 cn.liuwanlin. All rights reserved.
//

import UIKit

/// 用于快捷访问国际化字符串文件
open class BSKLocalization {
    var bundle: Bundle
    /// strings 文件的名字
    var table: String?

    /// 初始化
    /// - Parameters:
    ///   - bundle: bundle
    ///   - table: strings 文件的名字
    public init(bundle: Bundle = .main, table: String? = nil) {
        self.bundle = bundle
        self.table = table
    }

    /// 给定key获取对应的国际化字符串
    /// - Parameters:
    ///   - key: key
    ///   - value: 如果没有key则返回默认值，如果没有给定默认值，则返回 key
    /// - Returns: 字符串
    open func localStr(key: String, default value: String? = nil) -> String {
        return bundle.localizedString(forKey: key, value: value ?? key, table: table)
    }
}
