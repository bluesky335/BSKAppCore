//
//  BSKRouterProtocols.swift
//  BSKAppCore
//
//  Created by BlueSky335 on 2018/5/22.
//  Copyright © 2018年 ChaungMiKeJi. All rights reserved.
//

import Foundation
import UIKit
#if SPM
import BSKUtils
#endif

public typealias TargerCallBack = ((_ error:Error? ,_ responseObjecte:Any?)->Void)

public enum RouteTransitionType {
    case present
    case push
}


/// 可路由的UIViewController
public protocol Routeable:AnyObject {
    ///    用于展现这个Controller的路由请求,可以通过它的 targetCallBack属性为路由发起者提供回调回传错误或者返回结果
    var request:RouteRequest!{get set}
    ///    返回用于展示的ViewController
    var viewController:UIViewController{get}
    ///    偏好的界面展现方式,push 或者 present
    var preferTransition:RouteTransitionType{get}
}


/// 路由器
public protocol Router {

    /// 路由这个URL
    ///
    /// - Parameters:
    ///   - url: 路由请求URL
    ///   - routeParameters: 额外的路由参数
    ///   - animated: 是否显示动画
    ///   - targetCallBack: 目标页面的回调
    ///   - complateCallBack: 路由完成的回调
    /// - Returns: 是否完成路由
    /// - Throws: 路由过程中出现错误
    func handel(url:URL,
                routeParameters:[String:Any]?,
                animated:Bool,
                targetCallBack:TargerCallBack?,
                complateCallBack:(()->Void)?
        ) throws -> Bool
    
    /// 为一个路由路径注册Handler
    ///
    /// - Parameters:
    ///   - handeler: 处理路由的Handler
    ///   - matcher: 匹配路由的路由检查器
    ///   - Route: 路由路径
    func register(handeler:RouteHandler.Type,matcher:RouteMatcher?,for Route:String) -> Void
    
    /// 是否可以路由这个URL
    ///
    /// - Parameter url: 路由请求的URL
    /// - Returns: 是否可以路由
    func canHandel(url:URL) -> Bool
    
}


/// 处理具体的界面转换
public protocol RouteHandler:NSObject {
    
    /// 是否可以路由这个路由请求
    ///
    /// - Parameter request: 路由请求
    /// - Returns: 是否可以路由
    func shouldHandle(request:RouteRequest) -> Bool
    
    /// 处理URL请求，打开新的页面，如果成功返回true 并在完成时调用CallBack将request的isConsumed设置为true，否则返回false
    ///
    /// - Parameters:
    ///   - request: 请求
    ///   - complateCallBack: 回调
    /// - Returns: 是否成功
    func handle(request:RouteRequest, complateCallBack:(()->Void)?) -> Bool

    /// 提供即将被显示的页面
    ///
    /// - Parameter request: 路由请求
    /// - Returns: 返回即将显示的页面,返回空表示路由失败
    func target(for request:RouteRequest) -> Routeable?
    
    /// 提供推出将要显示的页面的来源页面,
    ///
    /// - Parameter request: 路由请求
    /// - Returns: 来源页面
    func source(for request:RouteRequest) -> UIViewController?
    
}


/// 路由请求
public protocol RouteRequest:AnyObject {
//    这个请求是否被处理了
    var isConsumed:Bool{get set}
//    是否展示动画
    var animated:Bool{get}
//    路由的url路径
    var url:URL{get set}
//    url中的参数
    var queryParameters:[String:String]?{get set}
//    额外的路由参数
    var routeParameters:[String:Any]?{get set}
//    回调
    var targetCallBack:TargerCallBack?{get set}
    
}


/// 路由检查器
public protocol RouteMatcher:AnyObject {

    var priority:Int {get}//优先级,当有多个RouteMatcher匹配到时,按照优先级高的路由


    /// 是否匹配这个url
    ///
    /// - Parameter url: 匹配的url
    /// - Returns: 是否匹配
    func isMatch(url:URL)->Bool
    /// 为一个URL生成路由请求RouteRequest,
    ///
    /// - Parameters:
    ///   - url: 路由url路径
    ///   - routeParameters: 额外的路由参数
    ///   - animated: 是否展示动画
    ///   - targetCallBack: 回调
    /// - Returns: 如果支持该URL的路由则返回一个RouteRequest,否则返回nil
    func request(for url:URL, with  routeParameters:[String:Any]?, animated:Bool, targetCallBack:TargerCallBack?) -> RouteRequest?
}

///extensions


public extension BSKExtension where Base == URL{
    
    var routePath:String{
        var path = self.base.absoluteString
        if let query = self.base.query {
            if let range = path.range(of: query){
                let index = path.index(before: range.lowerBound)
                path = String(path[..<index])
            }
        }
        return path
    }
}
