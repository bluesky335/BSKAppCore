//
//  JsonCodable.swift
//
//
//  Created by 刘万林 on 2022/2/25.
//

import Foundation

public protocol DecodeDefaultValue: Codable {
    static var defaultValue: Self { get }
}

/// 在json编解码时忽略此字段，解码时使用默认值，如果是自定义类型应该实现DecodeDefaultValue协议
/// 使用方法：
/// struct SomeType:Codable {
///     @CodableDiscar
///     var valueA:Int
/// }
@propertyWrapper public struct CodableDiscar<T: DecodeDefaultValue>: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(T.self)) ?? T.defaultValue
    }

    public func encode(to encoder: Encoder) throws {
    }

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }

    public var wrappedValue: T
}

/// 当Json解析不存在此字段或者为nil时，使用默认值，如果是自定义类型应该实现DecodeDefaultValue协议
/// 使用方法：
/// struct SomeType:Codable {
///     @DecodeDefault
///     var valueA:Int
/// }
@propertyWrapper public struct DecodeDefault<T: DecodeDefaultValue>: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(T.self)) ?? T.defaultValue
    }

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }

    public var wrappedValue: T
}

public extension KeyedDecodingContainer {
    func decode<T>(
        _ type: DecodeDefault<T>.Type,
        forKey key: Key
    ) throws -> DecodeDefault<T> where T: DecodeDefaultValue {
        try decodeIfPresent(type, forKey: key) ?? DecodeDefault(wrappedValue: T.defaultValue)
    }

    func decode<T>(
        _ type: CodableDiscar<T>.Type,
        forKey key: Key
    ) throws -> CodableDiscar<T> where T: DecodeDefaultValue {
        try decodeIfPresent(type, forKey: key) ?? CodableDiscar(wrappedValue: T.defaultValue)
    }
}

public extension KeyedEncodingContainer {
    mutating func encode<T>(_ value: CodableDiscar<T>, forKey key: KeyedEncodingContainer<K>.Key) throws where T: DecodeDefaultValue {
    }
}

/// 可用于Optional属性，编码成json时：当字段是nil的时候在候忽略它，解码json时：当json中不存在这个字段时将属性设置成nil
/// 例如：
/// struct SomeType:Codable {
///     @JsonIgnoreWhenNil
///     var valueA:Int?
/// }
@propertyWrapper public struct CodableDiscarWhenNil<T>: Codable where T: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try? container.decode(T.self)
    }

    public init(wrappedValue: T?) {
        self.wrappedValue = wrappedValue
    }

    public var wrappedValue: T?
}

public extension KeyedDecodingContainer {
    func decode<T>(
        _ type: CodableDiscarWhenNil<T>.Type,
        forKey key: Key
    ) throws -> CodableDiscarWhenNil<T> {
        try decodeIfPresent(type, forKey: key) ?? CodableDiscarWhenNil(wrappedValue: nil)
    }
}

public extension KeyedEncodingContainer {
    mutating func encode<T>(_ value: CodableDiscarWhenNil<T>, forKey key: KeyedEncodingContainer<K>.Key) throws {
        if value.wrappedValue != nil {
            try encodeIfPresent(value, forKey: key)
        }
    }
}

extension String: DecodeDefaultValue {
    public static var defaultValue: String {
        return ""
    }
}

extension Int: DecodeDefaultValue {
    public static var defaultValue: Int {
        return 0
    }
}

extension Int8: DecodeDefaultValue {
    public static var defaultValue: Int8 {
        return 0
    }
}

extension Int16: DecodeDefaultValue {
    public static var defaultValue: Int16 {
        return 0
    }
}

extension Int32: DecodeDefaultValue {
    public static var defaultValue: Int32 {
        return 0
    }
}

extension Int64: DecodeDefaultValue {
    public static var defaultValue: Int64 {
        return 0
    }
}

extension Double: DecodeDefaultValue {
    public static var defaultValue: Double {
        return 0
    }
}

extension Float: DecodeDefaultValue {
    public static var defaultValue: Float {
        return 0
    }
}

extension Bool: DecodeDefaultValue {
    public static var defaultValue: Bool {
        return false
    }
}

extension Array: DecodeDefaultValue where Element: Codable {
    public static var defaultValue: [Element] {
        return []
    }
}
