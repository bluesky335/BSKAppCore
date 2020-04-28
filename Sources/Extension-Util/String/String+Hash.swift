//
//  String+Hash.swift
//  BSKToolBox-Swift
//
//  Created by BlueSky335 on 2018/4/26.
//  Copyright © 2018年 LiuWanLin. All rights reserved.
//

import Foundation
import CommonCrypto

extension BSKExtension:HashAble where Base == String {
    public var hashData: Data{
        return self.base.data(using: .utf8) ?? Data()
    }
}
