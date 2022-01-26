//
//  UIEdgeInsets.swift
//
//
//  Created by 刘万林 on 2021/10/19.
//

import UIKit

public extension UIEdgeInsets {
    var horizontal: CGFloat {
        return self.left + self.right
    }

    var vertical: CGFloat {
        return self.top + self.bottom
    }
}
