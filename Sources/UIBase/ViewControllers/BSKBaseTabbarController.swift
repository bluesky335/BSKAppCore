//
//  BSKBaseTabbarController.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2019/6/28.
//  Copyright © 2019 cn.liuwanlin. All rights reserved.
//

import UIKit

open class BSKBaseTabbarController: UITabBarController, Routeable {
    //    MARK: - ● Routeable

    open var request: RouteRequest!

    open var viewController: UIViewController {
        return self
    }

    open var preferTransition: RouteTransitionType {
        return .push
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return self.selectedViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return self.selectedViewController?.preferredInterfaceOrientationForPresentation ?? super.preferredInterfaceOrientationForPresentation
    }

    override open var navigationItem: UINavigationItem {
        if let vc = self.selectedViewController {
            return vc.navigationItem
        }
        return super.navigationItem
    }
}
