//
//  TopViewController.swift
//
//  Created by BlueSky335 on 2019/4/15.
//

import UIKit

public protocol BSKTopChildVC {
    var topChildVC: UIViewController? { get }
}

extension UIViewController: BSKTopChildVC {
    @objc public var topChildVC: UIViewController? {
        return presentedViewController
    }
}

extension UINavigationController {
    @objc override public var topChildVC: UIViewController? {
        return topViewController
    }
}

extension UITabBarController {
    @objc override public var topChildVC: UIViewController? {
        return selectedViewController
    }
}

public extension BSKExtension where Base: UIApplication {
    var topViewController: UIViewController? {
        guard let rootVc = keyWindow?.rootViewController else { return nil }

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
    
    var keyWindow:UIWindow? {
        let window: UIWindow?
        if let windowScene = base.connectedScenes.compactMap({ scene in
            scene as? UIWindowScene
        }).first {
            if #available(iOS 15.0, *) {
                if windowScene.keyWindow != nil {
                    window = windowScene.keyWindow
                } else {
                    window = windowScene.windows.first(where: { $0.isKeyWindow }) ?? windowScene.windows.first
                }
            } else {
                window = windowScene.windows.first(where: { $0.isKeyWindow }) ?? windowScene.windows.first
            }
        } else {
            window = base.delegate?.window ?? nil
        }
        return window
    }
}
