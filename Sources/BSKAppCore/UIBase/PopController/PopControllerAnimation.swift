//
//  PopControllerAnimation.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2021/12/1.
//

import UIKit

open class PopController: BSKViewController {
    open var layout: PopPresentationController.Layout = .center(size: nil) {
        didSet {
            popPresentationController?.layout = layout
        }
    }

    open var showDimmingView: Bool = true {
        didSet {
            popPresentationController?.showDimmingView = showDimmingView
        }
    }

    /// 当layout 为 custom 时无效
    open var contentInset: UIEdgeInsets = .zero {
        didSet {
            popPresentationController?.contentInset = contentInset
        }
    }

    /// 是否填充安全区域，当layout 为 custom 时无效
    open var fillSafeArea = true {
        didSet {
            popPresentationController?.fillSafeArea = fillSafeArea
        }
    }

    /// 点击遮罩隐藏视图
    open var tapDimmingViewTodismiss: Bool = false {
        didSet {
            popPresentationController?.dismissDimmingViewTapGesture.isEnabled = tapDimmingViewTodismiss
        }
    }

    open var gestureToDismiss: Bool = false {
        didSet {
            if gestureToDismiss != oldValue {
                setupInteractionDismiss()
            }
        }
    }

    open var dimmingView: UIView?

    open var popPresentationController: PopPresentationController?
    open var dismissedAnimationController: PopControllerAnimation = .init(duration: 0.3, animation: .fade, direction: .dismiss)
    open var presentedAnimationController: PopControllerAnimation = .init(duration: 0.3, animation: .enlarge, direction: .present)

    private var isInGesture = false
    private var panGesture: UIPanGestureRecognizer?
    private var interactionController: UIPercentDrivenInteractiveTransition?
    private var gesturePercentCurrentDenominator: CGFloat = 1

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(light: .white, dark: .black)
    }

    private func setupInteractionDismiss() {
        guard gestureToDismiss else {
            if let gesture = panGesture {
                gesture.isEnabled = false
                view.removeGestureRecognizer(gesture)
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
        view.addGestureRecognizer(gesture)
    }

    /// 即将被手势隐藏时调用，返回false阻止手势隐藏
    /// - Returns: 返回一个Bool决定是否允许dismiss操作,默认返回true
    open func willDismissByGesture() -> Bool {
        return true
    }

    @objc private func dismissPangestureAction(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            isInGesture = true
            gesturePercentCurrentDenominator = { () -> CGFloat in
                switch self.dismissedAnimationController.animation {
                case .left:
                    return self.view.frame.maxX
                case .right:
                    return (self.view.window?.frame.width ?? 0) - self.view.frame.minX
                case .flowFromTop: fallthrough
                case .top:
                    return self.view.frame.maxY
                case .shrink: fallthrough
                case .fade: fallthrough
                case .enlarge: fallthrough
                case .flowFromBottom: fallthrough
                case .bottom:
                    return ((self.view.window?.frame.height ?? 0) - self.view.frame.minY)
                }
            }()
            dismiss(animated: true, completion: nil)
        } else if gesture.state == .changed {
            let trans = gesture.translation(in: view.window)
            let molecular = { () -> CGFloat in
                switch self.dismissedAnimationController.animation {
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
                let v = gesture.velocity(in: view)
                shouldFinish = { () -> Bool in
                    switch self.dismissedAnimationController.animation {
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

            if shouldFinish && willDismissByGesture() {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            isInGesture = false
        }
    }
}

extension PopController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gesture = gestureRecognizer as? UIPanGestureRecognizer, gesture == panGesture else {
            return false
        }
        let trans = gesture.translation(in: view)
        switch dismissedAnimationController.animation {
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
              self.view.subviews.contains(otherView) else {
            return false
        }
        switch self.dismissedAnimationController.animation {
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

extension PopController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let controller = PopPresentationController(presentedViewController: presented, presenting: presenting)
        controller.layout = layout
        controller.contentInset = contentInset
        controller.fillSafeArea = fillSafeArea
        controller.showDimmingView = showDimmingView
        if showDimmingView {
            if let dimmingView = self.dimmingView {
                controller.dimmingView = dimmingView
            } else {
                dimmingView = controller.dimmingView
            }
        }
        if tapDimmingViewTodismiss {
            controller.dismissDimmingViewTapGesture.isEnabled = tapDimmingViewTodismiss
        }
        popPresentationController = controller
        return controller
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if isInGesture {
            dismissedAnimationController.options = [.curveLinear]
        } else {
            dismissedAnimationController.options = [.curveEaseInOut]
        }
        return dismissedAnimationController
    }

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentedAnimationController
    }

    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return isInGesture ? interactionController : nil
    }
}

open class PopPresentationController: UIPresentationController {
    /// 如果size 为 nil 将会调用 view.systemLayoutSizeFitting方法计算大小
    public enum Layout {
        case fill
        case center(size: CGSize? = nil)
        case topLeft(size: CGSize? = nil)
        case topCenter(size: CGSize? = nil)
        case topRight(size: CGSize? = nil)
        case bottomLeft(size: CGSize? = nil)
        case bottomCenter(size: CGSize? = nil)
        case bottomRight(size: CGSize? = nil)
        case leftCenter(size: CGSize? = nil)
        case rightCenter(size: CGSize? = nil)
        case custom(frame: CGRect)
    }

    fileprivate lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.2)
        return view
    }()

    /// 点击遮罩取消弹窗，默认关闭，将它的isEnable设为true启用
    private(set) lazy var dismissDimmingViewTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissDimmingViewTapGestureAction))
        dimmingView.addGestureRecognizer(gesture)
        return gesture
    }()

    open var showDimmingView: Bool = true
    /// 布局
    open var layout: Layout = .center(size: nil)
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
        if showDimmingView {
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
                    self.dimmingView.alpha = 1.0
                })
            }
        }
    }

    override open func dismissalTransitionWillBegin() {
        if showDimmingView {
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
                    self.dimmingView.alpha = 0.0
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
        case .fill:
            targetFrame = self.containerView?.bounds ?? UIScreen.main.bounds
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
        if let vc = presentedViewController as? PopController {
            if vc.willDismissByGesture() {
                presentedViewController.dismiss(animated: true, completion: nil)
            }
        } else {
            presentedViewController.dismiss(animated: true, completion: nil)
        }
    }
}

open class PopControllerAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    open var duration: CGFloat = 0.3

    open var animation: Animation = .enlarge

    open var direction: Direction = .present

    open var options: UIView.AnimationOptions = [.curveEaseInOut]

    open var dampingRatio: CGFloat

    open var velocity: CGFloat

    public enum Direction {
        case present
        case dismiss
    }

    public enum Animation: CaseIterable {
        // 缩小
        case shrink
        // 放大
        case enlarge
        // 左边
        case left
        // 右边
        case right
        // 上边
        case top
        // 下边
        case bottom
        // 从下浮动
        case flowFromBottom
        // 从上浮动
        case flowFromTop
        // 淡入淡出
        case fade
    }

    public init(duration: CGFloat, animation: Animation, direction: Direction, usingSpringWithDamping dampingRatio: CGFloat = 1, initialSpringVelocity velocity: CGFloat = 0) {
        self.duration = duration
        self.animation = animation
        self.direction = direction
        self.dampingRatio = dampingRatio
        self.velocity = velocity
        super.init()
    }

    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
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

        if let controller = vc.presentationController as? PopPresentationController, !controller.showDimmingView {
            let frame = controller.finalFrame(ofContainer: true)
            transitionContext.containerView.frame = frame
        }

        var fromFrame = finalFrame
        var fromTransform: CGAffineTransform = .identity
        var fromAlpha: CGFloat = 1

        vc.view.frame = fromFrame
        transitionContext.containerView.addSubview(vc.view)

        switch animation {
        case .shrink:
            fromTransform = .init(scaleX: 0.1, y: 0.1)
            fromAlpha = 0
        case .enlarge:
            fromTransform = .init(scaleX: 1.3, y: 1.3)
            fromAlpha = 0
        case .left:
            fromFrame.origin.x = -finalFrame.width
        case .right:
            fromFrame.origin.x = transitionContext.containerView.bounds.width
        case .top:
            fromFrame.origin.y = -finalFrame.height
        case .flowFromTop:
            fromFrame.origin.y = finalFrame.origin.y - 70
            fromAlpha = 0
        case .flowFromBottom:
            fromFrame.origin.y = finalFrame.origin.y + 70
            fromAlpha = 0
        case .bottom:
            fromFrame.origin.y = transitionContext.containerView.bounds.height
        case .fade:
            fromAlpha = 0
        }

        vc.view.frame = fromFrame
        vc.view.alpha = fromAlpha
        vc.view.transform = fromTransform
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity, options: options) {
            vc.view.transform = toTransform
            vc.view.frame = finalFrame
            vc.view.alpha = toAlpha
        } completion: { finish in
            transitionContext.completeTransition(finish)
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

        switch animation {
        case .shrink:
            toTransform = .init(scaleX: 0.1, y: 0.1)
            toAlpha = 0
        case .enlarge:
            toTransform = .init(scaleX: 1.3, y: 1.3)
            toAlpha = 0
        case .left:
            finalFrame.origin.x = -finalFrame.width
        case .right:
            finalFrame.origin.x = transitionContext.containerView.bounds.width
        case .top:
            finalFrame.origin.y = -finalFrame.height
        case .flowFromTop:
            finalFrame.origin.y = fromFrame.origin.y - 70
            toAlpha = 0
        case .flowFromBottom:
            finalFrame.origin.y = fromFrame.origin.y + 70
            toAlpha = 0
        case .bottom:
            finalFrame.origin.y = transitionContext.containerView.bounds.height
        case .fade:
            toAlpha = 0
        }

        vc.view.frame = fromFrame
        vc.view.alpha = fromAlpha
        vc.view.transform = fromTransform
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: options) {
            vc.view.frame = finalFrame
            vc.view.alpha = toAlpha
            vc.view.transform = toTransform
        } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            if transitionContext.transitionWasCancelled {
                vc.view.frame = fromFrame
                vc.view.alpha = fromAlpha
                vc.view.transform = fromTransform
            }
        }
    }
}
