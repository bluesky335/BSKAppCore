//
//  Array+random.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2019/7/15.
//  Copyright © 2019 cn.liuwanlin. All rights reserved.
//

import UIKit

extension Array {
    /// 从数组中挑出随机的n个元素成新的数组
    /// - Parameters:
    ///   - count: 返回元素的数量,传入0 则返回空数组,大于数组元素数量或者小于0则返回所有元素并打乱顺序
    ///   - duplicates: 是否允许重复的选取某一个下标的元素，默认是false
    /// - Returns: 随机之后的数组
    public func random(count: Int = 0, duplicates: Bool = false) -> Array {
        if count == 0 {
            return []
        }
        var n = count
        if n > self.count || n < 0 {
            n = self.count
        }

        var array: [Element] = []
        var arrayTemp = self
        for _ in 1 ... n {
            let rand = Int(arc4random_uniform(UInt32(arrayTemp.count)))
            array.append(arrayTemp[rand])
            if !duplicates {
                arrayTemp.remove(at: rand)
            }
        }
        return array
    }
}
