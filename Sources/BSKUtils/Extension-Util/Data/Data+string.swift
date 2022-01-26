//
//  Data+string.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2019/8/29.
//  Copyright © 2019 cn.liuwanlin. All rights reserved.
//

import UIKit

public extension BSKExtension where Base == Data{
    
    /// 转十进制字符串
    var hexString:String{
        let bytes = [UInt8](self.base)
        var str = ""
        for byte in bytes {
            let v = String(format:"%02x",byte)
            str+=v
        }
        return str
    }
}
