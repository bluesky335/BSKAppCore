//
//  PinyinOutputFormat.swift
//  HanziPinyin
//
//  Created by Xin Hong on 16/4/16.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation

/// 声调类型
public enum PinyinToneType {
    /// 不输出声调
    case none
    /// 输出数字声调
    case toneNumber
}

/// 韵母yu的输出样式
public enum PinyinVCharType {
    /// 输出英文字母v：v
    case vCharacter
    /// 输出：ü
    case uUnicode
    /// 输出英文字母u和冒号：u:
    case uAndColon
}

/// 拼音大小写
public enum PinyinCaseType {
    /// 全小写
    case lowercased
    /// 全大写
    case uppercased
    /// 首字母大写
    case capitalized
}

/// 拼音输出样式
public struct PinyinOutputFormat {
    public var toneType: PinyinToneType
    public var vCharType: PinyinVCharType
    public var caseType: PinyinCaseType

    public static var `default`: PinyinOutputFormat {
        return PinyinOutputFormat(toneType: .none, vCharType: .vCharacter, caseType: .lowercased)
    }

    public init(toneType: PinyinToneType, vCharType: PinyinVCharType, caseType: PinyinCaseType) {
        self.toneType = toneType
        self.vCharType = vCharType
        self.caseType = caseType
    }
}
