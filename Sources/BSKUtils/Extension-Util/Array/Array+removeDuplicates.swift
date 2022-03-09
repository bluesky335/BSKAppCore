//
//  File.swift
//  
//
//  Created by 刘万林 on 2022/3/10.
//

import Foundation

public extension Array where Element: Hashable {
    
    /// 去除数组中重复的元素，如果有重复的，将优先保留前面的一个。
    /// - Returns: 去重后的新数组
    func removeDuplicates() -> [Element] {
        var newAray: [Element] = []
        var set = Set<Element>()
        for item in self {
            if !set.contains(item) {
                newAray.append(item)
                set.insert(item)
            }
        }
        return newAray
    }
}

public extension Array {
    
    /// 去除数组中重复的元素，如果有重复的，将优先保留前面的一个。
    /// - Parameter keypath: 用于做对比的属性
    /// - Returns: 去重后的新数组
    func removeDuplicates<Value>(by keypath: KeyPath<Element, Value>) -> [Element] where Value: Hashable {
        var newAray: [Element] = []
        var set = Set<Value>()
        for item in self {
            let value = item[keyPath: keypath]
            if !set.contains(value) {
                newAray.append(item)
                set.insert(value)
            }
        }
        return newAray
    }
}
