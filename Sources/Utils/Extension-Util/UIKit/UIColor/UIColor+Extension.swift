//
//  UIColor+Extension.swift
//  T9Call
//
//  Created by 刘万林 on 2020/11/15.
//

import UIKit

extension UIColor {
    /// 动态颜色
    /// - Parameters:
    ///   - defaultColor: 默认颜色
    ///   - dark: 深色模式的颜色
    convenience init(light defaultColor: UIColor, dark: UIColor? = nil) {
        if #available(iOS 13.0, *) {
            self.init { (collection) -> UIColor in
                switch collection.userInterfaceStyle {
                case .dark:
                    return dark ?? defaultColor
                default:
                    return defaultColor
                }
            }
        } else {
            self.init(cgColor: defaultColor.cgColor)
        }
    }

    /// 16进制颜色 例如 0xFFEDED
    /// - Parameter RGB: 颜色值
    /// - Parameter alpha: 透明度
    convenience init(RGB: Int, alpha: CGFloat = 1) {
        let R = (RGB >> 16) & 0xFF
        let G = (RGB >> 08) & 0xFF
        let B = (RGB >> 00) & 0xFF
        self.init(red: CGFloat(R) / 255.0, green: CGFloat(G) / 255.0, blue: CGFloat(B) / 255.0, alpha: alpha)
    }

    /// 16进制颜色 例如 0xFFEDEDFF
    /// - Parameter RGBA: 颜色值
    convenience init(RGBA: UInt32) {
        let R = (RGBA >> 24) & 0xFF
        let G = (RGBA >> 16) & 0xFF
        let B = (RGBA >> 08) & 0xFF
        let A = (RGBA >> 00) & 0xFF
        self.init(red: CGFloat(R) / 255.0, green: CGFloat(G) / 255.0, blue: CGFloat(B) / 255.0, alpha: CGFloat(A) / 255)
    }

    convenience init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha) / 255)
    }
}

// MARK: - RGBA Color CGFloat

extension UIColor {
    public var RGBA: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b, a)
    }

    public func with(red: CGFloat) -> UIColor {
        let rgba = RGBA
        return UIColor(red: red, green: rgba.green, blue: rgba.blue, alpha: rgba.alpha)
    }

    public func with(green: CGFloat) -> UIColor {
        let rgba = RGBA
        return UIColor(red: rgba.red, green: green, blue: rgba.blue, alpha: rgba.alpha)
    }

    public func with(blue: CGFloat) -> UIColor {
        let rgba = RGBA
        return UIColor(red: rgba.red, green: rgba.green, blue: blue, alpha: rgba.alpha)
    }

    public func with(alpha: CGFloat) -> UIColor {
        let rgba = RGBA
        return UIColor(red: rgba.red, green: rgba.green, blue: rgba.blue, alpha: alpha)
    }
}

// MARK: - RGBA Color Int8

extension UIColor {
    public var RGBA_UInt32: UInt32 {
        let rgba = RGBA255
        var value: UInt32 = 0
        value = value | (UInt32(rgba.alpha) << 0)
        value = value | (UInt32(rgba.blue) << 8)
        value = value | (UInt32(rgba.green) << 16)
        value = value | (UInt32(rgba.red) << 24)
        return value
    }

    public var RGBA255: (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (UInt8(r * 255), UInt8(g * 255), UInt8(b * 255), UInt8(a * 255))
    }

    public func with(red: UInt8) -> UIColor {
        let rgba = RGBA255
        return UIColor(red: red, green: rgba.green, blue: rgba.blue, alpha: rgba.alpha)
    }

    public func with(green: UInt8) -> UIColor {
        let rgba = RGBA255
        return UIColor(red: rgba.red, green: green, blue: rgba.blue, alpha: rgba.alpha)
    }

    public func with(blue: UInt8) -> UIColor {
        let rgba = RGBA255
        return UIColor(red: rgba.red, green: rgba.green, blue: blue, alpha: rgba.alpha)
    }
}

// MARK: - HSBA Color

extension UIColor {
    // 返回HSBA模式颜色值
    public var HSBA: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (h, s, b, a)
    }

    public func with(brightness: CGFloat) -> UIColor {
        let hsba = HSBA
        return UIColor(hue: hsba.hue, saturation: hsba.saturation, brightness: brightness, alpha: hsba.alpha)
    }

    public func with(hue: CGFloat) -> UIColor {
        let hsba = HSBA
        return UIColor(hue: hue, saturation: hsba.saturation, brightness: hsba.brightness, alpha: hsba.alpha)
    }

    public func with(saturation: CGFloat) -> UIColor {
        let hsba = HSBA
        return UIColor(hue: hsba.hue, saturation: saturation, brightness: hsba.brightness, alpha: hsba.alpha)
    }
}
