//
//  TopViewController.swift
//
//  Created by BlueSky335 on 2019/4/15.
//

import UIKit

public protocol BSKTopChildVC {
    var topChildVC: UIViewController? { get }
}

extension UIViewController:BSKTopChildVC {
     @objc public var topChildVC: UIViewController? {
        return self.presentedViewController
    }
}

extension UINavigationController{
    @objc override public var topChildVC: UIViewController? {
        return self.topViewController
    }
}

extension UITabBarController{
    @objc override public var topChildVC: UIViewController? {
        return self.selectedViewController
    }
}


public extension BSKExtension where Base : UIApplication {
    var topViewController: UIViewController? {
        guard let rootVc = self.base.windows[0].rootViewController else { return nil }

        var resultVc = rootVc

        var controllers = [rootVc]
        while controllers.count != 0 {
            resultVc = controllers.removeFirst()

            if let topvc = resultVc.topChildVC {
                controllers.append(topvc)
            }
        }
        return resultVc
    }
}
