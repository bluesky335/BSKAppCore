//
//  UIImage+Color.swift
//
//
//  Created by BlueSky335 on 2018/5/9.
//  Copyright © 2018年 LiuWanLin. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    // MARK: 创建一个纯色图片

    /**
     创建一个纯色图片

     - Parameter color: 颜色.
     - Parameter size: 图片大小

     - Returns 新的图片
     */
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 10, height: 10)) {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)

        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        self.init(cgImage: (UIGraphicsGetImageFromCurrentImageContext()?.cgImage!)!)
        UIGraphicsEndImageContext()
    }

    /// 渐变的方向
    public enum GradientDirection {
        case Horizontal
        case Vertical
        case custom(start: CGPoint, end: CGPoint)
    }

    // MARK: 创建一个线性渐变色图片

    /**
     创建一个渐变色图片

     - Parameter gradientColors: 渐变的颜色.
     - Parameter size: 图片大小
     - Parameter locations: 渐变的位置，0～1之间的值
     - Parameter direction: 渐变方向
     - Returns 新的图片
     */
    public convenience init?(gradientColors: [UIColor], size: CGSize = CGSize(width: 10, height: 10), locations: [Float] = [], direction: GradientDirection = .Horizontal)
    {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = gradientColors.map { (color: UIColor) -> AnyObject? in color.cgColor as AnyObject? } as NSArray
        let gradient: CGGradient
        if locations.count > 0 {
            let cgLocations = locations.map { CGFloat($0) }
            gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: cgLocations)!
        } else {
            gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: nil)!
        }

        var start = CGPoint.zero
        var end = CGPoint(x: size.width, y: 0)

        switch direction {
        case .Horizontal:
            end = CGPoint(x: size.width, y: 0)
        case .Vertical:
            end = CGPoint(x: 0, y: size.height)
        case let .custom(startP, endP):
            start = startP
            end = endP
        }

        context!.drawLinearGradient(gradient, start: start, end: end, options: [.drawsAfterEndLocation, .drawsBeforeStartLocation])
        self.init(cgImage: (UIGraphicsGetImageFromCurrentImageContext()?.cgImage!)!)
        UIGraphicsEndImageContext()
    }
}
