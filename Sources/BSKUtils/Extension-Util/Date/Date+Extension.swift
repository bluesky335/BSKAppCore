//
//  Date+Calendar.swift
//
//
//

import Foundation

/// 日期扩展
public extension Date {
    
    /// 字符串转换Date
    /// - Parameters:
    ///   - from: 字符串 日期
    ///   - format: 字符串格式
    init?(from dateStr:String, format:String) {
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: dateStr) else {
            return nil
        }
        self.init(timeIntervalSince1970: date.timeIntervalSince1970)
    }
    
}

/// 日期扩展
public extension BSKExtension where Base == Date {
    
    /// 当前时间是哪年
    /// - Returns: 当前时间的年份
    func year() -> Int {
        let dateComponent = Calendar.current.dateComponents([.year], from: self.base)
        return dateComponent.year!
    }
   
    /// 当前时间是哪月
    /// - Returns: 当前时间的月份
    func month() -> Int {
        let dateComponent = Calendar.current.dateComponents([.month], from: self.base)
        return dateComponent.month!
    }
    
    /// 当前时间是几日
    /// - Returns: 当前时间是几日
    func day() -> Int {
        let dateComponent = Calendar.current.dateComponents([.day], from: self.base)
        return dateComponent.day!
    }
    
    enum DayOfWeek:Int {
        /// 周日
        case sunday = 1
        /// 周一
        case mondy = 2
        /// 周二
        case tuesday = 3
        /// 周三
        case wednesday = 4
        /// 周四
        case thursday = 5
        /// 周五
        case friday = 6
        /// 周六
        case saturday = 7
    }
    
    /// 当前时间是周几
    /// - Returns: 当前时间是周几   1 为星期天 2 为星期一  3为星期二   4为星期三
    func weekday() -> DayOfWeek {
        let dateComponent = Calendar.current.dateComponents([.weekday], from: self.base)
        return Date.bsk.DayOfWeek(rawValue: dateComponent.weekday!)!
    }
    
    /// 获得日期是当年的第几天
    /// - Returns: 日期是当年的第几天
     func dayOfYear() -> Int {
         return Int(self.toString(format: "D"))!
    }
    
    /// 获得某日期的月份有多少天
    /// - Returns: 天数
    func countOfDayInMonth() -> Int {
        let range = Calendar.current.range(of: .day, in: .month, for: self.base)
        return range!.count
    }
    
    /// 获得某日期的月份的第一天是星期几
    /// - Returns: 星期几
    func firstWeekDayInMonth() -> DayOfWeek {
        let dateComponent = Calendar.current.dateComponents([.year,.month], from: self.base)
        let firstDay = String(dateComponent.year!) + "-" + String(dateComponent.month!) + "-01"
        let firstDate = Date(from: firstDay, format: "yyyy-MM-dd")
        let newComponent =  Calendar.current.dateComponents([.weekday], from: firstDate!)
        return Date.bsk.DayOfWeek(rawValue: newComponent.weekday!)!
    }
    
    /// 获得明天的日期
    /// - Returns: 明天的日期
    func tomorrow() -> Date {
        var dateComponent = DateComponents()
        dateComponent.year = 0
        dateComponent.month = 0
        dateComponent.day = 1
        let date = Calendar.current.date(byAdding: dateComponent, to:self.base)
        return date!
    }
    
    
    /// 获得昨天的字符串日期
    /// - Returns: 昨天的字符串日期 2021-08-12
    func yesterday() -> Date {
        var dateComponent = DateComponents()
        dateComponent.year = 0
        dateComponent.month = 0
        dateComponent.day = -1
        let date = Calendar.current.date(byAdding: dateComponent, to:self.base)
        return date!
    }
    
    /// 日期的年份是否为闰年
    /// - Returns: true or false
    func isLeapYear() -> Bool {
        let year = Int(self.toString(format: "yyyy"))
        if (year! % 4 == 0 && year! % 100 != 0) || year! % 400 == 0 {
            return true
        }
        return false
    }
    
    
    /// 根据 传入的 年 月 日 时 分 秒 转换为时间
    /// - Parameters:
    ///   - year: 年  默认当年
    ///   - month: 月  默认当月
    ///   - day: 日 默认当日
    ///   - hour: 时 默认 0时
    ///   - minute: 分  默认 0分
    ///   - second: 秒  默认 0秒
    /// - Returns: 时间
    static func dateWith(year: Int , month: Int , day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date {
        let dateComponent = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
        let date = Calendar.current.date(from: dateComponent) ?? Date()
        return date
    }
}
