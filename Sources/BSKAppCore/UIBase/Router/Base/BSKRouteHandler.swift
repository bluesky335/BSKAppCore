//
//  BSKRouteHandler.swift
//  BSKAppCore
//
//  Created by BlueSky335 on 2018/5/23.
//  Copyright © 2018年 ChaungMiKeJi. All rights reserved.
//

import UIKit
#if SPM
import BSKLog
#endif

open class BSKRouteHandler: NSObject, RouteHandler {
    open func shouldHandle(request: RouteRequest) -> Bool {
        return true
    }

    open func handle(request: RouteRequest, complateCallBack: (() -> Void)?) -> Bool {
        guard shouldHandle(request: request) else {
            BSKLog.warn("shouldHandle(request:) -> false")
            return false
        }

        guard let sourceRoute = source(for: request) else {
            BSKLog.warn("路由失败：sourceRoute为空")
            return false
        }

        guard let targetRoute = target(for: request) else {
            BSKLog.warn("路由失败：targetRoute为空")
            return false
        }
        targetRoute.request = request

        return show(request: request, targetRoute: targetRoute, sourceRoute: sourceRoute, complateCallBack: complateCallBack)
    }

    open func show(request: RouteRequest, targetRoute: Routeable, sourceRoute: UIViewController, complateCallBack: (() -> Void)?) -> Bool {
        switch targetRoute.preferTransition {
        case .push:
            if !targetRoute.viewController.isKind(of: UINavigationController.self) {
                var NVC: UINavigationController?
                if sourceRoute.isKind(of: UINavigationController.self) {
                    NVC = sourceRoute as? UINavigationController
                } else if sourceRoute.navigationController != nil {
                    NVC = sourceRoute.navigationController
                }
                if let qmNvc = NVC {
                    qmNvc.pushViewController(targetRoute.viewController, animated: request.animated)
                    if let callBack = complateCallBack {
                        callBack()
                        request.isConsumed = true
                    }
                } else {
                    let qmNvc = UINavigationController(rootViewController: targetRoute.viewController)
                    UIApplication.shared.bsk.topViewController?.present(qmNvc, animated: request.animated, completion: {
                        if let callBack = complateCallBack {
                            callBack()
                            request.isConsumed = true
                        }
                    })
                }
            } else {
                BSKLog.warn("The target route require “push” action, but itself is a NavigationController also !")
                return false
            }
        case .present:
            sourceRoute.present(targetRoute.viewController, animated: request.animated) {
                if let callBack = complateCallBack {
                    callBack()
                    request.isConsumed = true
                }
            }
        }
        return true
    }

    open func target(for request: RouteRequest) -> Routeable? {
        return nil
    }

    open func source(for request: RouteRequest) -> UIViewController? {
        let topvc = UIApplication.shared.bsk.topViewController
        if let nvc = topvc?.navigationController {
            return nvc
        }
        return topvc
    }
}
