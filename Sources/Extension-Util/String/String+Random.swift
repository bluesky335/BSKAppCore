//
// Created by BlueSky335 on 2018/5/11.
// Copyright (c) 2018 LiuWanLin. All rights reserved.
//

import Foundation

public extension BSKExtension where Base == String {
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
