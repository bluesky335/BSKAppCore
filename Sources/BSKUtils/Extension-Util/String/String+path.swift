//
//  String+path.swift
//  Alamofire
//
//  Created by 刘万林 on 2019/10/22.
//

import UIKit

public extension BSKExtension where Base == String {
    func append(path:String)->String{
        return URL(fileURLWithPath: self.base).appendingPathComponent(path).path
    }
}
