//
//  CLDExtension.swift
//
//  Created by BlueSky335 on 2019/4/15.
//

import UIKit

public class BSKExtension<Base> {
    /// Base object to extend.
    public let base: Base

    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol BSKExtensionProtocol {
    associatedtype BaseType
    var bsk: BSKExtension<BaseType> { get set }
    static var bsk: BSKExtension<BaseType>.Type { get set }
}

public extension BSKExtensionProtocol {
    var bsk: BSKExtension<Self> {
        get {
            return BSKExtension<Self>(self)
        }
        set {
        }
    }

    static var bsk: BSKExtension<Self>.Type {
        get {
            return BSKExtension<Self>.self
        }
        set {
        }
    }
}

extension String    : BSKExtensionProtocol {}
extension Int       : BSKExtensionProtocol {}
extension Int8      : BSKExtensionProtocol {}
extension Int16     : BSKExtensionProtocol {}
extension Int32     : BSKExtensionProtocol {}
extension Int64     : BSKExtensionProtocol {}
extension Double    : BSKExtensionProtocol {}
extension Float     : BSKExtensionProtocol {}
extension Data      : BSKExtensionProtocol {}
extension Date      : BSKExtensionProtocol {}
extension Array     : BSKExtensionProtocol {}
extension Dictionary: BSKExtensionProtocol {}
extension NSObject  : BSKExtensionProtocol {}
extension URL       : BSKExtensionProtocol {}
extension CGFloat   : BSKExtensionProtocol {}
