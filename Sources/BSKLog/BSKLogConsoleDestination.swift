//
//  XcodeConsoleLogger.swift
//
//
//  Created by 刘万林 on 2021/9/2.
//

import Foundation
#if SPM
    import BSKUtils
#endif
/// 在Xcode的控制台输出日志
open class BSKLogConsoleDestination: LogDestination {
    /// 详细模式，输出更多调试信息
    open var detailMode = true

    /// 单条日志显示的最大长度，过长的日志打印会导致Xcode Console 白屏，可以设置这个属性来限制输出的最大长度，默认为nil，不限制。
    open var maxLength: Int?

    open var printMode: PrintMode = .print

    public enum PrintMode {
        case nslog
        case print
    }

    public init() {
    }

    open func printLog(_ log: BSKLogObject) {
        var logStr = log.log
        let fileURL = URL(fileURLWithPath: log.file)
        let fileName = fileURL.lastPathComponent
        if let max = maxLength, log.log.count > max {
            logStr = String(log.log[..<max]) + "【内容过长，截取部分】"
        }

        var printStr = ""
        if detailMode {
            printStr.append("\n┌[\(log.level.flag)] 文件:\(fileName)第\(log.line)行 \(log.function) 线程:\(log.threadInfo) \n")
            printStr.append("│ ")
            printStr.append(logStr.replacingOccurrences(of: "\n", with: "\n│ "))
            printStr.append("\n")
            printStr.append("└――――――")
        } else {
            printStr = "[\(log.level.flag)]: \(logStr)"
        }
        switch printMode {
        case .nslog:
            NSLog(printStr)
        case .print:
            print(printStr)
        }
    }
}
