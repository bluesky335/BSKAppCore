//
//  BSKScrolView.swift
//  
//
//  Created by BlueSky335 on 2023/7/28.
//

import UIKit

class BSKScrolView :UIScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delaysContentTouches = false
    }
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.delaysContentTouches = false
    }
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIButton {
            return true
        }
        return super.touchesShouldCancel(in: view)
    }
}
