//
//  String+URL.swift
//  BSKToolBox-Swift
//
//  Created by BlueSky335 on 2018/4/26.
//  Copyright © 2018年 LiuWanLin. All rights reserved.
//

import Foundation

public extension BSKExtension where Base == String 
{
    var toURL:URL?{
        return URL(string: self.base)
    }

    var toHttpsURL:URL?{
        return URL(string: self.base.replacingOccurrences(of: "http://", with: "https://"))
    }

}
