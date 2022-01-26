//
//  String+PinYin.swift
//  BSKToolBox-Swift
//
//  Created by BlueSky335 on 2018/6/15.
//  Copyright © 2018年 LiuWanLin. All rights reserved.
//

import Foundation

public extension BSKExtension where Base == String {
    
    /// 获取拼音首字母
    var firstPinYin: String {
        guard self.base.count > 0 else {
            return self.base
        }
        let mutableString = NSMutableString(string: self.base)
        //        把汉字转为拼音
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        //        去掉拼音的音标
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        return mutableString.substring(to: 1)
    }
    /// 获取拼音
    var PinYin: String {
        guard self.base.count > 0 else {
            return self.base
        }
        let mutableString = NSMutableString(string: self.base)
        //        把汉字转为拼音
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        //        去掉拼音的音标
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        return mutableString as String
    }
    
}
