//
//  File.swift
//
//
//  Created by 刘万林 on 2021/10/16.
//

import CoreGraphics
import UIKit

public extension UIImage {
    /// 是否有透明通道
    var hasAlphaChannel: Bool {
        if let info = cgImage?.alphaInfo, info != .none {
            return true
        }
        return false
    }

    /// 根据当前图片创建一个等比缩放后的新尺寸图片
    /// - Parameter scale: 缩放比例
    /// - Returns: 新图片
    func image(withScale scale: CGFloat) -> UIImage? {
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        UIGraphicsBeginImageContextWithOptions(newSize, !hasAlphaChannel, 0)
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    enum ResizeMode: Int {
        case scaleToFill = 0
        case scaleAspectFit = 1
        case scaleAspectFill = 2
    }

    /// 根据当前图片创建一个新尺寸图片
    /// - Parameters:
    ///   - newSize: 新尺寸
    /// - Returns: 新图片
    func image(withSize newSize: CGSize, mode: ResizeMode = .scaleAspectFit) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, !hasAlphaChannel, 0)
        var imageRect = CGRect.zero
        switch mode {
        case .scaleToFill:
            imageRect = CGRect(origin: .zero, size: newSize)
        case .scaleAspectFit:
            let widthScale = newSize.width / size.width
            let newHeight = size.height * widthScale
            if newHeight <= newSize.height {
                imageRect = CGRect(origin: CGPoint(x: 0, y: (newSize.height - newHeight) / 2),
                                   size: CGSize(width: newSize.width, height: newHeight))
            } else {
                let heightScale = newSize.height / size.height
                let newWidth = size.width * heightScale
                imageRect = CGRect(origin: CGPoint(x: (newSize.width - newWidth) / 2, y: 0),
                                   size: CGSize(width: newWidth, height: newSize.height))
            }
        case .scaleAspectFill:
            let widthScale = newSize.width / size.width
            let newHeight = size.height * widthScale
            if newHeight >= newSize.height {
                imageRect = CGRect(origin: CGPoint(x: 0, y: (newSize.height - newHeight) / 2),
                                   size: CGSize(width: newSize.width, height: newHeight))
            } else {
                let heightScale = newSize.height / size.height
                let newWidth = size.width * heightScale
                imageRect = CGRect(origin: CGPoint(x: (newSize.width - newWidth) / 2, y: 0),
                                   size: CGSize(width: newWidth, height: newSize.height))
            }
        }
        draw(in: imageRect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
