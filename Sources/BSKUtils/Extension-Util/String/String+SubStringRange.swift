//
//  String+SubStringRange.swift
//  BSKAppCore
//
//  Created by BlueSky335 on 2018/10/18.
//  Copyright © 2018 ChaungMiKeJi. All rights reserved.
//

import Foundation

public extension String {
    subscript(range: ClosedRange<Int>) -> Substring {
        let startIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
        let endIndex   = self.index(self.startIndex, offsetBy: range.upperBound)
        return self[startIndex...endIndex]
    }

    subscript(range: Range<Int>) -> Substring {
        guard range.lowerBound < range.upperBound else {
            return ""
        }
        let startIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
        let endIndex   = self.index(self.startIndex, offsetBy: range.upperBound - 1)
        return self[startIndex...endIndex]
    }

    subscript(range: PartialRangeThrough<Int>) -> Substring {
        let startIndex = self.index(self.startIndex, offsetBy: 0)
        let endIndex   = self.index(self.startIndex, offsetBy: range.upperBound)
        return self[startIndex...endIndex]
    }

    subscript(range: PartialRangeUpTo<Int>) -> Substring {
        let startIndex = self.index(self.startIndex, offsetBy: 0)
        let endIndex   = self.index(self.startIndex, offsetBy: range.upperBound - 1)
        return self[startIndex...endIndex]
    }

    subscript(range: PartialRangeFrom<Int>) -> Substring {
        let startIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
        let endIndex   = self.index(self.startIndex, offsetBy: self.count - 1)
        return self[startIndex...endIndex]
    }

    subscript(i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
}


public extension Substring {
    subscript(range: ClosedRange<Int>) -> Substring {
        let startIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
        let endIndex   = self.index(self.startIndex, offsetBy: range.upperBound)
        return self[startIndex...endIndex]
    }

    subscript(range: Range<Int>) -> Substring {
        guard range.lowerBound < range.upperBound else {
            return ""
        }
        let startIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
        let endIndex   = self.index(self.startIndex, offsetBy: range.upperBound - 1)
        return self[startIndex...endIndex]
    }

    subscript(range: PartialRangeThrough<Int>) -> Substring {
        let startIndex = self.index(self.startIndex, offsetBy: 0)
        let endIndex   = self.index(self.startIndex, offsetBy: range.upperBound)
        return self[startIndex...endIndex]
    }

    subscript(range: PartialRangeUpTo<Int>) -> Substring {
        let startIndex = self.index(self.startIndex, offsetBy: 0)
        let endIndex   = self.index(self.startIndex, offsetBy: range.upperBound - 1)
        return self[startIndex...endIndex]
    }

    subscript(range: PartialRangeFrom<Int>) -> Substring {
        let startIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
        let endIndex   = self.index(self.startIndex, offsetBy: self.count - 1)
        return self[startIndex...endIndex]
    }

    subscript(i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
}
