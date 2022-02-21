//
//  Date+toString.swift
//
//  Created by BlueSky335 on 2019/4/17.
//

import UIKit

fileprivate class __XXXClass {}

fileprivate let localize = BSKLocalization(bundle: Bundle(for: __XXXClass.self), table: "DateToString")

public extension BSKExtension where Base == Date {
    /// 转换日期成字符串
    /// - Parameters:
    ///   - formate: 日期格式，例如"yyyy-MM-dd",如果不为空且 指定了 formater，则它将被赋值给formater.dateFormat
    ///   - locale: 地区，用于时间的本地化，默认 当前地区
    ///   - formater: 指定formatter 如果不指定，则重新初始化一个
    /// - Returns: 返回格式化的字符串
    func toString(format: String? = nil, locale: Locale? = .current, use formater: DateFormatter? = nil) -> String {
        let dateFormater = formater ?? DateFormatter()
        if let l = locale {
            dateFormater.locale = l
        }
        if format != nil {
            dateFormater.dateFormat = format
        }
        return dateFormater.string(from: base)
    }
    
    /// 根据与现在的距离只能点转换成描述字符串，比如15分钟以前、昨天 14:25、明天 12:10等等
    /// - Parameter locale: 国际化
    /// - Returns: 字符串
    func toSmartString(locale: Locale = .current) -> String {

        var calendar = Calendar.current
        calendar.locale = locale
        let dateFormate = DateFormatter()
        dateFormate.locale = locale

        let now = Date()

        let nowInfo = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        let dateInfo = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: base)

        if calendar.isDateInToday(base) {
            // 今天
            let compoents = calendar.dateComponents([.hour, .minute, .second], from: now, to: base)

            if let h = compoents.hour, h == 0 {
                // 一小时以内
                if let m = compoents.minute {
                    if m < 0 {
                        return "\(abs(m))\(localize.localStr(key: "分钟以前"))"
                    } else if m == 0 {
                        // 一分钟以内
                        return localize.localStr(key: "刚刚")
                    }
                }
            }
            // 今天
            dateFormate.dateFormat = localize.localStr(key: "HH:mm")
            return dateFormate.string(from: base)
        } else if calendar.isDateInYesterday(base) {
            // 昨天
            dateFormate.dateFormat = localize.localStr(key: "昨天 HH:mm")
            return dateFormate.string(from: base)
        } else if calendar.isDateInTomorrow(base) {
            // 明天
            dateFormate.dateFormat = localize.localStr(key: "明天 HH:mm")
            return dateFormate.string(from: base)
        }

        if nowInfo.year != dateInfo.year {
            // 不同年
            dateFormate.dateFormat = "yyyy-MM-dd"
            return dateFormate.string(from: base)
        } else {
            // 同一年
            dateFormate.dateFormat = "MM-dd HH:mm"
            return dateFormate.string(from: base)
        }
    }

    var timestamp: Int {
        return Int(base.timeIntervalSince1970)
    }
}
