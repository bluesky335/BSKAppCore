//
//  InsetLabel.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2021/4/14.
//

import UIKit

open class BSKInsetLabel: UILabel {

    open var contentInsets:UIEdgeInsets = .zero {
        didSet {
            self.superview?.setNeedsLayout()
            self.setNeedsDisplay()
            self.invalidateIntrinsicContentSize()
        }
    }
    
    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: self.contentInsets))
    }

    open override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += self.contentInsets.left + self.contentInsets.right
        size.height += self.contentInsets.top + self.contentInsets.bottom
        return size
    }
    
}
