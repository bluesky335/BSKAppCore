//
//  UIButton+border.swift
//  DuDuModules
//
//  Created by BlueSky335 on 2019/4/15.
//  Copyright © 2019 com.cloududu. All rights reserved.
//

import UIKit

public extension UIView{
    
     var cornerRadius:CGFloat {
        get{
            return self.layer.cornerRadius
        }
        set{
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = newValue != 0
        }
    }
    var borderWidth:CGFloat {
        get{
            return self.layer.borderWidth
        }
        set{
            self.layer.borderWidth = newValue
        }
    }
    
    
    var borderColor:UIColor? {
        get{
            if let color = self.layer.borderColor {
                return UIColor(cgColor:color)
            }else{
                return nil
            }
        }
        set{
            self.layer.borderColor = newValue?.cgColor
        }
    }
}
