//
//  UIImage+FramworkResource.swift
//  
//
//  Created by 刘万林 on 2021/9/7.
//

import UIKit

fileprivate var framworkBudle: Bundle?  {
    #if SPM
    return Bundle.module
    #else
    return Bundle(for: BSKLog.self)
    #endif
}

extension UIImage {
    convenience init?(inFramwork name: String) {
        
        self.init(named: name, in: framworkBudle, compatibleWith: nil)
    }
}
