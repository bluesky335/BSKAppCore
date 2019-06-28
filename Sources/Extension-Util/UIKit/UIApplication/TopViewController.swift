//
//  TopViewController.swift
//  DuDuModules
//
//  Created by BlueSky335 on 2019/4/15.
//  Copyright © 2019 com.cloududu. All rights reserved.
//

import UIKit

public protocol BSKTopChildVC {
    var topChildVC: UIViewController? { get }
}

extension BSKExtension:BSKTopChildVC where Base : UIViewController {
    public var topChildVC: UIViewController? {
        return self.base.presentedViewController
    }
}

public extension BSKExtension where Base : UINavigationController {
    var topChildVC: UIViewController? {
        return self.base.topViewController
    }
}
public extension BSKExtension where Base : UITabBarController {
    var topChildVC: UIViewController? {
        return self.base.selectedViewController
    }
}


public extension BSKExtension where Base : UIApplication {
    var topViewController: UIViewController? {
        guard let rootVc = self.base.windows[0].rootViewController else { return nil }

        var resultVc = rootVc

        var controllers = [rootVc]
        while controllers.count != 0 {
            resultVc = controllers.removeFirst()

            if let topvc = resultVc.bsk.topChildVC {
                controllers.append(topvc)
            }
        }
        return resultVc
    }
}
