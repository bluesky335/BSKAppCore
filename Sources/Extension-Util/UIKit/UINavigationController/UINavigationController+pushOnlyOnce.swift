//
//  UINavigationController+pushOnlyOnce.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2019/6/28.
//  Copyright © 2019 cn.liuwanlin. All rights reserved.
//

import UIKit

public protocol UINavigationControllerPushOnlyOnce {
    func isSame(Controller:UIViewController)->Bool
}

extension BSKExtension where Base:UINavigationController{
    public func pushOnlyOnce<T>(viewController:T ,animated:Bool = true) where T:UIViewController & UINavigationControllerPushOnlyOnce {
        var vcs = self.base.viewControllers
//        TODO: not complete
        for itemVc in vcs {
            if let vc = itemVc as? UINavigationControllerPushOnlyOnce {
                vc.isSame(Controller: viewController)
            }
        }
        
    }
    

}
