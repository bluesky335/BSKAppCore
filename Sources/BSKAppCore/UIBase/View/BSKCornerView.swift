//
//  BSKCornerView.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2021/4/15.
//

import UIKit

@IBDesignable
open class BSKCornerView: UIView {
    @IBInspectable public private(set) var cornerRadiusTopLeft: CGFloat = 0
    @IBInspectable public private(set) var cornerRadiusTopRight: CGFloat = 0
    @IBInspectable public private(set) var cornerRadiusBottomLeft: CGFloat = 0
    @IBInspectable public private(set) var cornerRadiusBottomRight: CGFloat = 0

    private var shapeBackgroundColor: UIColor?

    override open class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    override open var layer: CAShapeLayer {
        return super.layer as! CAShapeLayer
    }

    /// 设置圆角
    /// - Parameters:
    ///   - corner: 圆角位置
    ///   - radius: 圆角大小
    open func set(corner: UIRectCorner, radius: CGFloat) {
        if corner.contains(.topLeft) {
            cornerRadiusTopLeft = radius
        }
        if corner.contains(.topRight) {
            cornerRadiusTopRight = radius
        }
        if corner.contains(.bottomLeft) {
            cornerRadiusBottomLeft = radius
        }
        if corner.contains(.bottomRight) {
            cornerRadiusBottomRight = radius
        }
        setNeedsLayout()
    }

    override open func action(for layer: CALayer, forKey event: String) -> CAAction? {
        let action = super.action(for: layer, forKey: event)
        if layer == self.layer,
           action != nil,
           ["path", "lineWidth", "strokeColor", "fillColor"].contains(event)
        {
            let animation = CABasicAnimation(keyPath: event)
            animation.duration = UIView.inheritedAnimationDuration
            return animation
        }
        return action
    }

    override open var backgroundColor: UIColor? {
        set {
            self.shapeBackgroundColor = newValue
            self.layer.fillColor = newValue?.cgColor
        }
        get {
            return self.shapeBackgroundColor
        }
    }

    override open var cornerRadius: CGFloat {
        didSet {
            self.cornerRadiusTopLeft = self.cornerRadius
            self.cornerRadiusTopRight = self.cornerRadius
            self.cornerRadiusBottomLeft = self.cornerRadius
            self.cornerRadiusBottomRight = self.cornerRadius
            setNeedsLayout()
        }
    }

    override open var borderColor: UIColor? {
        didSet {
            self.layer.strokeColor = borderColor?.cgColor
        }
    }

    override open var borderWidth: CGFloat {
        set {
            self.layer.lineWidth = newValue
        }
        get {
            return self.layer.lineWidth
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        updateShapLayer()
    }

    /// 绘制视图
    private func updateShapLayer() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frame.width - cornerRadiusTopRight, y: 0))

        path.addArc(withCenter: CGPoint(x: frame.width - cornerRadiusTopRight, y: cornerRadiusTopRight),
                    radius: cornerRadiusTopRight,
                    startAngle: CGFloat(1.5 * Double.pi),
                    endAngle: 0,
                    clockwise: true)

        path.addLine(to: CGPoint(x: frame.width, y: frame.height - cornerRadiusBottomRight))

        path.addArc(withCenter: CGPoint(x: frame.width - cornerRadiusBottomRight, y: frame.height - cornerRadiusBottomRight),
                    radius: cornerRadiusBottomRight,
                    startAngle: 0,
                    endAngle: CGFloat(0.5 * Double.pi),
                    clockwise: true)

        path.addLine(to: CGPoint(x: cornerRadiusBottomLeft, y: frame.height))

        path.addArc(withCenter: CGPoint(x: cornerRadiusBottomLeft, y: frame.height - cornerRadiusBottomLeft),
                    radius: cornerRadiusBottomLeft,
                    startAngle: CGFloat(0.5 * Double.pi),
                    endAngle: CGFloat(Double.pi),
                    clockwise: true)

        path.addLine(to: CGPoint(x: 0, y: cornerRadiusTopLeft))

        path.addArc(withCenter: CGPoint(x: cornerRadiusTopLeft, y: cornerRadiusTopLeft),
                    radius: cornerRadiusTopLeft,
                    startAngle: CGFloat(Double.pi),
                    endAngle: CGFloat(1.5 * Double.pi),
                    clockwise: true)

        path.addLine(to: CGPoint(x: frame.width - cornerRadiusTopRight, y: 0))
        path.close()
        layer.path = path.cgPath
        if layer.shadowOpacity != 0 {
            layer.shadowPath = path.cgPath
        }
    }

    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layer.strokeColor = borderColor?.cgColor
        layer.fillColor = shapeBackgroundColor?.cgColor
    }
}
