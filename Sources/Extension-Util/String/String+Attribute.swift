//
//  String+Attribute.swift
//  BSKToolBox-Swift
//
//  Created by BlueSky335 on 2018/5/28.
//  Copyright © 2018年 LiuWanLin. All rights reserved.
//

import Foundation

public extension BSKExtension where Base == String {
     func addAttribute(_ attrs:[NSAttributedString.Key:Any],range:NSRange) -> NSMutableAttributedString {
        let mAttributeStr = NSMutableAttributedString(string: self.base)
        mAttributeStr.addAttributes(attrs, range: range)
        return mAttributeStr
    }
    
     func AttributedString(lineHeight:CGFloat, font:UIFont, textColor:UIColor?) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        let attributesForFirstWord = [NSAttributedString.Key.paragraphStyle: paragraphStyle,
                                      NSAttributedString.Key.font : font,
                                      NSAttributedString.Key.foregroundColor : textColor ?? UIColor.black]
        return self.base.bsk.addAttribute(attributesForFirstWord, range: (self.base as NSString).range(of:self.base))
    }
    
  
}
