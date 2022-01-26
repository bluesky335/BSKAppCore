//
//  URL.swift
//  BSKToolBox-Swift
//
//  Created by BlueSky335 on 2018/5/23.
//  Copyright © 2018年 LiuWanLin. All rights reserved.
//

import Foundation

extension BSKExtension where Base == URL {
    
   public var queryParameters:[String:String]?{
        guard let query = self.base.query else {return nil}
        let parametersArray = query.split(separator: "&").map{String($0)}.map{$0.split(separator: "=").map{String($0)}}
        var parameters = [String:String]()
        for str in parametersArray {
            if str.count>1 {
                if let key = str[0].removingPercentEncoding,let value = str[1].removingPercentEncoding{
                    parameters[key] = value
                }
            }else if str.count>0{
                if let key = str[0].removingPercentEncoding {
                    parameters[key] = ""
                }
            }
        }
        return parameters
    }
    
}
