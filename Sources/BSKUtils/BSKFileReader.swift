//
//  FileReader.swift
//  
//
//  Created by 刘万林 on 2021/9/17.
//

import UIKit

/// 逐行读取文件
open class BSKFileReader {

    let encoding : String.Encoding
    let chunkSize : Int
    var fileHandle : FileHandle!
    let delimData : Data
    var buffer : Data
    var atEof : Bool
    
    /// 初始化
    /// - Parameters:
    ///   - path: 文件路径
    ///   - delimiter: 换行符，默认“\n”
    ///   - encoding: 文本编码格式，默认 utf-8
    ///   - chunkSize: 读取块的大小,默认4096 byte
    public init?(path: String, delimiter: String = "\n", encoding: String.Encoding = .utf8,
          chunkSize: Int = 4096) {

        guard let fileHandle = FileHandle(forReadingAtPath: path),
            let delimData = delimiter.data(using: encoding) else {
                return nil
        }
        self.encoding = encoding
        self.chunkSize = chunkSize
        self.fileHandle = fileHandle
        self.delimData = delimData
        self.buffer = Data(capacity: chunkSize)
        self.atEof = false
    }

    deinit {
        self.close()
    }

    /// 读取下一行文本，如果读到结尾，则返回nil
    open func nextLine() -> String? {
        precondition(fileHandle != nil, "Attempt to read from closed file")

        // Read data chunks from file until a line delimiter is found:
        while !atEof {
            if let range = buffer.range(of: delimData) {
                // Convert complete line (excluding the delimiter) to a string:
                let line = String(data: buffer.subdata(in: 0..<range.lowerBound), encoding: encoding)
                // Remove line (and the delimiter) from the buffer:
                buffer.removeSubrange(0..<range.upperBound)
                return line
            }
            let tmpData = fileHandle.readData(ofLength: chunkSize)
            if tmpData.count > 0 {
                buffer.append(tmpData)
            } else {
                // EOF or read error.
                atEof = true
                if buffer.count > 0 {
                    // Buffer contains last line in file (not terminated by delimiter).
                    let line = String(data: buffer as Data, encoding: encoding)
                    buffer.count = 0
                    return line
                }
            }
        }
        return nil
    }

    /// 重新从开头开始读取文件.
    open func rewind() -> Void {
        fileHandle.seek(toFileOffset: 0)
        buffer.count = 0
        atEof = false
    }

    /// 关闭文件
    open func close() -> Void {
        fileHandle?.closeFile()
        fileHandle = nil
    }
}

extension BSKFileReader : Sequence {
    open func makeIterator() -> AnyIterator<String> {
        return AnyIterator {
            return self.nextLine()
        }
    }
}
