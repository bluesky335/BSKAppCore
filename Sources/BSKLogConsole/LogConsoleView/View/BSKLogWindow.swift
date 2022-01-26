//
//  BSKLogWindow.swift
//  
//
//  Created by 刘万林 on 2021/9/15.
//

import UIKit

class BSKLogWindow: UIWindow {
    
    @available(iOS 11.0, *)
    override var safeAreaInsets: UIEdgeInsets {
        var inset = super.safeAreaInsets
        inset.top = 0
        return inset
    }
}
