//
//  CLDRoute.swift
//
//  Created by BlueSky335 on 2019/4/15.
//

import UIKit

public struct BSKRoute {
    
    static var RouteSchem:String = ""
    static var BundleID:String = ""

    /// 传递的参数,主要是一些基本数据类型的参数,传递对象类型的参数请在下面的RouteParameters配置
    public var queryParameters: [String: QueryValueProtocol]?
    
    /// 需要传递的对象类型的参数
    public var routeParameters: [String: Any]?
    
    /// 处理路由的Handler
    public let handlerType: RouteHandler.Type
    
    /// 路由路径
    public var routePath: String
    
    /// 路由匹配的正则,如果不设置则使用routePath完全匹配
    public var routeMatchRegular: String?
    
    /// 路由的优先级
    public var priority: Int = 500
    
    /// 生成用于路由的url
    public var routeURL: URL {
        var urlStr = routePath
        if let parameters = self.queryParameters {
            urlStr += parameters.bsk.urlQueryString
        }
        return URL(string: urlStr)!
    }
    
    private static let RoutePathHost = "\(RouteSchem)://\(BundleID)/"
    
    public init(routePath: String = #function, routeMatchRegular: String? = nil, handlerType: RouteHandler.Type) {
        self.handlerType = handlerType
        
        var absoluteRoutePath = BSKRoute.RoutePathHost
        
        if let path = try? routePath.bsk.replace(match: "(_:)|(:\\))|(\\))", with: "", options: []).bsk
            .replace(match: ":_", with: ":", options: []).bsk
            .replace(match: ":|\\(", with: "_", options: []) {
            absoluteRoutePath += path
        } else {
            let startIndex = routePath.startIndex
            if let endIndex = routePath.firstIndex(of: "(") {
                absoluteRoutePath += String(routePath[startIndex..<endIndex])
            } else {
                absoluteRoutePath += routePath
            }
        }
        self.routePath = absoluteRoutePath
        
        self.routeMatchRegular = routeMatchRegular
    }
    
}


public extension BSKRouter {
    @discardableResult
    static func open(_ route: BSKRoute, routeParameters: [String: Any]? = nil, animated: Bool = true, targetCallBack: TargerCallBack? = nil, complateCallBack: (() -> Void)? = nil) -> Bool {
        var dic = route.routeParameters
        
        if !(dic == nil && routeParameters == nil) { // 二者中有一个不为空时,合并routeParameters,
            if dic == nil {
                dic = routeParameters
            } else {
                if let routeDic = routeParameters {
                    for (key, value) in routeDic {
                        dic![key] = value
                    }
                }
            }
        } 
        
        if !BSKRouter.share.isRegister(route: route.routePath) {
            BSKRouter.share.register(handeler: route.handlerType, routeMatcherRegular: route.routeMatchRegular, for: route)
        }
        
        return BSKRouter.share.handel(url: route.routeURL, routeParameters: dic, animated: animated, targetCallBack: targetCallBack, complateCallBack: complateCallBack)
    }
    
    private func register(handeler: RouteHandler.Type, routeMatcherRegular: String? = nil, for Route: BSKRoute) {
        let matcher = BSKRouteMatcher(routeExpression: routeMatcherRegular ?? Route.routePath)
        matcher.priority = Route.priority
        register(handeler: handeler, matcher: matcher, for: Route.routePath)
    }
}

