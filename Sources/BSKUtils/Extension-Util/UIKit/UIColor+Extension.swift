//
//  UIColor+Extension.swift
//  T9Call
//
//  Created by 刘万林 on 2020/11/15.
//

import UIKit

extension UIColor {
    /// 快速创建动态颜色
    /// - Parameters:
    ///   - defaultColor: 默认颜色
    ///   - dark: 深色模式的颜色
    public convenience init(light defaultColor: UIColor, dark: UIColor? = nil) {
        if #available(iOS 13.0, *), let darkColor = dark {
            self.init { (collection) -> UIColor in
                switch collection.userInterfaceStyle {
                case .dark:
                    return darkColor
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
    public convenience init(RGB: Int, alpha: CGFloat = 1) {
        let R = (RGB >> 16) & 0xFF
        let G = (RGB >> 08) & 0xFF
        let B = (RGB >> 00) & 0xFF
        self.init(red: CGFloat(R) / 255.0, green: CGFloat(G) / 255.0, blue: CGFloat(B) / 255.0, alpha: alpha)
    }

    /// 16进制颜色 例如 0xFFEDEDFF
    /// - Parameter RGBA: 颜色值
    public convenience init(RGBA: UInt32) {
        let R = (RGBA >> 24) & 0xFF
        let G = (RGBA >> 16) & 0xFF
        let B = (RGBA >> 08) & 0xFF
        let A = (RGBA >> 00) & 0xFF
        self.init(red: CGFloat(R) / 255.0, green: CGFloat(G) / 255.0, blue: CGFloat(B) / 255.0, alpha: CGFloat(A) / 255)
    }

    public convenience init(R: UInt8, G: UInt8, B: UInt8, alpha: CGFloat) {
        self.init(red: CGFloat(R) / 255.0, green: CGFloat(G) / 255.0, blue: CGFloat(B) / 255.0, alpha: alpha)
    }

    /// UIColor初始化：
    /// - Parameters:
    ///   - hexStr: 16进制颜色字符串，大小写不区分，#可以不输入，举例 "#00FF00" 或者"00ff00"
    ///   - alpha: 颜色的透明度 取值范围0-1 默认1
    public convenience init(_ hexStr: String, alpha: CGFloat = 1) {
        guard let colorStrRange = hexStr.range(of: "^#{0,1}[0-9a-zA-F]{6}$", options: .regularExpression) else {
            self.init()
            return
        }
        var colorStr = hexStr[colorStrRange]
        if colorStr.hasPrefix("#") {
            colorStr = colorStr[1...]
        }

        let rStr = String(colorStr[0 ..< 2]).uppercased()
        let gStr = String(colorStr[2 ..< 4]).uppercased()
        let bStr = String(colorStr[4 ..< 6]).uppercased()

        let r = UInt8(rStr, radix: 16) ?? 0
        let g = UInt8(gStr, radix: 16) ?? 0
        let b = UInt8(bStr, radix: 16) ?? 0

        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }

    /// 将会失去alpha通道的数据
    open var hexString: String {
        let rgbColor = rgbaColor
        return String(format: "#%02X%02X%02X", Int(rgbColor.red * 255), Int(rgbColor.green * 255), Int(rgbColor.blue * 255))
    }
}

// MARK: - RGBA Color CGFloat

/// RGBA格式的颜色，用红绿蓝和透明度来表示的颜色格式，每个值都是0～1之间的浮点数
public struct RGBAColor: Codable, Equatable {
    public var red: CGFloat
    public var green: CGFloat
    public var blue: CGFloat
    public var alpha: CGFloat

    public var uicolor: UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension UIColor {
    public var rgbaColor: RGBAColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return RGBAColor(red: r, green: g, blue: b, alpha: a)
    }

    public func with(red: CGFloat) -> UIColor {
        let rgba = rgbaColor
        return UIColor(red: red, green: rgba.green, blue: rgba.blue, alpha: rgba.alpha)
    }

    public func with(green: CGFloat) -> UIColor {
        let rgba = rgbaColor
        return UIColor(red: rgba.red, green: green, blue: rgba.blue, alpha: rgba.alpha)
    }

    public func with(blue: CGFloat) -> UIColor {
        let rgba = rgbaColor
        return UIColor(red: rgba.red, green: rgba.green, blue: blue, alpha: rgba.alpha)
    }

    public func with(alpha: CGFloat) -> UIColor {
        let rgba = rgbaColor
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

    public var RGBA255: (red: UInt8, green: UInt8, blue: UInt8, alpha: CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (UInt8(r * 255), UInt8(g * 255), UInt8(b * 255), a)
    }

    public func with(red: UInt8) -> UIColor {
        let rgba = RGBA255
        return UIColor(R: red, G: rgba.green, B: rgba.blue, alpha: rgba.alpha)
    }

    public func with(green: UInt8) -> UIColor {
        let rgba = RGBA255
        return UIColor(R: rgba.red, G: green, B: rgba.blue, alpha: rgba.alpha)
    }

    public func with(blue: UInt8) -> UIColor {
        let rgba = RGBA255
        return UIColor(R: rgba.red, G: rgba.green, B: blue, alpha: rgba.alpha)
    }
}

// MARK: - HSBA Color

/// HSBA格式的颜色，用色度饱和度亮度和透明度来表示的颜色格式，每个值都是0～1之间的浮点数
public struct HSBAColor: Codable, Equatable {
    public var hue: CGFloat
    public var saturation: CGFloat
    public var brightness: CGFloat
    public var alpha: CGFloat

    public var uicolor: UIColor {
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
}

extension UIColor {
    // 返回HSBA模式颜色值
    public var hsbaColor: HSBAColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return HSBAColor(hue: h, saturation: s, brightness: b, alpha: a)
    }

    public func with(brightness: CGFloat) -> UIColor {
        let hsba = hsbaColor
        return UIColor(hue: hsba.hue, saturation: hsba.saturation, brightness: brightness, alpha: hsba.alpha)
    }

    public func with(hue: CGFloat) -> UIColor {
        let hsba = hsbaColor
        return UIColor(hue: hue, saturation: hsba.saturation, brightness: hsba.brightness, alpha: hsba.alpha)
    }

    public func with(saturation: CGFloat) -> UIColor {
        let hsba = hsbaColor
        return UIColor(hue: hsba.hue, saturation: saturation, brightness: hsba.brightness, alpha: hsba.alpha)
    }
}

public extension Array where Element: UIColor {
    var cgcolors: [CGColor] {
        return map({ $0.cgColor })
    }
}
