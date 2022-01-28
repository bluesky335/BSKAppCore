//
//  PopControllerAnimation.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2021/12/1.
//

import UIKit

fileprivate extension UIEdgeInsets {
    var horizontal: CGFloat {
        return left + right
    }

    var vertical: CGFloat {
        return top + bottom
    }
}

class PopController: UIViewController {
    var layout: PopPresentationController.Layout = .center(size: nil) {
        didSet {
            popPresentationController?.layout = layout
        }
    }

    /// 当layout 为 custom 时无效
    var contentInset = UIEdgeInsets(top: 16, left: 50, bottom: 16, right: 50) {
        didSet {
            popPresentationController?.contentInset = contentInset
        }
    }

    /// 是否填充安全区域，当layout 为 custom 时无效
    var fillSafeArea = false {
        didSet {
            popPresentationController?.fillSafeArea = fillSafeArea
        }
    }

    /// 点击遮罩隐藏视图
    var tapDimmingViewTodismiss: Bool = false {
        didSet {
            popPresentationController?.dismissDimmingViewTapGesture.isEnabled = tapDimmingViewTodismiss
        }
    }

    var gestureToDismiss: Bool = false {
        didSet {
            if gestureToDismiss != oldValue {
                setupInteractionDismiss()
            }
        }
    }

    var popPresentationController: PopPresentationController?
    var dismissedAnimationController: PopControllerAnimation = .init(duration: 0.3, animation: .fade, direction: .dismiss)
    var presentedAnimationController: PopControllerAnimation = .init(duration: 0.3, animation: .enlarge, direction: .present)

    private var isInGesture = false
    private var panGesture: UIPanGestureRecognizer?
    private var interactionController: UIPercentDrivenInteractiveTransition?
    private var gesturePercentCurrentDenominator: CGFloat = 1

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        transitioningDelegate = self
        modalPresentationStyle = .custom
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

    @objc private func dismissPangestureAction(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            isInGesture = true
            gesturePercentCurrentDenominator = { () -> CGFloat in
                switch self.dismissedAnimationController.animation {
                case .left:
                    return self.view.frame.maxX
                case .right:
                    return (self.view.window?.frame.width ?? 0) - self.view.frame.minX
                case .top:
                    return self.view.frame.maxY
                case .shrink: fallthrough
                case .fade: fallthrough
                case .enlarge: fallthrough
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
                case .top:
                    return trans.y > 0 ? 0 : abs(trans.y)
                case .shrink: fallthrough
                case .fade: fallthrough
                case .enlarge: fallthrough
                case .bottom:
                    return trans.y < 0 ? 0 : trans.y
                }
            }()
            interactionController?.update(max(0, min(1, molecular / gesturePercentCurrentDenominator)))
        } else {
            if (interactionController?.percentComplete ?? 0) > 0.5 {
                interactionController?.finish()
            } else {
                let v = gesture.velocity(in: view)
                let shouldFinish = { () -> Bool in
                    switch self.dismissedAnimationController.animation {
                    case .left:
                        return v.x < -20
                    case .right:
                        return v.x > 20
                    case .enlarge: fallthrough
                    case .top:
                        return v.y < -20
                    case .shrink: fallthrough
                    case .fade: fallthrough
                    case .bottom:
                        return v.y > 20
                    }
                }()
                if shouldFinish {
                    interactionController?.finish()
                } else {
                    interactionController?.cancel()
                }
            }
            isInGesture = false
        }
    }
}

extension PopController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gesture = gestureRecognizer as? UIPanGestureRecognizer, gesture == panGesture else {
            return false
        }
        let trans = gesture.translation(in: view)
        switch dismissedAnimationController.animation {
        case .left:
            return trans.x < 0
        case .right:
            return trans.x > 0
        case .top:
            return trans.y < 0
        case .shrink: fallthrough
        case .enlarge: fallthrough
        case .fade: fallthrough
        case .bottom:
            return trans.y > 0
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
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
        case .top:
            return otherView.contentOffset.y == otherView.contentSize.height - otherView.frame.height
        case .shrink: fallthrough
        case .enlarge: fallthrough
        case .fade: fallthrough
        case .bottom:
            return otherView.contentOffset.y == 0
        }
    }
}

extension PopController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let controller = PopPresentationController(presentedViewController: presented, presenting: presenting)
        controller.layout = layout
        controller.contentInset = contentInset
        controller.fillSafeArea = fillSafeArea
        if tapDimmingViewTodismiss {
            controller.dismissDimmingViewTapGesture.isEnabled = tapDimmingViewTodismiss
        }
        popPresentationController = controller
        return controller
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if isInGesture {
            dismissedAnimationController.options = [.curveLinear]
        } else {
            dismissedAnimationController.options = [.curveEaseInOut]
        }
        return dismissedAnimationController
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentedAnimationController
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return isInGesture ? interactionController : nil
    }
}

class PopPresentationController: UIPresentationController {
    /// 如果size 为 nil 将会调用 view.systemLayoutSizeFitting方法计算大小
    enum Layout {
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

    private(set) var dimmingView = UIView()

    /// 点击遮罩取消弹窗，默认关闭，将它的isEnable设为true启用
    private(set) lazy var dismissDimmingViewTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissDimmingViewTapGestureAction))
        dimmingView.addGestureRecognizer(gesture)
        return gesture
    }()

    /// 布局
    var layout: Layout = .center(size: nil)
    /// 是否填充安全区域，当layout 为 custom 时无效
    var fillSafeArea = false
    /// 内容边距，当layout 为 custom 时无效
    var contentInset = UIEdgeInsets(top: 16, left: 50, bottom: 16, right: 50)

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        dimmingView.backgroundColor = .black.withAlphaComponent(0.2)
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = self.containerView else {
            return
        }
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.alpha = 0
        containerView.insertSubview(dimmingView, at: 0)
        dimmingView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        dimmingView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }

    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }

        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }

    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override var frameOfPresentedViewInContainerView: CGRect {
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
            var size = presentedViewController.view.systemLayoutSizeFitting(CGSize(width: containerView!.bounds.width - contentInset.horizontal, height: 0), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
            if size.height > safeHeight - contentInset.vertical {
                size.height = safeHeight - contentInset.vertical
            }
            return size
        }

        let defaultSize = getLayoutSize()

        var targetFrame: CGRect = .zero
        switch layout {
        case let .center(size):
            targetFrame.size = size ?? defaultSize
            targetFrame.origin = CGPoint(x: centerX(with: targetFrame.size), y: centerY(with: targetFrame.size))
        case let .topLeft(size):
            targetFrame.size = size ?? defaultSize
            targetFrame.origin = CGPoint(x: leftX(), y: topY())
        case let .topCenter(size):
            targetFrame.size = size ?? defaultSize
            targetFrame.origin = CGPoint(x: centerX(with: targetFrame.size), y: topY())
        case let .topRight(size):
            targetFrame.size = size ?? defaultSize
            targetFrame.origin = CGPoint(x: rightX(with: targetFrame.size), y: topY())
        case let .bottomLeft(size):
            targetFrame.size = size ?? defaultSize
            targetFrame.origin = CGPoint(x: leftX(), y: bottomY(with: targetFrame.size))
        case let .bottomCenter(size):
            targetFrame.size = size ?? defaultSize
            targetFrame.origin = CGPoint(x: centerX(with: targetFrame.size), y: bottomY(with: targetFrame.size))
        case let .bottomRight(size):
            targetFrame.size = size ?? defaultSize
            targetFrame.origin = CGPoint(x: rightX(with: targetFrame.size), y: bottomY(with: targetFrame.size))
        case let .leftCenter(size):
            targetFrame.size = size ?? defaultSize
            targetFrame.origin = CGPoint(x: leftX(), y: centerY(with: targetFrame.size))
        case let .rightCenter(size):
            targetFrame.size = size ?? defaultSize
            targetFrame.origin = CGPoint(x: rightX(with: targetFrame.size), y: centerY(with: targetFrame.size))
        case let .custom(frame):
            targetFrame = frame
        }
        return targetFrame
    }

    @objc private func dismissDimmingViewTapGestureAction() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}

class PopControllerAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    var duration: CGFloat = 0.3

    var animation: Animation = .enlarge

    var direction: Direction = .present

    var options: UIView.AnimationOptions = [.curveEaseInOut]

    enum Direction {
        case present
        case dismiss
    }

    enum Animation: CaseIterable {
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
        // 淡入淡出
        case fade
    }

    init(duration: CGFloat, animation: Animation, direction: Direction) {
        super.init()
        self.duration = duration
        self.animation = animation
        self.direction = direction
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch direction {
        case .present:
            presentAnimation(transitionContext)
        case .dismiss:
            dismissAnimation(transitionContext)
        }
    }

    override class func prepareForInterfaceBuilder() {
    }

    private func presentAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let vc = transitionContext.viewController(forKey: .to) else {
            return
        }
        let finalFrame = transitionContext.finalFrame(for: vc)
        let toTransform: CGAffineTransform = .identity
        let toAlpha: CGFloat = 1

        var fromFrame = finalFrame
        var fromTransform: CGAffineTransform = .identity
        var fromAlpha: CGFloat = 0

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
        case .bottom:
            fromFrame.origin.y = transitionContext.containerView.bounds.height
        case .fade:
            fromAlpha = 0
        }

        vc.view.frame = fromFrame
        vc.view.alpha = fromAlpha
        vc.view.transform = fromTransform
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: options) {
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
        var toAlpha: CGFloat = 0

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
