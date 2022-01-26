//
//  BSKRouteMatcher.swift
//  BSKAppCore
//
//  Created by BlueSky335 on 2018/5/23.
//  Copyright © 2018年 ChaungMiKeJi. All rights reserved.
//

import Foundation
class BSKRouteMatcher: RouteMatcher {

    var priority: Int = 500

    var routeExpression: String

    required init(routeExpression: String) {
        self.routeExpression = "^\(routeExpression)$"
    }

    func isMatch(url:URL)->Bool{
        return url.bsk.routePath.bsk.isMatch(regex: routeExpression)
    }
    
    func request(for url: URL, with routeParameters: [String : Any]?, animated:Bool, targetCallBack:TargerCallBack?) -> RouteRequest? {
        if url.bsk.routePath.bsk.isMatch(regex: routeExpression) {
            return BSKRouteRequest(url: url, queryParameters: url.bsk.queryParameters, routeParameters: routeParameters, animated: animated, targetCallBack: targetCallBack)
        }
        return nil
    }
    
}
