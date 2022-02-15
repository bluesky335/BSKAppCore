//
//  GradientView.swift
//  T9Call
//
//  Created by 刘万林 on 2021/1/28.
//

import UIKit

open class BSKGradientView: UIView {
    override open var layer: CAGradientLayer {
        return super.layer as! CAGradientLayer
    }

    override open class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    open var colors: [UIColor]? {
        didSet {
            self.layer.colors = self.colors?.cgcolors
        }
    }

    open var locations: [NSNumber]? {
        set {
            self.layer.locations = newValue
        }
        get {
            return self.layer.locations
        }
    }

    open var startPoint: CGPoint {
        set {
            self.layer.startPoint = newValue
        }
        get {
            return self.layer.startPoint
        }
    }

    open var endPoint: CGPoint {
        set {
            self.layer.endPoint = newValue
        }
        get {
            return self.layer.endPoint
        }
    }

    open var type: CAGradientLayerType {
        set {
            self.layer.type = newValue
        }
        get {
            return self.layer.type
        }
    }

    open func setColors(_ colors: [UIColor], animated: Bool, duration: CGFloat = 0.3) {
        if animated {
            let animation = CABasicAnimation(keyPath: "colors")
            animation.duration = duration
            animation.timingFunction = .init(name: .easeInEaseOut)
            animation.fromValue = self.colors?.map({ $0.cgColor })
            animation.toValue = colors.map({ $0.cgColor })
            animation.isRemovedOnCompletion = true
            layer.add(animation, forKey: "opacity")
        }
        self.colors = colors
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.layer.colors = self.colors?.cgcolors
    }
}
