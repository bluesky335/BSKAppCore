//
//  CodeableExtension.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2021/1/11.
//

import Foundation

extension Decodable {
    
    /// 解码Json为对象
    /// - Parameter ajson: json数据，可以是String,Data,或者可以JSONSerialization的对象
    /// - Throws: 数据错误时抛出错误
    /// - Returns: 返回解码后的对象
    public static func decode(from ajson: Any) throws -> Self {
        if let jsonStr = ajson as? String {
            return try decode(fromString: jsonStr)
        } else if let jsonData = ajson as? Data {
            return try decode(fromData: jsonData)
        } else {
            let data = try JSONSerialization.data(withJSONObject: ajson, options: .prettyPrinted)
            return try decode(fromData: data)
        }
    }
    
    /// 解码json data为对象
    /// - Parameter json: json data
    /// - Throws: 数据错误时抛出错误
    /// - Returns: 返回解码后的对象
    private static func decode(fromData json: Data) throws -> Self {
        return try JSONDecoder().decode(Self.self, from: json)
    }
    
    /// 解码Json 字符串为对象
    /// - Parameter json: json字符串
    /// - Throws: 数据错误时抛出错误
    /// - Returns: 返回解码后的对象
    private static func decode(fromString json: String) throws -> Self {
        guard let data = json.data(using: .utf8) else {
            let error = NSError(code: -1, message: "Json 解码失败")
            throw error
        }
        return try JSONDecoder().decode(Self.self, from: data)
    }
}

extension Encodable {
    
    /// 编码成JsonData
    /// - Parameter option: 选项
    /// - Throws: 数据错误时抛出编码错误
    /// - Returns: 编码后的Data
    public func toJsonData(option:JSONEncoder.OutputFormatting = []) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = option
        return try encoder.encode(self)
    }
    
    /// 编码成Json字符串
    /// - Parameter option: 选项
    /// - Throws: 数据错误时抛出编码错误
    /// - Returns: 编码后的字符串
    public func toJsonString(option:JSONEncoder.OutputFormatting = []) throws -> String {
        let data = try toJsonData(option: option)
        guard let str = String(data: data, encoding: .utf8) else {
            throw NSError(code: -1, message: "Json 编码失败")
        }
        return str
    }
    
    /// 编码成字典
    /// - Throws: 数据错误时抛出编码错误
    /// - Returns: 数据字典
    public func toJsonDic() throws -> [String: Any] {
        let data = try toJsonData()
        let dic = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        guard let json = dic as? [String: Any] else {
            throw NSError(code: -1, message: "Json 序列化失败")
        }
        return json
    }

    public var jsonData: Data? {
        try? toJsonData()
    }

    public var jsonString: String? {
        try? toJsonString()
    }

    public var jsonDic: [String: Any]? {
        try? toJsonDic()
    }
}

extension CustomStringConvertible where Self: Codable {
    public var description: String {
        return jsonString ?? "<error>"
    }
}

extension Dictionary {
    /// 返回包含换行和缩进的json字符串
    public var debugJsonString: String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
    /// 转成json字符串
    public func toJson(option:JSONSerialization.WritingOptions = []) throws -> String {
        let data = try toJsonData(option: option)
        guard let str = String(data: data, encoding: .utf8) else {
            throw EncodingError.invalidValue(self, EncodingError.Context(codingPath: [], debugDescription: "Convert to json failed because of invalid data"))
        }
        return str
    }
    
    /// 转成json Data
    public func toJsonData(option:JSONSerialization.WritingOptions = []) throws -> Data {
        let data = try JSONSerialization.data(withJSONObject: self, options: option)
        return data
    }
    
}
