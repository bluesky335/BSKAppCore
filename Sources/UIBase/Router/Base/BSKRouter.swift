//
//  BSKRouter.swift
//  BSKAppCore
//
//  Created by BlueSky335 on 2018/5/22.
//  Copyright © 2018年 ChaungMiKeJi. All rights reserved.
//

import Foundation


public class BSKRouter:Router{

    public typealias RouteName = String
    
    private var handlers = [RouteName:RouteHandler.Type]()
    
    private var matchers = [RouteName:RouteMatcher]()
    
    static let share = BSKRouter()
    
    
    private init(){}
    
    public func handel(url: URL, routeParameters: [String : Any]?, animated: Bool, targetCallBack:TargerCallBack?, complateCallBack:(() -> Void)?)  -> Bool {

        var usableMatcher:(RouteName,RouteMatcher)? = nil

        for (route,matcher) in matchers {
            if matcher.isMatch(url: url),(usableMatcher == nil || usableMatcher!.1.priority < matcher.priority){
                usableMatcher = (route,matcher)
            }
        }

        if let (route,matcher)  = usableMatcher , let request = matcher.request(for: url, with: nil,animated:animated, targetCallBack: targetCallBack){
            request.routeParameters = routeParameters
            return  handel(route: route, request: request, targetCallBack: targetCallBack, complateCallBack:complateCallBack)
        }

        return false
    }
    
    func handel(route:RouteName, request:RouteRequest, targetCallBack:TargerCallBack?, complateCallBack:(()->Void)?)  -> Bool {
        if let handlerType = handlers[route]{
            let handler = handlerType.init()
            if handler.shouldHandle(request: request) {
                return handler.handle(request: request,complateCallBack: complateCallBack)
            }
        }
        return false
    }
    
    public func register(handeler: RouteHandler.Type,matcher:RouteMatcher? = nil, for Route: RouteName) {
        handlers[Route] = handeler
        if let amatcher = matcher {
            matchers[Route] = amatcher
        }else{
            matchers[Route] = BSKRouteMatcher(routeExpression: Route)
        }
    }

    func isRegister(route:RouteName) -> Bool {
        return handlers.keys.contains(route)
    }
    
    public func canHandel(url: URL) -> Bool {
        for (_,matcher) in matchers {
            let request = matcher.request(for: url, with: nil, animated: true, targetCallBack: nil)
            if request != nil {
                return true
            }
        }
        return false
    }
    
}


