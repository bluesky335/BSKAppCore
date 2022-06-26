//
//  BSKNavigationController.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2021/10/11.
//

import UIKit

/// 基础导航控制器
/// 提供返回手势拦截控制等功能
open class BSKNavigationController: UINavigationController {
    /// 协议代理，将代理事件分发到多个地方
    private var delegateProxy = ProxyUINavigationControllerDelegate()

    /// 将要push出来的controller
    private var pushComplateCallBack: [Int: () -> Void] = [:]
    /// 将要pop的controller
    private var popComplateCallBack: [Int: (Bool) -> Void] = [:]

    override open func viewDidLoad() {
        super.viewDidLoad()
        delegateProxy.redirectDelegate = self
        delegateProxy.delegate = delegate
        delegate = delegateProxy
        interactivePopGestureRecognizer?.delegate = self
    }

    override open func popViewController(animated: Bool) -> UIViewController? {
        let shouldPop = topViewController?.shouldPopBack() ?? true
        if shouldPop {
            // 只有当允许返回时才可以pop返回
            return super.popViewController(animated: animated)
        } else {
            // 通知已经阻止返回
            (topViewController)?.didRejectPopBack()
        }
        return nil
    }

    override open func popToRootViewController(animated: Bool) -> [UIViewController]? {
        let shouldPop = topViewController?.shouldPopBack() ?? true
        if shouldPop {
            // 只有当允许返回时才可以pop返回
            return super.popToRootViewController(animated: animated)
        } else {
            // 通知已经阻止返回
            topViewController?.didRejectPopBack()
        }
        return nil
    }

    override open func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        let shouldPop = topViewController?.shouldPopBack() ?? true
        if shouldPop {
            // 只有当允许返回时才可以pop返回
            return super.popToViewController(viewController, animated: animated)
        } else {
            // 通知已经阻止返回
            topViewController?.didRejectPopBack()
        }
        return nil
    }

    /// pop返回
    /// - Parameters:
    ///   - animated: 是否动画
    ///   - complate: 完成回调，参数表示是否成功
    /// - Returns: 已经弹出栈的控制器
    @discardableResult open func popViewController(animated: Bool, complate: @escaping (Bool) -> Void) -> UIViewController? {
        guard let vc = popViewController(animated: animated) else {
            complate(false)
            return nil
        }
        guard let topVc = topViewController else {
            complate(true)
            return vc
        }
        if !animated {
            complate(true)
        } else {
            popComplateCallBack[topVc.hash] = complate
        }
        return vc
    }

    /// pop返回到根控制器
    /// - Parameters:
    ///   - animated: 是否动画
    ///   - complate: 完成回调，参数表示是否成功
    /// - Returns: 已经弹出栈的控制器
    @discardableResult open func popToRootViewController(animated: Bool, complate: @escaping (Bool) -> Void) -> [UIViewController]? {
        guard let vcs = popToRootViewController(animated: animated) else {
            complate(false)
            return nil
        }
        guard let topVc = topViewController else {
            complate(true)
            return vcs
        }
        if !animated {
            complate(true)
        } else {
            popComplateCallBack[topVc.hash] = complate
        }
        return vcs
    }

    /// pop返回到指定控制器
    /// - Parameters:
    ///   - viewController: 返回到指定控制器
    ///   - animated: 是否动画
    ///   - complate: 完成回调，参数表示是否成功
    /// - Returns: 已经弹出栈的控制器
    @discardableResult open func popToViewController(_ viewController: UIViewController, animated: Bool, complate: @escaping (Bool) -> Void) -> [UIViewController]? {
        guard let vcs = popToViewController(viewController, animated: animated) else {
            complate(false)
            return nil
        }
        guard let topVc = topViewController else {
            complate(true)
            return vcs
        }
        if !animated {
            complate(true)
        } else {
            popComplateCallBack[topVc.hash] = complate
        }
        return vcs
    }

    override open var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }

    override open var childForStatusBarHidden: UIViewController? {
        return topViewController
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.topViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }

    open func pushViewController(_ viewController: UIViewController, animated: Bool, complate: @escaping () -> Void) {
        pushViewController(viewController, animated: animated)
        if !animated {
            complate()
        } else {
            pushComplateCallBack[viewController.hash] = complate
        }
    }
}

/// 手势控制
extension BSKNavigationController: UIGestureRecognizerDelegate {
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard viewControllers.count > 1 else {
            // 只有当controllers 数量大于1 的时候才可以识别
            return false
        }
        let gesture = topViewController?.shouldStartNavigationPopGesture() ?? true
        let shouldPop = topViewController?.shouldPopBack() ?? true
        let shoudBegin = gesture && shouldPop
        // 只有当允许手势且允许pop返回时才可以开始返回手势
        if !shoudBegin {
            // 通知已经阻止返回
            topViewController?.didRejectPopBack()
        }
        return shoudBegin
    }

    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return topViewController?.shouldPopGesture(gestureRecognizer, failedByOther: otherGestureRecognizer) ?? false
    }

    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return topViewController?.shouldPopGesture(gestureRecognizer, requireOtherToFail: otherGestureRecognizer) ?? true
    }
}

extension BSKNavigationController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        setNavigationBarHidden(!viewController.shouldShowNavigationBar(), animated: animated)
        setToolbarHidden(!viewController.shouldShowToolBar(), animated: animated)
    }

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        let hash = viewController.hash
        if let complate = pushComplateCallBack[hash] {
            complate()
            pushComplateCallBack.removeValue(forKey: hash)
        }
        if let complate = popComplateCallBack[hash] {
            complate(true)
            popComplateCallBack.removeValue(forKey: hash)
        }
        viewControllers.removeAll { [weak self] vc in
            return vc.removeSelfAfterPush() && vc != self?.topViewController
        }
    }
}

extension UIViewController {
    /// 如果当前Controller位于 MCFNavigationController 中时有值，否则返回nil
    public var mcfNavigationController: BSKNavigationController? {
        return navigationController as? BSKNavigationController
    }

    /// 是否打开导航控制器的pop返回手势
    /// - Returns: true 允许手势返回，false禁用手势返回
    @objc open func shouldStartNavigationPopGesture() -> Bool {
        return true
    }

    /// 当有其他手势被识别时，pop返回手势是否应该失败
    /// - Parameters:
    ///   - popGesture: pop返回手势
    ///   - other: 另一个手势
    /// - Returns: 返回 true，则pop返回手势失败，返回 false，则pop返回手势成功
    @objc open func shouldPopGesture(_ popGesture: UIGestureRecognizer, failedByOther other: UIGestureRecognizer) -> Bool {
        return false
    }

    /// 当有其他手势被识别时，是否应该要求其他手势失败
    /// - Parameters:
    ///   - popGesture: pop返回手势
    ///   - other: 另一个手势
    /// - Returns:  返回 true ，则其他手势失败，pop返回手势成功，返回 false ，则其他手势被识别
    @objc open func shouldPopGesture(_ popGesture: UIGestureRecognizer, requireOtherToFail other: UIGestureRecognizer) -> Bool {
        return true
    }

    /// 是否可以pop返回（包括手势、点击返回按钮和代码调用返回）
    /// - Returns: 如果返回false，不管是手势还是代码调用pop相关方法，pop返回都将会被阻止。
    @objc open func shouldPopBack() -> Bool {
        return true
    }

    /// 已经阻止了pop返回，当pop返回被阻止后会调用这个方法通知当前栈顶ViewController返回已被阻止
    @objc open func didRejectPopBack() {}

    /// 控制当前controller被push出来或从其他页面pop回来时是否显示导航栏
    /// - Returns: true 显示导航栏，false 不显示导航栏
    @objc open func shouldShowNavigationBar() -> Bool {
        return true
    }

    /// 控制当前controller被push出来或从其他页面pop回来时是否显示导航栏
    /// - Returns: true 显示导航栏，false 不显示导航栏
    @objc open func shouldShowToolBar() -> Bool {
        return false
    }

    /// 在push出新控制器后把自己从导航控制器的历史中移除，默认为false
    /// 需要配合
    /// - Returns: 是否移除
    @objc open func removeSelfAfterPush() -> Bool {
        return false
    }
}

/// 转发代理，使其可以设置两个代理，最终返回值以 delegate 优先级更高
private class ProxyUINavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    weak var delegate: UINavigationControllerDelegate?
    weak var redirectDelegate: UINavigationControllerDelegate?

    private var delegates: [UINavigationControllerDelegate] {
        var array: [UINavigationControllerDelegate] = []
        if let redirectDelegate = redirectDelegate {
            array.append(redirectDelegate)
        }
        if let delegate = delegate {
            array.append(delegate)
        }
        return array
    }

    @available(iOS 2.0, *)
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        for item in delegates {
            item.navigationController?(navigationController, willShow: viewController, animated: animated)
        }
    }

    @available(iOS 2.0, *)
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        for item in delegates {
            item.navigationController?(navigationController, didShow: viewController, animated: animated)
        }
    }

    @available(iOS 7.0, *)
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        var result: UIInterfaceOrientationMask = .all
        for item in delegates {
            result = item.navigationControllerSupportedInterfaceOrientations?(navigationController) ?? result
        }
        return result
    }

    @available(iOS 7.0, *)
    func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
        var result: UIInterfaceOrientation = .portrait

        for item in delegates {
            result = item.navigationControllerPreferredInterfaceOrientationForPresentation?(navigationController) ?? result
        }

        return result
    }

    @available(iOS 7.0, *)
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        var result: UIViewControllerInteractiveTransitioning?

        for item in delegates {
            result = item.navigationController?(navigationController, interactionControllerFor: animationController)
        }
        return result
    }

    @available(iOS 7.0, *)
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var result: UIViewControllerAnimatedTransitioning?
        for item in delegates {
            result = item.navigationController?(navigationController, animationControllerFor: operation, from: fromVC, to: toVC)
        }
        return result
    }
}
