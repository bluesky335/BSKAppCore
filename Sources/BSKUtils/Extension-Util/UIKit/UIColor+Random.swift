//
//  UIColor+Random.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2019/6/28.
//  Copyright © 2019 cn.liuwanlin. All rights reserved.
//

import UIKit

public extension UIColor{
    
    /// 随机的获取一个颜色
   static var random:UIColor{
        return UIColor(red: CGFloat.random(in: 0...1) , green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
    }
}
