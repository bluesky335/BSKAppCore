//
//  BSKRadioButton.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2019/7/31.
//  Copyright © 2019 cn.liuwanlin. All rights reserved.
//

import UIKit

open class BSKRadioButton: BSKButton {
    
    open var groupId:Int = 0
    
    override open var isSelected: Bool{
        set{
            if newValue == true, newValue != super.isSelected {
                if let mySuperView = self.superview {
                    for view in mySuperView.subviews{
                        if let v = view as? BSKRadioButton ,v != self,v.groupId == self.groupId {
                            v.isSelected = false
                        }
                    }
                }
            }
            super.isSelected = newValue
        }
        get{
            return super.isSelected
        }
    }
    
    open override func didInit(){
        self.addTarget(self, action: #selector(selectedAction(_:)), for: .touchUpInside)
    }
    
    @objc private func selectedAction(_ sender:BSKRadioButton){
        self.isSelected = true
    }
    
}
