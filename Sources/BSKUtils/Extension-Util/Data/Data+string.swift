//
//  Data+string.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2019/8/29.
//  Copyright © 2019 cn.liuwanlin. All rights reserved.
//

import UIKit

public extension BSKExtension where Base == Data{
    
    /// 转十进制字符串
    var hexString:String{
        let bytes = [UInt8](self.base)
        var str = ""
        for byte in bytes {
            let v = String(format:"%02x",byte)
            str+=v
        }
        return str
    }
}

public extension Data {
    /// 编码成适用于URL的base64编码字符串（去掉末尾的=，替换+为-，替换/为_）
    /// - Returns: base64字符串
    func base64URLEncodedString() -> String{
        var str = base64EncodedString()
        if let index = str.firstIndex(of: "=") {
            str = String(str[..<index])
        }
        str = str.replacingOccurrences(of: "+", with: "-")
        str = str.replacingOccurrences(of: "/", with: "_")
        return str
    }
    
    /// 从适用于URL的base64字符串解码数据
    /// - Parameters:
    ///   - base64URLEncoded: base64字符串
    ///   - options: 选项
    init?(base64URLEncoded: String, options: Base64DecodingOptions = []) {
        var str = base64URLEncoded.replacingOccurrences(of: "-", with: "+")
        str = base64URLEncoded.replacingOccurrences(of: "_", with: "/")
        let count = str.count % 4
        if count > 0 {
            var ending = ""
            let amount = 4 - count
            ending = String(repeating: "=", count: amount)
            str += ending
        }
        self.init(base64Encoded: str, options: options)
        
    }
}
