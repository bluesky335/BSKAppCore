//
//  String+SubStringRange.swift
//  BSKAppCore
//
//  Created by BlueSky335 on 2018/10/18.
//  Copyright © 2018 ChaungMiKeJi. All rights reserved.
//

import Foundation

public extension BSKExtension where Base == String {
    subscript(range: ClosedRange<Int>) -> String {
        let startIndex = self.base.index(self.base.startIndex, offsetBy: range.lowerBound)
        let endIndex   = self.base.index(self.base.startIndex, offsetBy: range.upperBound)
        return String(self.base[startIndex...endIndex])
    }

    subscript(range: Range<Int>) -> String {
        guard range.lowerBound < range.upperBound else {
            return ""
        }
        let startIndex = self.base.index(self.base.startIndex, offsetBy: range.lowerBound)
        let endIndex   = self.base.index(self.base.startIndex, offsetBy: range.upperBound - 1)
        return String(self.base[startIndex...endIndex])
    }

    subscript(range: PartialRangeThrough<Int>) -> String {
        let startIndex = self.base.index(self.base.startIndex, offsetBy: 0)
        let endIndex   = self.base.index(self.base.startIndex, offsetBy: range.upperBound)
        return String(self.base[startIndex...endIndex])
    }

    subscript(range: PartialRangeUpTo<Int>) -> String {
        let startIndex = self.base.index(self.base.startIndex, offsetBy: 0)
        let endIndex   = self.base.index(self.base.startIndex, offsetBy: range.upperBound - 1)
        return String(self.base[startIndex...endIndex])
    }

    subscript(range: PartialRangeFrom<Int>) -> String {
        let startIndex = self.base.index(self.base.startIndex, offsetBy: range.lowerBound)
        let endIndex   = self.base.index(self.base.startIndex, offsetBy: self.base.count - 1)
        return String(self.base[startIndex...endIndex])
    }

    subscript(i: Int) -> Character {
        return self.base[self.base.index(self.base.startIndex, offsetBy: i)]
    }
}
