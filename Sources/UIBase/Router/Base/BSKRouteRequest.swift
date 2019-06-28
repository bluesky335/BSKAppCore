//
//  BSKRouteRequest.swift
//  BSKAppCore
//
//  Created by BlueSky335 on 2018/5/23.
//  Copyright © 2018年 ChaungMiKeJi. All rights reserved.
//

import UIKit

class BSKRouteRequest: RouteRequest {
    
    var isConsumed: Bool
    
    var url: URL
    
    let animated: Bool
    
    var queryParameters: [String : String]?
    
    var routeParameters: [String : Any]?
    
    var targetCallBack: TargerCallBack?
    
    init(url:URL, queryParameters:[String:String]? = nil, routeParameters:[String:Any]? = nil, animated:Bool, targetCallBack: TargerCallBack? = nil) {
        self.url = url
        self.isConsumed = false
        self.animated = animated
        self.queryParameters = queryParameters
        self.routeParameters = routeParameters
        self.targetCallBack = targetCallBack
    }

}
