//
//  Date+toString.swift
//  DuDuModules
//
//  Created by BlueSky335 on 2019/4/17.
//  Copyright © 2019 com.cloududu. All rights reserved.
//

import UIKit

extension Date {
    enum Format: String {
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
    func toString(formate: String, locale: Locale? = .current) -> String {
        let dateFormate = DateFormatter()
        if let l = locale {
            dateFormate.locale = l
        }
        dateFormate.dateFormat = formate
        return dateFormate.string(from: base)
    }

    /// "20190608123400"
    func toPureNumberString() -> String {
        return toString(formate: "yyyyMMddHHmmss")
    }

    func toString(locale: Locale? = .current) -> String {
        let localStr = BSKLocalization.getLocalStr(table: "DateToString")

        var calendar = Calendar.current
        calendar.locale = locale
        let dateFormate = DateFormatter()
        if let l = locale {
            dateFormate.locale = l
        }

        let now = Date()

        if calendar.isDateInToday(base) {
            // 今天
            let compoents = calendar.dateComponents([.minute, .hour, .second], from: now, to: base)
            if base < now {
                if let h = compoents.hour, h < 0 {
                    // 一小时以上
                    return "\(abs(h))\(localStr.localStr(key: "小时以前"))"
                } else {
                    // 一小时以内
                    if let m = compoents.minute, m < 0 {
                        return "\(abs(m))\(localStr.localStr(key: "分钟以前"))"
                    } else {
                        return localStr.localStr(key: "刚刚")
                    }
                }
            } else {
                // 今天
                dateFormate.dateFormat = localStr.localStr(key: "HH:mm")
                return dateFormate.string(from: base)
            }
        } else if calendar.isDateInYesterday(base) {
            // 昨天
            dateFormate.dateFormat = localStr.localStr(key: "昨天 HH:mm")
            return dateFormate.string(from: base)
        } else if calendar.isDateInTomorrow(base) {
            // 明天
            dateFormate.dateFormat = localStr.localStr(key: "明天 HH:mm")
            return dateFormate.string(from: base)
        } else {
            let compoents = calendar.dateComponents([.year, .month, .day], from: base, to: Date())
            if abs(compoents.year ?? 0) > 0 {
                // 超过一年
                dateFormate.dateFormat = "yyyy-MM-dd"
                return dateFormate.string(from: base)
            } else {
                // 一年内
                dateFormate.dateFormat = "MM-dd HH:mm"
                return dateFormate.string(from: base)
            }
        }
    }

    var timestamp: Int {
        return Int(base.timeIntervalSince1970)
    }
}
