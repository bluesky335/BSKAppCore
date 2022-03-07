//
//  PopControllerAnimation.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2021/12/1.
//

import UIKit

/// 需要支持弹窗形式显示的 UIView 或者 UIViewController 的子类需要实现此协议
public protocol PopupableType {
    /// 弹窗样式配置
    var popupConfig: PopupConfig { get }
    /// 即将被手势隐藏时调用，包括滑动手势和点击遮罩视图。返回false阻止手势隐藏。
    /// - Returns: 返回一个Bool决定是否允许dismiss操作,默认返回true
    func popupControllerWillDismissByGesture() -> Bool
}

public extension PopupableType {
    /// 默认返回true
    func popupControllerWillDismissByGesture() -> Bool { true }
}

extension UIViewController {
    private static var popupControllerKey = "PopupControllerKey"

    private var popupController: PopupController? {
        set {
            objc_setAssociatedObject(self, &UIViewController.popupControllerKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            objc_getAssociatedObject(self, &UIViewController.popupControllerKey) as? PopupController
        }
    }

    /// 显示弹窗
    /// - Parameters:
    ///   - viewControllerToPresent: 要显示的控制器
    ///   - config: 弹窗配置
    ///   - completion: 完成回调
    public func popupPresent<ViewControllerType>(_ viewControllerToPresent: ViewControllerType, animated: Bool, completion: (() -> Void)?) where ViewControllerType: UIViewController, ViewControllerType: PopupableType {
        let popupController = PopupController(viewController: viewControllerToPresent, config: viewControllerToPresent.popupConfig)
        viewControllerToPresent.modalPresentationStyle = .custom
        viewControllerToPresent.popupController = popupController
        viewControllerToPresent.transitioningDelegate = popupController
        present(viewControllerToPresent, animated: animated, completion: completion)
    }

    /// 显示弹窗
    /// - Parameters:
    ///   - viewControllerToPresent: 要显示的视图
    ///   - config: 弹窗配置
    ///   - completion: 完成回调
    public func popupPresent<ViewType>(_ viewToPresent: ViewType, animated: Bool, completion: (() -> Void)?) where ViewType: UIView, ViewType: PopupableType {
        let vc = PopupViewController<ViewType>(popupView: viewToPresent)
        popupPresent(vc, animated: animated, completion: completion)
    }
}

/// 弹窗位置布局配置
public enum PopupLayout {
    /// 如果size 为 nil 将会调用 view.systemLayoutSizeFitting方法计算大小
    case fullscreen
    case center(size: CGSize? = nil)
    case topLeft(size: CGSize? = nil)
    case topCenter(size: CGSize? = nil)
    case topRight(size: CGSize? = nil)
    case bottomLeft(size: CGSize? = nil)
    case bottomCenter(size: CGSize? = nil)
    case bottomRight(size: CGSize? = nil)
    case leftCenter(size: CGSize? = nil)
    case rightCenter(size: CGSize? = nil)
    case custom(frame: CGRect) // 自定义位置和大小
}

/// 弹窗配置
public struct PopupConfig {
    /// 弹出布局，默认 .center(size: nil)
    public var layout: PopupLayout = .center(size: nil)
    /// 弹出视图与屏幕边缘的边距，当layout 为 custom 时无效，默认为0
    public var contentInset: UIEdgeInsets = .zero
    /// 是否填充安全区域，当layout 为 custom 时无效，默认true
    public var fillSafeArea = true
    /// 是否打开点击遮罩区域来隐藏视图，默认false
    public var allowDismissByTapDimmingView: Bool = true
    /// 是否允许使用滑动手势来隐藏视图默认false
    public var allowDismissByPanGesture: Bool = true

    /// dismiss动画参数
    public var animationForDismiss: PopControllerAnimation.Animation = .init(duration: 0.3, type: .fade, options: [.curveLinear])
    
    /// dismiss手势动画参数
    public var animationForDismissByGesture: PopControllerAnimation.Animation?

    /// present动画参数
    public var animationForPresent: PopControllerAnimation.Animation = .init(duration: 0.3, type: .enlarge, options: [.curveEaseInOut])

    /// 自定义遮罩视图，默认为透明度为0.3的黑色UIView
    /// 可以是任何UIView的子类,设置为nil即为不显示遮罩视图，此时不会遮挡父级控制器，父级控制器可操作。
    /// 如果既要不显示遮罩，又要父级控制器不可点击，清设置为透明度为0的UIView
    public var dimmingView: UIView? = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.3)
        return view
    }()

    public init() {}
}

/// 用于弹出UIView的控制器
private class PopupViewController<ViewType>: UIViewController, PopupableType where ViewType: PopupableType, ViewType: UIView {
    var popupView: ViewType

    var popupConfig: PopupConfig {
        return popupView.popupConfig
    }

    init(popupView: ViewType) {
        self.popupView = popupView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(popupView)
        popupView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func popupControllerWillDismissByGesture() -> Bool {
        return popupView.popupControllerWillDismissByGesture()
    }
}

/// 弹窗控制
class PopupController: NSObject {
    let config: PopupConfig

    // MARK: 私有属性

    private var viewController: UIViewController
    private var dismissedAnimation: PopControllerAnimation
    private var dismissByGestureAnimation: PopControllerAnimation?
    private var presentedAnimation: PopControllerAnimation

    private var isInGesture = false
    private var panGesture: UIPanGestureRecognizer?
    private var interactionController: UIPercentDrivenInteractiveTransition?
    private var gesturePercentCurrentDenominator: CGFloat = 1

    init(viewController: UIViewController, config: PopupConfig) {
        self.viewController = viewController
        dismissedAnimation = .init(animation: config.animationForDismiss, direction: .dismiss)
        if let animation = config.animationForDismissByGesture {
            dismissByGestureAnimation = .init(animation: animation, direction: .dismiss)
        }
        presentedAnimation = .init(animation: config.animationForPresent, direction: .present)
        self.config = config
        super.init()
    }

    private func setupInteractionDismiss() {
        guard config.allowDismissByPanGesture else {
            if let gesture = panGesture {
                gesture.isEnabled = false
                viewController.view.removeGestureRecognizer(gesture)
                panGesture = nil
            }
            interactionController = nil
            return
        }
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(dismissPangestureAction(_:)))
        gesture.delegate = self
        panGesture = gesture
        interactionController = UIPercentDrivenInteractiveTransition()
        interactionController?.completionSpeed = 0.7
        viewController.view.addGestureRecognizer(gesture)
    }

    @objc private func dismissPangestureAction(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            isInGesture = true
            gesturePercentCurrentDenominator = { () -> CGFloat in
                switch self.dismissedAnimation.animationParameters.type {
                case .left:
                    return self.viewController.view.frame.maxX
                case .right:
                    return (self.viewController.view.window?.frame.width ?? 0) - self.viewController.view.frame.minX
                case .flowFromTop: fallthrough
                case .top:
                    return self.viewController.view.frame.maxY
                case .shrink: fallthrough
                case .fade: fallthrough
                case .enlarge: fallthrough
                case .flowFromBottom: fallthrough
                case .bottom:
                    return ((self.viewController.view.window?.frame.height ?? 0) - self.viewController.view.frame.minY)
                }
            }()
            viewController.dismiss(animated: true, completion: nil)
        } else if gesture.state == .changed {
            let trans = gesture.translation(in: viewController.view.window)
            let molecular = { () -> CGFloat in
                switch self.dismissedAnimation.animationParameters.type {
                case .left:
                    return trans.x > 0 ? 0 : abs(trans.x)
                case .right:
                    return trans.x < 0 ? 0 : trans.x
                case .flowFromTop: fallthrough
                case .top:
                    return trans.y > 0 ? 0 : abs(trans.y)
                case .shrink: fallthrough
                case .fade: fallthrough
                case .enlarge: fallthrough
                case .flowFromBottom: fallthrough
                case .bottom:
                    return trans.y < 0 ? 0 : trans.y
                }
            }()
            interactionController?.update(max(0, min(1, molecular / gesturePercentCurrentDenominator)))
        } else {
            var shouldFinish = false
            if (interactionController?.percentComplete ?? 0) > 0.5 {
                shouldFinish = true
            } else {
                let v = gesture.velocity(in: viewController.view)
                shouldFinish = { () -> Bool in
                    switch self.dismissedAnimation.animationParameters.type {
                    case .left:
                        return v.x < -20
                    case .right:
                        return v.x > 20
                    case .flowFromTop: fallthrough
                    case .top:
                        return v.y < -20
                    case .shrink: fallthrough
                    case .fade: fallthrough
                    case .flowFromBottom: fallthrough
                    case .enlarge: fallthrough
                    case .bottom:
                        return v.y > 20
                    }
                }()
            }

            if shouldFinish, let popupable = viewController as? PopupableType, popupable.popupControllerWillDismissByGesture() {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            isInGesture = false
        }
    }
}

extension PopupController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gesture = gestureRecognizer as? UIPanGestureRecognizer, gesture == panGesture else {
            return false
        }
        let trans = gesture.translation(in: viewController.view)
        switch dismissedAnimation.animationParameters.type {
        case .left:
            return trans.x < 0
        case .right:
            return trans.x > 0
        case .flowFromTop: fallthrough
        case .top:
            return trans.y < 0
        case .shrink: fallthrough
        case .enlarge: fallthrough
        case .fade: fallthrough
        case .flowFromBottom: fallthrough
        case .bottom:
            return trans.y > 0
        }
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gesture = gestureRecognizer as? UIPanGestureRecognizer, gesture == panGesture else {
            return false
        }
        guard let otherView = otherGestureRecognizer.view as? UIScrollView,
              otherView.bounces == false,
              self.viewController.view.subviews.contains(otherView) else {
            return false
        }
        switch self.dismissedAnimation.animationParameters.type {
        case .left:
            return otherView.contentOffset.x == otherView.contentSize.width - otherView.frame.width
        case .right:
            return otherView.contentOffset.x == 0
        case .flowFromTop: fallthrough
        case .top:
            return otherView.contentOffset.y == otherView.contentSize.height - otherView.frame.height
        case .shrink: fallthrough
        case .enlarge: fallthrough
        case .fade: fallthrough
        case .flowFromBottom: fallthrough
        case .bottom:
            return otherView.contentOffset.y == 0
        }
    }
}

extension PopupController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let controller = PopPresentationController(presentedViewController: presented, presenting: presenting)
        controller.layout = config.layout
        controller.contentInset = config.contentInset
        controller.fillSafeArea = config.fillSafeArea
        controller.dimmingView = config.dimmingView
        setupInteractionDismiss()
        if config.allowDismissByTapDimmingView {
            controller.dismissDimmingViewTapGesture.isEnabled = config.allowDismissByTapDimmingView
        }
        return controller
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return isInGesture ? dismissByGestureAnimation ?? dismissedAnimation : dismissedAnimation
    }

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentedAnimation
    }

    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return isInGesture ? interactionController : nil
    }
}

// MARK: - PopPresentationController

private class PopPresentationController: UIPresentationController {
    fileprivate var dimmingView: UIView?

    /// 点击遮罩取消弹窗，默认关闭，将它的isEnable设为true启用
    private(set) lazy var dismissDimmingViewTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissDimmingViewTapGestureAction))
        dimmingView?.addGestureRecognizer(gesture)
        return gesture
    }()

    /// 布局
    open var layout: PopupLayout = .center(size: nil)
    /// 是否填充安全区域，当layout 为 custom 时无效
    open var fillSafeArea = false
    /// 内容边距，当layout 为 custom 时无效
    open var contentInset = UIEdgeInsets(top: 16, left: 50, bottom: 16, right: 50)

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    override open func presentationTransitionWillBegin() {
        guard let containerView = self.containerView else {
            return
        }
        if let dimmingView = self.dimmingView {
            dimmingView.translatesAutoresizingMaskIntoConstraints = false
            containerView.insertSubview(dimmingView, at: 0)
            dimmingView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
            dimmingView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
            dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true

            if let efectView = dimmingView as? UIVisualEffectView {
                let efect = efectView.effect
                efectView.effect = nil
                guard let coordinator = presentedViewController.transitionCoordinator else {
                    efectView.effect = efect
                    return
                }
                coordinator.animate(alongsideTransition: { _ in
                    efectView.effect = efect
                })
            } else {
                dimmingView.alpha = 0
                guard let coordinator = presentedViewController.transitionCoordinator else {
                    dimmingView.alpha = 1.0
                    return
                }
                coordinator.animate(alongsideTransition: { _ in
                    dimmingView.alpha = 1.0
                })
            }
        }
    }

    override open func dismissalTransitionWillBegin() {
        if let dimmingView = self.dimmingView {
            if let efectView = dimmingView as? UIVisualEffectView {
                guard let coordinator = presentedViewController.transitionCoordinator else {
                    efectView.effect = nil
                    return
                }
                coordinator.animate(alongsideTransition: { _ in
                    efectView.effect = nil
                })
            } else {
                guard let coordinator = presentedViewController.transitionCoordinator else {
                    dimmingView.alpha = 0.0
                    return
                }
                coordinator.animate(alongsideTransition: { _ in
                    dimmingView.alpha = 0.0
                })
            }
        }
    }

    override open func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override open var frameOfPresentedViewInContainerView: CGRect {
        return finalFrame(ofContainer: false)
    }

    func finalFrame(ofContainer: Bool) -> CGRect {
        guard containerView != nil else {
            return super.frameOfPresentedViewInContainerView
        }

        var safeHeight = containerView!.bounds.height
        var safeWidth = containerView!.bounds.width
        if #available(iOS 11.0, *) {
            safeHeight = containerView!.bounds.height - (fillSafeArea ? 0 : containerView!.safeAreaInsets.vertical)
            safeWidth = containerView!.bounds.width - (fillSafeArea ? 0 : containerView!.safeAreaInsets.horizontal)
        }

        func centerX(with size: CGSize) -> CGFloat {
            if #available(iOS 11.0, *) {
                return (safeWidth - size.width - contentInset.horizontal) / 2 + contentInset.left + (fillSafeArea ? 0 : containerView!.safeAreaInsets.left)
            } else {
                return (safeWidth - size.width - contentInset.horizontal) / 2 + contentInset.left
            }
        }

        func leftX() -> CGFloat {
            if #available(iOS 11.0, *) {
                return (fillSafeArea ? 0 : containerView!.safeAreaInsets.left) + contentInset.left
            } else {
                return contentInset.left
            }
        }

        func rightX(with size: CGSize) -> CGFloat {
            if #available(iOS 11.0, *) {
                return containerView!.bounds.width - (fillSafeArea ? 0 : containerView!.safeAreaInsets.right) - size.width - contentInset.right
            } else {
                return containerView!.bounds.width - size.width - contentInset.right
            }
        }

        func topY() -> CGFloat {
            if #available(iOS 11.0, *) {
                return (fillSafeArea ? 0 : containerView!.safeAreaInsets.top) + contentInset.top
            } else {
                return contentInset.top
            }
        }

        func centerY(with size: CGSize) -> CGFloat {
            if #available(iOS 11.0, *) {
                return (safeHeight - targetFrame.size.height - contentInset.vertical) / 2 + (fillSafeArea ? 0 : containerView!.safeAreaInsets.top) + contentInset.top
            } else {
                return (safeHeight - targetFrame.size.height - contentInset.vertical) / 2 + contentInset.top
            }
        }

        func bottomY(with size: CGSize) -> CGFloat {
            if #available(iOS 11.0, *) {
                return containerView!.bounds.height - (fillSafeArea ? 0 : containerView!.safeAreaInsets.bottom) - size.height - contentInset.bottom
            } else {
                return containerView!.bounds.height - size.height - contentInset.bottom
            }
        }

        func getLayoutSize() -> CGSize {
            var size = presentedViewController.view.systemLayoutSizeFitting(CGSize(width: safeWidth - contentInset.horizontal, height: 0), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
            if size.height > safeHeight - contentInset.vertical {
                size.height = safeHeight - contentInset.vertical
            }
            return size
        }

        let defaultSize = getLayoutSize()

        var targetFrame: CGRect = .zero
        switch layout {
        case .fullscreen:
            targetFrame = containerView?.bounds ?? UIScreen.main.bounds.inset(by: contentInset)
        case let .center(size):
            targetFrame.size = size ?? defaultSize
            targetFrame.origin = CGPoint(x: centerX(with: targetFrame.size), y: centerY(with: targetFrame.size))
            targetFrame = fitSafeArea(frame: targetFrame, ofContainer: ofContainer)
        case let .topLeft(size):
            targetFrame.size = size ?? defaultSize
            targetFrame.origin = CGPoint(x: leftX(), y: topY())
            targetFrame = fitSafeArea(frame: targetFrame, ofContainer: ofContainer)
        case let .topCenter(size):
            targetFrame.size = size ?? defaultSize
            targetFrame.origin = CGPoint(x: centerX(with: targetFrame.size), y: topY())
            targetFrame = fitSafeArea(frame: targetFrame, ofContainer: ofContainer)
        case let .topRight(size):
            targetFrame.size = size ?? defaultSize
            targetFrame.origin = CGPoint(x: rightX(with: targetFrame.size), y: topY())
            targetFrame = fitSafeArea(frame: targetFrame, ofContainer: ofContainer)
        case let .bottomLeft(size):
            targetFrame.size = size ?? defaultSize
            targetFrame.origin = CGPoint(x: leftX(), y: bottomY(with: targetFrame.size))
            targetFrame = fitSafeArea(frame: targetFrame, ofContainer: ofContainer)
        case let .bottomCenter(size):
            targetFrame.size = size ?? defaultSize
            targetFrame.origin = CGPoint(x: centerX(with: targetFrame.size), y: bottomY(with: targetFrame.size))
            targetFrame = fitSafeArea(frame: targetFrame, ofContainer: ofContainer)
        case let .bottomRight(size):
            targetFrame.size = size ?? defaultSize
            targetFrame.origin = CGPoint(x: rightX(with: targetFrame.size), y: bottomY(with: targetFrame.size))
            targetFrame = fitSafeArea(frame: targetFrame, ofContainer: ofContainer)
        case let .leftCenter(size):
            targetFrame.size = size ?? defaultSize
            targetFrame.origin = CGPoint(x: leftX(), y: centerY(with: targetFrame.size))
            targetFrame = fitSafeArea(frame: targetFrame, ofContainer: ofContainer)
        case let .rightCenter(size):
            targetFrame.size = size ?? defaultSize
            targetFrame.origin = CGPoint(x: rightX(with: targetFrame.size), y: centerY(with: targetFrame.size))
            targetFrame = fitSafeArea(frame: targetFrame, ofContainer: ofContainer)
        case let .custom(frame):
            targetFrame = frame
        }
        return targetFrame
    }

    private func fitSafeArea(frame: CGRect, ofContainer: Bool) -> CGRect {
        guard ofContainer, let container = containerView else {
            return frame
        }
        var newFrame = frame
        let safeFrame = container.frame.inset(by: container.safeAreaInsets)
        if newFrame.minX < safeFrame.minX {
            newFrame.size.width += safeFrame.minX - newFrame.minX
        }
        if newFrame.minY < safeFrame.minY {
            newFrame.size.height += safeFrame.minY - newFrame.minY
        }
        if newFrame.maxX > safeFrame.maxX {
            let delta = newFrame.maxX - safeFrame.maxX
            newFrame.size.width += delta
            newFrame.origin.x -= delta
        }
        if newFrame.maxY > safeFrame.maxY {
            let delta = newFrame.maxY - safeFrame.maxY
            newFrame.size.height += delta
            newFrame.origin.y -= delta
        }
        if newFrame.width > container.frame.width {
            newFrame.size.width = container.frame.width
        }

        if newFrame.height > container.frame.height {
            newFrame.size.height = container.frame.height
        }
        return newFrame
    }

    @objc private func dismissDimmingViewTapGestureAction() {
        if let popupable = presentedViewController as? PopupableType {
            if popupable.popupControllerWillDismissByGesture() {
                presentedViewController.dismiss(animated: true, completion: nil)
            }
        } else {
            presentedViewController.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - PopControllerAnimation

open class PopControllerAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    public struct Animation {
        public var duration: CGFloat

        public var type: AnimationType

        public var options: UIView.AnimationOptions

        public var springDampingRatio: CGFloat?

        public var initialSpringVelocity: CGFloat?

        public init(duration: CGFloat, type: AnimationType, options: UIView.AnimationOptions) {
            self.duration = duration
            self.type = type
            self.options = options
            springDampingRatio = nil
            initialSpringVelocity = nil
        }

        public init(duration: CGFloat, type: AnimationType, options: UIView.AnimationOptions, springDampingRatio: CGFloat?, initialSpringVelocity: CGFloat?) {
            self.duration = duration
            self.type = type
            self.options = options
            self.springDampingRatio = springDampingRatio
            self.initialSpringVelocity = initialSpringVelocity
        }
    }

    public enum AnimationType {
        // 缩小
        case shrink
        // 放大
        case enlarge
        // 左边
        case left(fade: Bool)
        // 右边
        case right(fade: Bool)
        // 上边
        case top(fade: Bool)
        // 下边
        case bottom(fade: Bool)
        // 从下浮动
        case flowFromBottom
        // 从上浮动
        case flowFromTop
        // 淡入淡出
        case fade
    }

    public enum Direction {
        case present
        case dismiss
    }

    open var direction: Direction = .present

    open var animationParameters: Animation

    public init(animation: Animation, direction: Direction) {
        animationParameters = animation
        self.direction = direction
        super.init()
    }

    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationParameters.duration
    }

    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch direction {
        case .present:
            presentAnimation(transitionContext)
        case .dismiss:
            dismissAnimation(transitionContext)
        }
    }

    override open class func prepareForInterfaceBuilder() {
    }

    private func presentAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let vc = transitionContext.viewController(forKey: .to) else {
            return
        }
        let finalFrame = transitionContext.finalFrame(for: vc)
        let toTransform: CGAffineTransform = .identity
        let toAlpha: CGFloat = 1

        if let controller = vc.presentationController as? PopPresentationController, controller.dimmingView == nil {
            let frame = controller.finalFrame(ofContainer: true)
            transitionContext.containerView.frame = frame
        }

        var fromFrame = finalFrame
        var fromTransform: CGAffineTransform = .identity
        var fromAlpha: CGFloat = 1

        vc.view.frame = fromFrame
        transitionContext.containerView.addSubview(vc.view)

        switch animationParameters.type {
        case .shrink:
            fromTransform = .init(scaleX: 0.1, y: 0.1)
            fromAlpha = 0
        case .enlarge:
            fromTransform = .init(scaleX: 1.3, y: 1.3)
            fromAlpha = 0
        case let .left(fade):
            if fade {
                fromAlpha = 0
            }
            fromFrame.origin.x = -finalFrame.width
        case let .right(fade):
            if fade {
                fromAlpha = 0
            }
            fromFrame.origin.x = transitionContext.containerView.bounds.width
        case let .top(fade):
            if fade {
                fromAlpha = 0
            }
            fromFrame.origin.y = -finalFrame.height
        case let .bottom(fade):
            if fade {
                fromAlpha = 0
            }
            fromFrame.origin.y = transitionContext.containerView.bounds.height
        case .flowFromTop:
            fromFrame.origin.y = finalFrame.origin.y - 70
            fromAlpha = 0
        case .flowFromBottom:
            fromFrame.origin.y = finalFrame.origin.y + 70
            fromAlpha = 0
        case .fade:
            fromAlpha = 0
        }

        vc.view.frame = fromFrame
        vc.view.alpha = fromAlpha
        vc.view.transform = fromTransform

        let animationBlock = {
            vc.view.transform = toTransform
            vc.view.frame = finalFrame
            vc.view.alpha = toAlpha
        }

        if let springDampingRatio = animationParameters.springDampingRatio, let initialSpringVelocity = animationParameters.initialSpringVelocity {
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: springDampingRatio, initialSpringVelocity: initialSpringVelocity, options: animationParameters.options, animations: animationBlock, completion: { finish in
                transitionContext.completeTransition(finish)
            })
        } else {
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: animationParameters.options, animations: animationBlock, completion: { finish in
                transitionContext.completeTransition(finish)
            })
        }
    }

    private func dismissAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let vc = transitionContext.viewController(forKey: .from) else {
            return
        }

        var finalFrame = transitionContext.finalFrame(for: vc)
        var toTransform: CGAffineTransform = .identity
        var toAlpha: CGFloat = 1

        let fromFrame = finalFrame
        let fromTransform: CGAffineTransform = .identity
        let fromAlpha: CGFloat = 1

        vc.view.frame = fromFrame
        transitionContext.containerView.addSubview(vc.view)

        switch animationParameters.type {
        case .shrink:
            toTransform = .init(scaleX: 0.1, y: 0.1)
            toAlpha = 0
        case .enlarge:
            toTransform = .init(scaleX: 1.3, y: 1.3)
            toAlpha = 0
        case let .left(fade):
            if fade {
                toAlpha = 0
            }
            finalFrame.origin.x = -finalFrame.width
        case let .right(fade):
            if fade {
                toAlpha = 0
            }
            finalFrame.origin.x = transitionContext.containerView.bounds.width
        case let .top(fade):
            if fade {
                toAlpha = 0
            }
            finalFrame.origin.y = -finalFrame.height
        case let .bottom(fade):
            if fade {
                toAlpha = 0
            }
            finalFrame.origin.y = transitionContext.containerView.bounds.height
        case .flowFromTop:
            finalFrame.origin.y = fromFrame.origin.y - 70
            toAlpha = 0
        case .flowFromBottom:
            finalFrame.origin.y = fromFrame.origin.y + 70
            toAlpha = 0
        case .fade:
            toAlpha = 0
        }

        vc.view.frame = fromFrame
        vc.view.alpha = fromAlpha
        vc.view.transform = fromTransform

        let animationBlock = {
            vc.view.frame = finalFrame
            vc.view.alpha = toAlpha
            vc.view.transform = toTransform
        }

        let completionBlock = {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            if transitionContext.transitionWasCancelled {
                vc.view.frame = fromFrame
                vc.view.alpha = fromAlpha
                vc.view.transform = fromTransform
            }
        }

        if let springDampingRatio = animationParameters.springDampingRatio, let initialSpringVelocity = animationParameters.initialSpringVelocity {
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: springDampingRatio, initialSpringVelocity: initialSpringVelocity, options: animationParameters.options, animations: animationBlock, completion: { _ in
                completionBlock()
            })
        } else {
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: animationParameters.options, animations: animationBlock, completion: { _ in
                completionBlock()
            })
        }
    }
}
