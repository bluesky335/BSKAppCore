//
//  String+SubStringRange.swift
//  BSKAppCore
//
//  Created by BlueSky335 on 2018/10/18.
//  Copyright © 2018 ChaungMiKeJi. All rights reserved.
//

import Foundation


/// String 扩展
public extension String {
    
    /// 字符串截取异常
    enum SubStringError: Error {
        case outOfRange
        case notFound(str: String)
    }

    /// 通过指定字符串 去截取字符 不包含起始和结束位置的字符串
    ///  let str = "we are family,are you ok?"
    ///  let subStr= str.subString(from:"we a", to:"u ok")
    ///  print(subStr) 为："re family，are yo"
    /// - Parameters:
    ///   - startString: 起始字符串
    ///   - endString: 结束字符串
    /// - Throws: 如果 startString 或者 endString 不存在，或为空字符串，则抛出 SubStringError.notFound(str: String)
    /// - Returns: 截取的字符串
    func subString(from startString: String, to endString: String) throws -> String {
        guard let startRang = range(of: startString) else {
            throw SubStringError.notFound(str: startString)
        }
        guard let endRang = range(of: endString) else {
            throw SubStringError.notFound(str: endString)
        }
        guard endRang.lowerBound >= startRang.upperBound else {
            throw SubStringError.outOfRange
        }
        let subString = String(self[startRang.upperBound ..< endRang.lowerBound])
        return subString
    }

    /// 通过指定字符串 去截取字符 不包含结束位置的字符串
    ///  let str = "we are family,are you ok?"
    ///  let subStr= str.subString(to:"u ok")
    ///  print(subStr) 为："we are family，are yo"
    /// - Parameters:
    ///   - endString: 结束字符串
    /// - Throws: 如果 endString 不存在，或为空字符串，则抛出 SubStringError.notFound(str: String)
    /// - Returns: 截取的字符串
    func subString(to endString: String) throws -> String {
        guard let endRang = range(of: endString) else {
            throw SubStringError.notFound(str: endString)
        }
        let subString = String(self[..<endRang.lowerBound])
        return subString
    }

    /// 通过指定字符串 去截取字符 不包含起始位置的字符串
    ///  let str = "we are family,are you ok?"
    ///  let subStr= str.subString(from:"we a")
    ///  print(subStr) 为："re family，are you ok?"
    /// - Parameters:
    ///   - startString: 起始字符串
    /// - Throws: 如果startString 不存在，或为空字符串，则抛出 SubStringError.notFound(str: String)
    /// - Returns: 截取的字符串
    func subString(from startString: String) throws -> String {
        guard let startRang = range(of: startString) else {
            throw SubStringError.notFound(str: startString)
        }
        let subString = String(self[startRang.upperBound...])
        return subString
    }

    /// 获取文件名后缀
    /// - Returns: 文件后缀
    func pathExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }

    /// 字符串脱敏处理
    /// - Parameters:
    ///   - start: 开头保留位数
    ///   - end: 结尾保留位数
    /// - Returns: 脱敏后的字符串
    func desensitize(_ start: Int, _ end: Int) -> String? {
        
        guard self.count == 0 else {
            return SubStringError.notFound(str: "String is empty").message
        }
        
        guard start > self.count || end > self.count ||
                (start + end) > self.count || start < 0
                || end < 0 else {
            return SubStringError.outOfRange.message
        }
        
        var string = String()
        let range = start...(self.count - end - 1)
        for (index, char) in self.enumerated() {
            if range.contains(index) {
                string.append("*")
            } else {
                string.append(char)
            }
        }
        return string
    }
}


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