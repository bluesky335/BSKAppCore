//
//  Date+toString.swift
//  DuDuModules
//
//  Created by BlueSky335 on 2019/4/17.
//  Copyright © 2019 com.cloududu. All rights reserved.
//

import UIKit

extension Date{
    enum Format:String{
        
        /// yyyy 完整的年 如：2019
        case year = "yyyy"
        
        /// yy 年的后两位 如：19
        case yearSurfix = "yy"
        
        /// dd 天
        case day = "dd"
        case hour = ""
    }
}

public extension BSKExtension where Base == Date {
    func toString(formate: String) -> String {
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = formate
        return dateFormate.string(from: base)
    }

    func toPureNumberString()->String{
        return toString(formate: "yyyyMMddhhmm")
    }

    func toString() -> String {
        var bundle:Bundle = .main
        if let bundlePath = Bundle.bsk.appCore.path(forResource: "LocalizationString", ofType: "bundle"){
            bundle = Bundle(path: bundlePath) ?? .main
        }
        
        let local = BSKLocalization(bundle: bundle, table: "DateToString")
        
        let calendar = Calendar.current
        let dateFormate = DateFormatter()
        if calendar.isDateInToday(base) {
            // 今天
            let compoents = Calendar.current.dateComponents([.minute, .hour, .second], from: base, to: Date())
            if let h = compoents.hour, h > 0 {
                // 一小时以上
                return "\(h)\(local.localStr(key: "小时以前"))"
            } else {
                // 一小时以内
                if let m = compoents.minute, m > 0 {
                    return "\(m)\(local.localStr(key:"分钟以前"))"
                }else{
                    return local.localStr(key: "刚刚")
                }
            }
        } else if calendar.isDateInYesterday(base) {
            // 昨天
            dateFormate.dateFormat = local.localStr(key: "昨天 HH:mm") 
            return dateFormate.string(from: self.base)
        } else {
            let compoents = calendar.dateComponents([.year, .month, .day], from: base, to: Date())
            if compoents.year ?? 0 > 0 {
                // 超过一年
                dateFormate.dateFormat = "yyyy-MM-dd"
                return dateFormate.string(from: self.base)
            } else {
                // 一年内
                dateFormate.dateFormat = "MM-dd HH:mm"
                return dateFormate.string(from: self.base)
            }
        }
    }
    
    var timestamp: Int {
        return Int(self.base.timeIntervalSince1970)
    }
    
}
