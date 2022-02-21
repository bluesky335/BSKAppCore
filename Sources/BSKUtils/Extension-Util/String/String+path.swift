//
//  String+path.swift
//  Alamofire
//
//  Created by 刘万林 on 2019/10/22.
//

import UIKit

public extension BSKExtension where Base == String {
    
    /// 添加文件路径，会自动处理重复的分隔符“/”
    /// - Parameter path: 添加的路径
    /// - Returns: 新的路径
    func append(path:String)->String{
        return URL(fileURLWithPath: self.base).appendingPathComponent(path).path
    }
}
