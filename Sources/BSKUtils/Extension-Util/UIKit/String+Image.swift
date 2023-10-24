//
//  File.swift
//
//
//  Created by BlueSky335 on 2023/7/31.
//

import UIKit

extension String {
    public func toImage(size: CGSize, attributes: [NSAttributedString.Key: Any]? = nil) -> UIImage {
        let bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { context in
            UIColor.clear.setFill()
            context.fill(bounds)
            let str = self as NSString
            let attri = attributes ?? [.foregroundColor: UIColor.systemBlue, .font: UIFont.systemFont(ofSize: min(size.width, size.height) * 0.8)]
            var frame = str.boundingRect(with: size, attributes: attri, context: nil)
            frame.origin.x = (size.width - frame.width) / 2
            frame.origin.y = (size.height - frame.height) / 2
            str.draw(in: frame, withAttributes: attri)
        }
    }
}

extension NSAttributedString {
    public func toImage(size: CGSize) -> UIImage {
        let bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { context in
            UIColor.clear.setFill()
            context.fill(bounds)
            var frame = self.boundingRect(with: size, context: nil)
            frame.origin.x = (size.width - frame.width) / 2
            frame.origin.y = (size.height - frame.height) / 2
            self.draw(in: frame)
        }
    }
}
