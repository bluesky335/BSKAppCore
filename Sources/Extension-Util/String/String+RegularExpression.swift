//
//  String+RegularExpression.swift
//  BSKToolBox-Swift
//
//  Created by BlueSky335 on 2018/4/26.
//  Copyright © 2018年 LiuWanLin. All rights reserved.
//

import Foundation

public extension BSKExtension where Base == String {

    enum RemoveWhiteCharactersOption:Int{
        case All
        case Start
        case End
        case StartAndEnd
    }

    /// 替换掉字符串中正则表达式匹配到的字符
    ///
    /// - Parameters:
    ///   - regularExpression: 正则表达式
    ///   - template: 替换的模板
    ///   - options: 正则匹配选项
    /// - Returns: 替换之后的字符串
    /// - Throws: 正则表达式错误
    func replace(match regularExpression:String, with template:String, options:NSRegularExpression.Options) throws -> String {
        do{
            let re = try NSRegularExpression(pattern: regularExpression, options: options)
            let resultStr = re.stringByReplacingMatches(in: self.base, options: .reportProgress, range: NSRange.init(location: 0, length: self.base.count), withTemplate: template)
            return resultStr
        }catch{
            throw error
        }
    }

    /// 删除字符串中的空白字符
    ///
    /// - Parameter at: 空白字符的位置:默认删除所有空白字符
    /// - Returns: 处理后的字符串
    func removeWhiteCharacters(at:RemoveWhiteCharactersOption = .All) -> String {
        var regularExpression = ""
        switch at {
            case .All:
                regularExpression = "\\s+"
            case .Start:
                regularExpression = "(^\\s+)"
            case .End:
                regularExpression = "\\s+$"
            case .StartAndEnd:
                regularExpression = "(^\\s+)|(\\s+$)"
        }

        guard let s = try? replace(match: regularExpression, with: "", options: .caseInsensitive)else {
            return self.base
        }
        return s
    }

    // 判断是否是国际手机号，除中国的11位手机号外，其他均需要加国际区号，不需要+号。
    var isGlobalPhone:Bool{
        return isMatch(regular: "(^(\\d{11})$)|(^((9[976]\\d|8[987530]\\d|6[987]\\d|5[90]\\d|42\\d|3[875]\\d|2[98654321]\\d|9[8543210]|8[6421]|6[6543210]|5[87654321]|4[987654310]|3[9643210]|2[70]|7|1)\\d{1,14})$)")
    }

    /// 是否是数字(10进制整数和小数)
    var isNumber:Bool{
        return isMatch(regular: "(^[0-9]{1,}$)|(^[0-9]{1,}(.){1,1}[0-9]{1,}$)")
    }

    /// 是否是整数
    var isIntNumber:Bool{
        return isMatch(regular: "^[0-9]{1,}$")
    }

    /// 是否是电话号码(包括固定电话和手机, 仅支持中国)
    var isPhoneNumber:Bool{
        return isMatch(regular: "^((\\+86[-, ]){0,1})((\\d{3}[-, ])|(\\d{4}[-, ])){0,1}((\\d{8}|\\d{7}|\\d{8}|\\d{7})|(1[0-9])\\d{9})$")
    }

    /// 是否是手机号(仅支持中国)
    var isMobilePhoneNumber:Bool{
        return isMatch(regular: "^((\\+86[-, ]){0,1})((\\d{3}[-, ])|(\\d{4}[-, ])){0,1}((1[0-9])\\d{9})$")
    }

    /// 是否是固定电话号码(仅支持中国)
    var isTelephoneNumber:Bool{
        return isMatch(regular: "^((\\+86[-, ]){0,1})((\\d{3}[-, ])|(\\d{4}[-, ])){0,1}(\\d{8}|\\d{7}|\\d{8}|\\d{7})$")
    }

    /// 是否是电子邮件地址
    var isEmailAddress:Bool{
        return isMatch(regular: "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$")
    }

    ///是否是用户id
    var isUserID:Bool {
        return isMatch(regular: "^[0-9]\\d{7}$")
    }
    
    ///是否是正确身份证
    var isIDCardNumber:Bool{
        return isMatch(regular: "^(\\d{14}|\\d{17})(\\d|[xX])$")
    }


    /// 如果为"true"或者为非零的数字返回 true 其他返回 false
    var boolValue:Bool{
        if self.isNumber {
            if let value = self.floatValue {
                return value != 0
            }
        }else{
            return self.base.bsk.isMatch(regular: "^true$")
        }
        return false
    }
    
    var intValue:Int?{
        if self.isIntNumber {
            return Int(self.base)
        }
        return nil
    }
    
    var floatValue:Float?{
        if self.isNumber {
            return Float(self.base)
        }else{
            return nil
        }
    }
    
    var float32Value:Float32?{
        if self.isNumber {
            return Float32(self.base)
        }else{
            return nil
        }
    }

    /// 与正则表达式是否匹配
    ///
    /// - Parameter regular: 正则表达式
    /// - Returns: 是否匹配
    func isMatch(regular:String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@",regular)
        return predicate.evaluate(with: self.base)
    }

}
