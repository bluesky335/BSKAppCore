//
//  UIEdgeInsets.swift
//
//
//  Created by 刘万林 on 2021/10/19.
//

import UIKit

public extension UIEdgeInsets {
    /// 横向的值，left+right
    var horizontal: CGFloat {
        return left + right
    }

    /// 纵向的值，top+bottom
    var vertical: CGFloat {
        return top + bottom
    }
}
