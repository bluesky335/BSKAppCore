//
//  BSKCornerView.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2021/4/15.
//

import UIKit

@IBDesignable
open class BSKCornerView: UIView {
    @IBInspectable private(set) public var cornerRadiusTopLeft: CGFloat = 0
    @IBInspectable private(set) public var cornerRadiusTopRight: CGFloat = 0
    @IBInspectable private(set) public var cornerRadiusBottomLeft: CGFloat = 0
    @IBInspectable private(set) public var cornerRadiusBottomRight: CGFloat = 0

    private var shapeBackgroundColor: UIColor?

    open override class var layerClass: AnyClass {
        return CAShapeLayer.self
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

    open override func action(for layer: CALayer, forKey event: String) -> CAAction? {
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

    open override var backgroundColor: UIColor? {
        set {
            self.shapeBackgroundColor = newValue
            if let shape = self.layer as? CAShapeLayer {
                shape.fillColor = newValue?.cgColor
            }
        }
        get {
            return self.shapeBackgroundColor
        }
    }

    open override var cornerRadius: CGFloat {
        didSet {
            self.cornerRadiusTopLeft = self.cornerRadius
            self.cornerRadiusTopRight = self.cornerRadius
            self.cornerRadiusBottomLeft = self.cornerRadius
            self.cornerRadiusBottomRight = self.cornerRadius
            setNeedsLayout()
        }
    }

    open override var borderColor: UIColor? {
        set {
            if let shape = self.layer as? CAShapeLayer {
                shape.strokeColor = newValue?.cgColor
            }
        }
        get {
            if let shape = self.layer as? CAShapeLayer, let color = shape.strokeColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
    }

    open override var borderWidth: CGFloat {
        set {
            if let shape = self.layer as? CAShapeLayer {
                shape.lineWidth = newValue
            }
        }
        get {
            if let shape = self.layer as? CAShapeLayer {
                return shape.lineWidth
            }
            return super.borderWidth
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        updateShapLayer()
    }

    /// 绘制视图
    private func updateShapLayer() {
        if let shape = layer as? CAShapeLayer {
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
            shape.path = path.cgPath
            if shape.shadowOpacity != 0 {
                shape.shadowPath = path.cgPath
            }
        }
    }
}
