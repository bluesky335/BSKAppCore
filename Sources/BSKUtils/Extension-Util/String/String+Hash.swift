//
//  String+Hash.swift
//  
//
//  Created by BlueSky335 on 2018/4/26.
//  Copyright © 2018年 LiuWanLin. All rights reserved.
//

import Foundation
import CommonCrypto

extension BSKExtension: Equatable where  Base == String {
    public static func == (lhs: BSKExtension<Base>, rhs: BSKExtension<Base>) -> Bool {
        return lhs.base == rhs.base
    }
}

extension BSKExtension:Hashable where Base == String {
    public func hash(into hasher: inout Hasher) {
        return self.base.hash(into: &hasher)
    }
}
