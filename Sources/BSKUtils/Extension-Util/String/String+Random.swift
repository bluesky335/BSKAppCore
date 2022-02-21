//
// Created by BlueSky335 on 2018/5/11.
// Copyright (c) 2018 LiuWanLin. All rights reserved.
//

import Foundation

public extension BSKExtension where Base == String {
    
    /// 随机生成包含字母和数字的字符串(有可能有重复的字符）
    ///
    /// - Parameter length: 字符串长度
    /// - Returns: 生成的字符串
    static func random(length: Int) -> String {
        let letters: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.count)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            let index = letters.index(letters.startIndex, offsetBy: Int(rand))
            let char = letters[index]
            randomString.append(char)
        }
        return randomString
    }

    
    /// 从当前字符串中的字符中随机生成字符串(有可能有重复的字符）
    ///
    /// - Parameter length: 随机字符串长度
    /// - Returns: 生成的字符串
    func random(length: Int) -> String {
        let letters = self.base
        let len = UInt32(letters.count)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            let index = letters.index(letters.startIndex, offsetBy: Int(rand))
            let char = letters[index]
            randomString.append(char)
        }
        return randomString
    }
}
