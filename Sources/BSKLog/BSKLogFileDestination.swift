//
//  FileLogger.swift
//
//
//  Created by 刘万林 on 2021/9/2.
//

import Foundation
#if SPM
import BSKUtils
#endif

public protocol BSKLogEncryptor {
    func encypt(_ str: String) throws -> String
    func decypt(_ str: String) throws -> String
}

/// 将日志输出到文件
public class BSKLogFileDestination: LogDestination {
    static let dateFormateStr = "yyyy-MM-dd HH:mm:ss.SSS"

    static let logFormatRegex = "^\\[(.*?)\\] (\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}.\\d{3}) ([+-]?\\d): (.*)\\t\\{(.*):(\\d*)\\}\\{(.*)\\} (.*)$"

    private var lock = NSLock()

    /// 出错时输出到Xcode控制台
    lazy var console = BSKLogConsoleDestination()

    private var dateFormater: DateFormatter

    public func printLog(_ log: BSKLogObject) {
        let timeZone = dateFormater.timeZone.secondsFromGMT() / 3600
        let timeZoneStr = "\(timeZone > 0 ? "+" : "")\(timeZone)"
        var logStr = "[\(log.level.flag)] \(dateFormater.string(from: log.date)) \(timeZoneStr): \(log.log)\t{\(log.file):\(log.line)}{\(log.function)} \(log.threadInfo)"
        do {
            logStr = try Self.encodeLogStr(logStr)
        } catch let err {
            print("日志加密失败:\(err)")
            return
        }
        logStr += "\n"
        if let data = logStr.data(using: .utf8) {
            lock.lock()
            fileHandle?.write(data)
            lock.unlock()
        }
    }

    private lazy var fileHandle: FileHandle? = {
        do {
            var handler: FileHandle?
            if !FileManager.default.fileExists(atPath: logFileDir.path) {
                try FileManager.default.createDirectory(atPath: logFileDir.path, withIntermediateDirectories: true, attributes: nil)
            }

            let logFile = logFileDir.appendingPathComponent(Date().bsk.toString(format: "yyyy-MM-dd") + ".log")

            if FileManager.default.fileExists(atPath: logFile.path) {
                handler = try FileHandle(forWritingTo: logFile)
            } else {
                if FileManager.default.createFile(atPath: logFile.path, contents: Data(), attributes: fileAttributes) {
                    handler = try FileHandle(forWritingTo: logFile)

                } else {
                    console.printLog(.init(level: .error, log: "创建日志文件失败: \(logFile.path)", threadInfo: Thread.current.debugDescription))
                }
            }
            handler?.seekToEndOfFile()
            return handler
        } catch let err {
            console.printLog(.init(level: .error, log: "创建日志文件失败: \(err)", threadInfo: Thread.current.debugDescription))
            return nil
        }
    }()

    /// 保存日志的目录
    public private(set) var logFileDir: URL

    /// 日志保存的最长天数，超过后将被删除
    public private(set) var logMaximumRetainDay: Int?

    /// 创建新日志文件时的文件属性，默认nil
    public private(set) var fileAttributes: [FileAttributeKey: Any]?

    /// 用于日志AES加密的密钥，日志为单行加密，而非整体加密，为nil则不加密，默认为nil
    public private(set) var encryptor: BSKLogEncryptor?

    /// 初始化
    /// - Parameters:
    ///   - logMaximumRetainDay: 日志最大保存时间 传 nil 则为永久
    ///   - logDir: 日志保存目录，默认在 NSTemporaryDirectory() 下的 log 目录
    ///   - fileAttributes: 创建新文件时的属性，默认 nil
    public init(logMaximumRetainDay: Int?, encryptor: BSKLogEncryptor?, logDir: String? = nil, fileAttributes: [FileAttributeKey: Any]? = nil) {
        self.encryptor = encryptor
        dateFormater = DateFormatter()
        dateFormater.dateFormat = Self.dateFormateStr
        self.fileAttributes = fileAttributes
        self.logMaximumRetainDay = logMaximumRetainDay
        if let dir = logDir {
            logFileDir = URL(fileURLWithPath: dir)
        } else {
            logFileDir = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("log")
        }
    }

    /// 删除过期的日志
    public func deleteExpiredLog() {
        guard let maxDay = logMaximumRetainDay, let subPaths = FileManager.default.subpaths(atPath: logFileDir.path) else {
            return
        }
        let tody = Date()
        for path in subPaths {
            var isDir = ObjCBool(false)
            FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
            if !isDir.boolValue,
               path.bsk.isMatch(regex: "\\d{4}-\\d{2}-\\d{2}.log$"),
               let fileName = try? URL(fileURLWithPath: path).lastPathComponent.subString(to: ".log"),
               let date = Date(from: fileName, format: "yyyy-MM-dd") {
                let days = Int((tody.timeIntervalSince1970 - date.timeIntervalSince1970) / (60 * 60 * 24))
                if days > maxDay {
                    let item = logFileDir.appendingPathComponent(path)
                    try? FileManager.default.removeItem(at: item)
                }
            }
        }
    }

    /// 转义字符串：为了使日志保证只有一行，将字符串中的\n 转义为 %n 将%转义为%_
    /// - Parameter logStr: 原始字符串
    /// - Returns: 转义后的字符串
    public static func encodeLogStr(_ logStr: String, encryptor: BSKLogEncryptor? = nil) throws -> String {
        let str = logStr.replacingOccurrences(of: "%", with: "%_").replacingOccurrences(of: "\n", with: "%n")
        if let en = encryptor {
            let encrypt_str = try en.encypt(str)
            return "Secret-" + encrypt_str
        } else {
            return str
        }
    }

    /// 将转义后的字符串还原：将%_还原为% 将%n 还原为\n
    /// - Parameter logStr: 转义字符吃
    /// - Returns: 原始字符串
    public static func decodeLogStr(_ logStr: String, encryptor: BSKLogEncryptor? = nil) throws -> String {
        var str: String = logStr
        if let en = encryptor, logStr.hasPrefix("Secret-"), let dataStr = try? logStr.subString(from: "Secret-") {
            str = try en.decypt(dataStr)
        }
        return str.replacingOccurrences(of: "%n", with: "\n").replacingOccurrences(of: "%_", with: "%")
    }

    /// 文件读取的一行数据的到Log对象，传入的字符串请不要进行转义还原操作
    public func LogFrom(logStr: String) -> BSKLogObject? {
        /// 去掉可能存在的换行符
        guard let logDataStr = logStr.split(separator: "\n").first else {
            return nil
        }
        var logLine = String(logDataStr)

        if let decodeLog = { () -> String? in
            do {
                return try Self.decodeLogStr(String(logLine))
            } catch let err {
                print("日志解密失败:\(err)")
                return nil
            }
        }() {
            logLine = decodeLog
        }

        let str = logLine as NSString
        guard let regex = try? NSRegularExpression(pattern: Self.logFormatRegex, options: []) else {
            return nil
        }
        let matches = regex.matches(in: logLine, options: [], range: .init(location: 0, length: str.length))
        guard matches.count == 1 else {
            return nil
        }
        let match = matches[0]
        guard match.numberOfRanges == 9 else {
            return nil
        }
        let flag = str.substring(with: match.range(at: 1))
        let dateStr = str.substring(with: match.range(at: 2))
        guard let timeZone = Int(str.substring(with: match.range(at: 3))) else {
            return nil
        }
        let logStr = str.substring(with: match.range(at: 4))
        let filePath = str.substring(with: match.range(at: 5))
        let fileLine = str.substring(with: match.range(at: 6))
        let function = str.substring(with: match.range(at: 7))
        let threadInfo = str.substring(with: match.range(at: 8))

        let formater = DateFormatter()
        formater.timeZone = .init(secondsFromGMT: timeZone * 3600)
        formater.dateFormat = BSKLogFileDestination.dateFormateStr

        guard let date = formater.date(from: dateStr),
              let level = BSKLogObject.Level.LevelFromFlag(flag),
              let line = Int(fileLine) else {
            return nil
        }

        let log = BSKLogObject(date: date, level: level, log: logStr, threadInfo: threadInfo, function: function, file: filePath, line: line)
        return log
    }

    deinit {
        fileHandle?.synchronizeFile()
        fileHandle?.closeFile()
    }
}
