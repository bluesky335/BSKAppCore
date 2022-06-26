//
//  BSKLoadingView.swift
//
//
//  Created by 刘万林 on 2022/5/24.
//

import UIKit

/// Loading动画视图，使用UIActivityIndicatorView的简单的加载视图
public class BSKLoadingView: BSKDimmingView {
    /// 活动指示器
    public var activityView = UIActivityIndicatorView(style: .medium)

    private var refCount = 1

    override init(frame: CGRect) {
        super.init(frame: frame)
        dimmingColor = .clear
        contentView.addSubview(activityView)
        activityView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        activityView.backgroundColor = .gray
        activityView.cornerRadius = 10
        inAnimation = .fade
        outAnimation = .fade
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        activityView.startAnimating()
    }

    override public func removeFromSuperview() {
        super.removeFromSuperview()
        activityView.stopAnimating()
    }

    /// 显示加载视图,当view中已有加载视图时不会再重复添加
    /// - Parameters:
    ///   - view: 展示加载视图的目标View，为空时将直接显示在当前Controller的视图上
    ///   - animated: 是否动画
    /// - Returns: 显示的加载视图
    public static func show(in view: UIView? = nil, animated: Bool = true) -> BSKLoadingView {
        guard let targetView = view ?? UIApplication.shared.bsk.topViewController?.view ?? UIApplication.shared.bsk.keyWindow else {
            // 找不到目标视图，直接返回
            return BSKLoadingView()
        }

        if let showedLoadingView = targetView.getLoadingView() {
            // 如果有已经展示了的LoadingView则直接返回
            showedLoadingView.refCount += 1
            return showedLoadingView
        }

        let loadingView = BSKLoadingView()
        loadingView.show(in: targetView, animated: animated)
        return loadingView
    }

    override public func hide(animated: Bool = true) {
        refCount -= 1
        if refCount <= 0 {
            super.hide(animated: animated)
        }
    }
}

extension UIView {
    /// 获取当前显示的loadingView
    func getLoadingView() -> BSKLoadingView? {
        for item in subviews {
            if let loading = item as? BSKLoadingView {
                return loading
            }
        }
        return nil
    }
}

public class BSKDimmingView: UIView {
    /// 动画类型
    public enum AnimationType {
        case fade
        case scaleBig
        case scaleSmall
    }

    /// 动画的方向，进入或退出
    public enum AnimationDirection {
        case animatedIn
        case animatedOut

        fileprivate func removeFromSuperViewIfNeed(_ view: UIView) {
            switch self {
            case .animatedOut:
                view.removeFromSuperview()
            default:
                break
            }
        }
    }

    /// 内容View，显示的内容应该添加到此View中，而不是直接添加到DimingView中
    public private(set) var contentView: UIView = UIView()

    /// 进入时的动画类型
    public var inAnimation: AnimationType = .scaleBig
    /// 退出时的动画类型
    public var outAnimation: AnimationType = .scaleSmall
    /// 动画时长
    public var animationDuration: Double = 0.3

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.left.right.bottom.top.equalTo(self.safeAreaLayoutGuide)
            } else {
                make.left.right.bottom.top.equalToSuperview()
            }
        }
    }

    /// 遮罩颜色，默认是50%透明度的黑色
    public var dimmingColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)

    /// 展示遮罩视图
    /// - Parameters:
    ///   - targetView: 展示遮罩的目标视图
    ///   - animated: 是否动画
    public func show(in targetView: UIView, animated: Bool = true) {
        targetView.addSubview(self)
        snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.left.right.bottom.top.equalTo(targetView.safeAreaLayoutGuide)
            } else {
                make.left.right.bottom.top.equalToSuperview()
            }
        }
        if animated {
            switch inAnimation {
            case .fade:
                fadeAnimated(.animatedIn)
            case .scaleBig:
                scaleBigAnimated(.animatedIn)
            case .scaleSmall:
                scaleSmallAnimated(.animatedIn)
            }
        }
    }

    /// 隐藏遮罩视图
    /// - Parameter animated: 是否动画
    public func hide(animated: Bool = true) {
        if animated {
            switch outAnimation {
            case .fade:
                fadeAnimated(.animatedOut)
            case .scaleBig:
                scaleBigAnimated(.animatedOut)
            case .scaleSmall:
                scaleSmallAnimated(.animatedOut)
            }
        } else {
            removeFromSuperview()
        }
    }

    func fadeAnimated(_ direction: AnimationDirection) {
        var from: CGFloat = 0
        var to: CGFloat = 1
        switch direction {
        case .animatedIn:
            from = 0
            to = 1
        case .animatedOut:
            from = 1
            to = 0
        }
        contentView.alpha = from
        prepareBgColor(direction)
        UIView.animate(withDuration: animationDuration) {
            self.contentView.alpha = to
            self.setBgColor(direction)
        } completion: { _ in
            direction.removeFromSuperViewIfNeed(self)
        }
    }

    func scaleBigAnimated(_ direction: AnimationDirection) {
        var from: CGAffineTransform = .identity
        var to: CGAffineTransform = .identity
        switch direction {
        case .animatedIn:
            from = .init(scaleX: 0.5, y: 0.5)
            to = .identity
        case .animatedOut:
            from = .identity
            to = .init(scaleX: 1.3, y: 1.3)
        }
        contentView.transform = from
        prepareBgColor(direction)
        UIView.animate(withDuration: animationDuration) {
            self.contentView.transform = to
            self.setBgColor(direction)
        } completion: { _ in
            direction.removeFromSuperViewIfNeed(self)
        }
    }

    func scaleSmallAnimated(_ direction: AnimationDirection) {
        var from: CGAffineTransform = .init(scaleX: 1.3, y: 1.3)
        var to: CGAffineTransform = .identity
        var alphaFrome: CGFloat = 0
        var alphaTo: CGFloat = 1
        switch direction {
        case .animatedOut:
            from = .identity
            to = .init(scaleX: 0.5, y: 0.5)
            alphaFrome = 1
            alphaTo = 0
        default: break
        }
        contentView.transform = from
        contentView.alpha = alphaFrome
        prepareBgColor(direction)
        UIView.animate(withDuration: animationDuration) {
            self.contentView.transform = to
            self.contentView.alpha = alphaTo
            self.setBgColor(direction)
        } completion: { _ in
            direction.removeFromSuperViewIfNeed(self)
        }
    }

    private func prepareBgColor(_ direction: AnimationDirection) {
        switch direction {
        case .animatedIn:
            backgroundColor = .clear
        case .animatedOut:
            backgroundColor = dimmingColor
        }
    }

    private func setBgColor(_ direction: AnimationDirection) {
        switch direction {
        case .animatedIn:
            backgroundColor = dimmingColor
        case .animatedOut:
            backgroundColor = .clear
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
