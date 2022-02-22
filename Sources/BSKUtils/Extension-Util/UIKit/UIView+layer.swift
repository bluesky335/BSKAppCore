//
//  UIView+layer.swift
//  BSKAppCore
//
//  Created by BlueSky335 on 2019/4/15.
//

import Foundation
import UIKit

extension UIView {
    @available(iOS 11.0, *)
    @objc open var maskedCorners: CACornerMask {
        set {
            layer.maskedCorners = newValue
        }
        get {
            return layer.maskedCorners
        }
    }

    @available(iOS 13.0, *)
    @objc open var cornerCurve: CALayerCornerCurve {
        set {
            layer.cornerCurve = newValue
        }
        get {
            return layer.cornerCurve
        }
    }

    @objc open var masksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }

    @IBInspectable @objc open var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable @objc open var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable @objc open var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable @objc open var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }

    @IBInspectable @objc open var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable @objc open var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    @IBInspectable @objc open var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    @IBInspectable @objc open var shadowPath: CGPath? {
        get {
            return layer.shadowPath
        }
        set {
            layer.shadowPath = newValue
        }
    }

    /// 添加阴影
    /// - Parameters:
    ///   - color: 颜色
    ///   - opacity: 透明度
    ///   - radius: 半径
    ///   - offset: 偏移
    func addShadow(color: UIColor, opacity: Float, radius: CGFloat, offset: CGSize) {
        shadowColor = color
        shadowOpacity = opacity
        shadowRadius = radius
        shadowOffset = offset
    }
}
