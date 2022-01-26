//
//  Console.swift
//  
//
//  Created by 刘万林 on 2021/1/11.
//

import Foundation

/// 日志模型
public struct BSKLogObject: Codable {
    /// 时间
    public var date: Date
    /// 日志等级
    public var level: Level
    /// 内容
    public var log: String
    /// 产生日志的线程的信息
    public var threadInfo: String
    /// 产生日志的函数
    public var function: String = #function
    /// 产生日志的文件
    public var file: String = #file
    /// 产生日志的代码行数
    public var line: Int = #line

    public init(date: Date = Date(), level: Level, log: String, threadInfo: String, function: String = #function, file: String = #file, line: Int = #line) {
        self.date = date
        self.level = level
        self.log = log
        self.threadInfo = threadInfo
        self.function = function
        self.file = file
        self.line = line
    }

    /// 日志等级
    public enum Level: Int, CaseIterable, Codable {
        /// 成功
        case success
        /// 调试
        case debug
        /// 普通日志
        case log
        /// 警告
        case warn
        /// 错误
        case error
        /// 严重错误
        case severe

        public var flag: String {
            switch self {
            case .success:
                return "✅"
            case .debug:
                return "🐞"
            case .log:
                return "📋"
            case .warn:
                return "⚠️"
            case .error:
                return "❌"
            case .severe:
                return "☠️"
            }
        }

        static func LevelFromFlag(_ flag: String) -> Level? {
            for level in allCases {
                if level.flag == flag {
                    return level
                }
            }
            return nil
        }
    }
}

/// 日志记录器。实现此协议的对象可以被设置到ConsoleConfig.logger 中记录日志
public protocol LogDestination {
    /// 打印日志
    func printLog(_ log: BSKLogObject)
    /// 删除过期日志，会在每次启动第一次调用打印日志之前执行，更改config配置会重置状态，下一次打印之前也会调用
    func deleteExpiredLog()
}

public extension LogDestination {
    func deleteExpiredLog() {}
}

/// 日志记录工具
public class BSKLog {
    /// 日志设置
    public struct Config {
        /// LogDestination，可以自定义，默认有一个 BSKLogFileDestination，保存路径为 tmp/log/
        public var destination: [LogDestination]
        /// 是否打印到控制台，默认为true，建议Debug时设置为true，release时设置为false
        public var printToConsole: Bool = true
        /// 需要记录的日志等级，只有在这个列表内的日志才会被记录
        public var logLevel: [BSKLogObject.Level] = BSKLogObject.Level.allCases
        
        public init(destination:[LogDestination],
                        printToConsole:Bool,
                        logLevel:[BSKLogObject.Level]){
            self.destination = destination
            self.printToConsole =  printToConsole
            self.logLevel = logLevel
        }
    }

    var config: Config

    /// 是否已经检查过过期日志
    var isCheckExpiredLog = false

    /// 设置
    public static var config: Config {
        set {
            share.config = newValue
            /// 重置isCheckExpiredLog
            share.isCheckExpiredLog = false
        }
        get {
            return share.config
        }
    }

    /// 输出到xcode控制台
    lazy var consoleLoger = BSKLogConsoleDestination()

    internal static let share = BSKLog()

    init() {
        let fileDestnination = BSKLogFileDestination(logMaximumRetainDay: 30, encryptor: nil)
        let defaultConfig = Config(destination: [fileDestnination],printToConsole: true,logLevel: BSKLogObject.Level.allCases)
        config = defaultConfig
    }

    /// 删除过期日志，会通知每一个 destination 让他们自己删除自己产生的日志
    public static func deleteExpiredLog() {
        for destination in share.config.destination {
            destination.deleteExpiredLog()
        }
    }

    /// 记录调试的日志信息
    /// - Parameters:
    ///   - items: 内容，可以是多个
    ///   - showInfo: 是否展示额外的详细调试信息
    ///   - file: 调试用，调用方法的文件，不用传递，请使用默认值
    ///   - line: 调试用，调用的文件不用传递，请使用默认值
    ///   - funnction: 调试用，
    public static func debug(_ items: Any..., file: String = #file, line: Int = #line, funnction: String = #function) {
        share.printLogString(level: .debug, items, file: file, line: line, function: funnction)
    }

    /// 记录成功的日志信息
    /// - Parameters:
    ///   - items: 内容，可以是多个
    ///   - showInfo: 是否展示额外的详细调试信息
    ///   - file: 调试用，不用传递，请使用默认值
    ///   - line: 调试用，不用传递，请使用默认值
    public static func success(_ items: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        share.printLogString(level: .success, items, file: file, line: line, function: function)
    }

    /// 记录普通的日志信息
    /// - Parameters:
    ///   - items: 内容，可以是多个
    ///   - showInfo: 是否展示额外的详细调试信息
    ///   - file: 调试用，不用传递，请使用默认值
    ///   - line: 调试用，不用传递，请使用默认值
    public static func log(_ items: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        share.printLogString(level: .log, items, file: file, line: line, function: function)
    }

    /// 记录警告信息
    /// - Parameters:
    ///   - items: 内容，可以是多个
    ///   - showInfo: 是否展示额外的详细调试信息
    ///   - file: 调试用，不用传递，请使用默认值
    ///   - line: 调试用，不用传递，请使用默认值
    public static func warn(_ items: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        share.printLogString(level: .warn, items, file: file, line: line, function: function)
    }

    /// 记录错误信息
    /// - Parameters:
    ///   - items: 内容，可以是多个
    ///   - showInfo: 是否展示额外的详细调试信息
    ///   - file: 调试用，不用传递，请使用默认值
    ///   - line: 调试用，不用传递，请使用默认值
    public static func error(_ items: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        share.printLogString(level: .error, items, file: file, line: line, function: function)
    }

    /// 记录严重错误信息
    /// - Parameters:
    ///   - items: 内容，可以是多个
    ///   - showInfo: 是否展示额外的详细调试信息
    ///   - file: 调试用，不用传递，请使用默认值
    ///   - line: 调试用，不用传递，请使用默认值
    public static func severe(_ items: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        share.printLogString(level: .severe, items, file: file, line: line, function: function)
    }

    private func printLogString(level: BSKLogObject.Level, _ items: [Any], file: String, line: Int, function: String) {
        guard config.logLevel.contains(level) else {
            return
        }
        let tid = pthread_self()
        var Pid: __uint64_t = 0
        pthread_threadid_np(tid, &Pid)

        var threadInfo = "thread:\(Pid)"
        if Thread.isMainThread {
            threadInfo.append("(main)")
        }

        logQueue.async {
            /// 如果本次启动还没有检查过过期日志，则开始检查过期日志。
            if !self.isCheckExpiredLog {
                self.isCheckExpiredLog = true
                BSKLog.deleteExpiredLog()
            }
            var strs = [String]()
            for item in items {
                strs.append(String(describing: item))
            }
            let printLog = strs.joined(separator: " ")
            let date = Date()
            let log = BSKLogObject(date: date, level: level, log: printLog, threadInfo: threadInfo, function: function, file: file, line: line)
            for monitor in self.config.destination {
                monitor.printLog(log)
            }
            if self.config.printToConsole {
                self.consoleLoger.printLog(log)
            }
        }
    }

    private let logQueue = DispatchQueue(label: "log")
}
