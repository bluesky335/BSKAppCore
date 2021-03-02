//
//  String+path.swift
//  Alamofire
//
//  Created by 刘万林 on 2019/10/22.
//

import UIKit

public extension BSKExtension where Base == String {
    func AddPath(str:String ,separator:String = "/")->String{
        
        if self.base.hasSuffix(separator) != str.hasPrefix(separator) {
            return self.base + str
        }
        
        if self.base.hasSuffix(separator) && str.hasPrefix(separator) {
            return self.base + str.bsk[separator.count...]
        }
        
        return self.base + separator + str
    }
}
