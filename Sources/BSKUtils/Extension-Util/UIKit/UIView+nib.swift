//
//  File.swift
//  
//
//  Created by 刘万林 on 2022/2/20.
//

import UIKit

public extension UIView {
    
    /// 从mainbundle中与当前类同名的xib加载视图
    /// - Returns: 视图对象
    static func loadFromNib() -> Self? {
        return loadFromNib(name: nil, bundle: nil)
    }
    
    /// 从指定的xib加载视图
    /// - Parameters:
    ///   - name: xib文件名
    ///   - bundle: bundle
    /// - Returns: 视图对象
    static func loadFromNib(name: String?, bundle: Bundle?) -> Self? {
        let nibName = name ?? "\(Self.self)"
        let view = UINib(nibName: nibName, bundle: bundle).instantiate(withOwner: nil, options: nil).first as? Self
        return view
    }
}
