//
//  String+HanziPinyin.swift
//  HanziPinyin
//
//  Created by Xin Hong on 16/4/16.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation

public typealias MultiToneFilter = ([String]) -> String

public let MultiToneFilterDefault: MultiToneFilter = { $0.first ?? "" }

public extension String {
    /// 获得拼音
    /// - Parameters:
    ///   - outputFormat: 拼音输出样式
    ///   - separator: 拼音间的间隔，默认时空格
    ///   - multiTone: 多音字处理，返回要保留的拼音
    /// - Returns: 拼音字符串
    func pinyin(withFormat outputFormat: PinyinOutputFormat = .default, separator: String = " ", multiTone: MultiToneFilter = MultiToneFilterDefault) -> String {
        var pinyinStrings = [String]()
        for unicodeScalar in unicodeScalars {
            let charCodePoint = unicodeScalar.value
            let pinyinArray = HanziPinyin.pinyinArray(withCharCodePoint: charCodePoint, outputFormat: outputFormat)

            if pinyinArray.count > 0 {
                if pinyinArray.count > 1 {
                    pinyinStrings.append(multiTone(pinyinArray))
                } else {
                    pinyinStrings.append(pinyinArray[0])
                }
            } else {
                pinyinStrings.append(String(unicodeScalar))
            }
        }
        let pinyin = pinyinStrings.joined(separator: separator)
        return pinyin
    }

    /// 异步的获取拼音
    /// - Parameters:
    ///   - outputFormat: 拼音输出样式
    ///   - separator: 拼音间隔，默认空格
    ///   - multiTone: 多音字处理，返回要保留的拼音
    ///   - completion: 完成回调
    func pinyinAsync(withFormat outputFormat: PinyinOutputFormat = .default, separator: String = " ", multiTone: @escaping MultiToneFilter = MultiToneFilterDefault, completion: @escaping ((_ pinyin: String) -> Void)) {
        DispatchQueue.global(qos: .default).async {
            let pinyin = self.pinyin(withFormat: outputFormat, separator: separator, multiTone: multiTone)
            DispatchQueue.main.async {
                completion(pinyin)
            }
        }
    }

    /// 获取拼音首字母缩写
    /// - Parameters:
    ///   - outputFormat: 拼音输出样式
    ///   - separator: 拼音间的间隔，默认时空格
    ///   - multiTone: 多音字处理，返回要保留的拼音
    /// - Returns: 拼音字符串
    func pinyinAcronym(withFormat outputFormat: PinyinOutputFormat = .default, separator: String = "", multiTone: MultiToneFilter = MultiToneFilterDefault) -> String {
        var pinyinStrings = [String]()
        for unicodeScalar in unicodeScalars {
            let charCodePoint = unicodeScalar.value
            let pinyinArray = HanziPinyin.pinyinArray(withCharCodePoint: charCodePoint, outputFormat: outputFormat)

            if pinyinArray.count > 0 {
                let acronym = pinyinArray.first!.first!
                pinyinStrings.append(String(acronym) + separator)
            } else {
                pinyinStrings.append(String(unicodeScalar))
            }
        }
        let pinyinAcronym = pinyinStrings.joined(separator: separator)
        return pinyinAcronym
    }

    /// 异步的获取拼音首字母缩写
    /// - Parameters:
    ///   - outputFormat: 拼音输出样式
    ///   - separator: 拼音间的间隔，默认时空格
    ///   - multiTone: 多音字处理，返回要保留的拼音
    ///   - completion: 完成回调
    func pinyinAcronymAsync(withFormat outputFormat: PinyinOutputFormat = .default, separator: String = "", multiTone: @escaping MultiToneFilter = MultiToneFilterDefault, completion: @escaping ((_ pinyinAcronym: String) -> Void)) {
        DispatchQueue.global(qos: .default).async {
            let pinyinAcronym = self.pinyinAcronym(withFormat: outputFormat, separator: separator, multiTone: multiTone)
            DispatchQueue.main.async {
                completion(pinyinAcronym)
            }
        }
    }

    /// 是否有中文字符
    var hasChineseCharacter: Bool {
        for unicodeScalar in unicodeScalars {
            let charCodePoint = unicodeScalar.value
            if HanziPinyin.isHanzi(ofCharCodePoint: charCodePoint) {
                return true
            }
        }
        return false
    }
}
