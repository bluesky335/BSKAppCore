//
//  LogFloatView.swift
//  iOS Test
//
//  Created by 刘万林 on 2021/8/31.
//

import UIKit
#if SPM
import BSKUtils
import BSKLog
#endif

public class BSKLogViewManager: NSObject {
    override private init() {
    }

    /// 日志窗口是否打开
    public var isOpen: Bool = false

    public static var share = BSKLogViewManager()

    var dataSource = BSKLogViewDestination()

    #if targetEnvironment(macCatalyst)
        var targetFrame = CGRect(x: 0, y: 60, width: 600, height: 400)
    #else
        var targetFrame = CGRect(x: 0, y: UIScreen.main.bounds.height / 2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
    #endif
    private lazy var openConsoleButton: UIButton = {
        let button = UIButton()
        button.setTitle(">_ ", for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black.withAlphaComponent(0.5)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.addTarget(self, action: #selector(openButtonAction), for: .touchUpInside)
        return button
    }()

    private lazy var pangesture = UIPanGestureRecognizer(target: self, action: #selector(pangestureAction(_:)))

    var window: UIWindow!

    /// 在指定scene中显示悬浮窗
    @available(iOS 13.0,*)
    public func initLogView(in scene: UIWindowScene) -> BSKLogViewDestination {
        if window != nil {
            window.isHidden = true
            window = nil
        }
        window = BSKLogWindow(windowScene: scene)
        setupWindow()
        return dataSource
    }

    /// 初始化悬浮窗
    public func initLogView()  -> BSKLogViewDestination{
        if window != nil {
            window.isHidden = true
            window = nil
        }
        if #available(iOS 13.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first(where: { scene in
                scene is UIWindowScene
            }) as? UIWindowScene {
                window = BSKLogWindow(windowScene: scene)
            } else {
                window = BSKLogWindow()
            }
        } else {
            window = BSKLogWindow()
        }
        setupWindow()
        return dataSource
    }

    private func setupWindow() {
        guard window != nil else {
            return
        }
        window.layer.masksToBounds = true
        window.windowLevel = .alert
        window.addSubview(openConsoleButton)
        window.addGestureRecognizer(pangesture)
        pangesture.delegate = self
        window.frame = CGRect(x: 100, y: UIScreen.main.bounds.width - 40, width: 40, height: 30)
        window.shadowColor = UIColor.darkGray
        window.shadowOpacity = 0.2
        window.shadowRadius = 10
        setupKeyboard()
    }

    private func setupAppearance(nvc: UINavigationController) {
        nvc.navigationBar.tintColor = .white
        nvc.navigationBar.isTranslucent = true
        nvc.navigationBar.backgroundColor = .black.withAlphaComponent(0.2)
        nvc.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        nvc.navigationBar.shadowImage = UIImage()
        nvc.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        nvc.toolbar.tintColor = .white
        nvc.toolbar.isTranslucent = true
        nvc.toolbar.setBackgroundImage(UIImage(color: .black.withAlphaComponent(0.2), size: CGSize(width: window.screen.bounds.width, height: 100)), forToolbarPosition: .any, barMetrics: .default)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "取消"
    }

    private lazy var keyboardListener = BSKKeyboardListener(delegate: self, events: [.willShow, .willHide])

    private func setupKeyboard() {
        keyboardListener.start()
    }

    /// 缓存的拖动开始时的位置
    private lazy var oldCenter: CGPoint = window.center

    // MARK: - Method

    /// 悬浮窗的位置
    private var floatWindowFrame: CGRect = CGRect(x: 100, y: UIScreen.main.bounds.width - 40, width: 40, height: 30)

    /// 缓存的键盘打开前的位置
    private lazy var keyboardOldFrame: CGRect = self.targetFrame

    /// 显示悬浮窗
    public func showLogView(at position: CGPoint? = nil) {
        guard window.isHidden else {
            return
        }
        if let p = position {
            perform(#selector(showWindow), with: NSValue(cgPoint: p), afterDelay: 0)
        } else {
            perform(#selector(showWindow), with: nil, afterDelay: 0)
        }
    }

    @objc func showWindow(_ value: NSValue?) {
        if let p = value?.cgPointValue {
            floatWindowFrame.origin = p
        }
        window.frame = floatWindowFrame
        window?.isHidden = false
        window?.makeKeyAndVisible()
    }

    /// 隐藏悬浮窗
    public func hideLogView() {
        guard !window.isHidden else {
            return
        }
        closeLogView()
        if window != nil {
            window.isHidden = true
            window.resignKey()
        }
    }

    /// 打开日志窗口
    public func openLogView() {
        guard window != nil else {
            return
        }
        if isOpen {
            return
        }
        isOpen = true
        floatWindowFrame = window.frame
        let vc = createLogVc()
        window.rootViewController = vc
        UIView.animate(withDuration: 0.3) {
            self.openConsoleButton.alpha = 0
            self.window.frame = self.targetFrame
            vc.view.cornerRadius = 5
            self.window.borderWidth = 0
        }
    }

    /// 关闭日志窗口
    public func closeLogView() {
        guard window != nil else {
            return
        }
        if !isOpen {
            return
        }
        isOpen = false
        UIView.animate(withDuration: 0.3) {
            self.window.frame = self.floatWindowFrame
            self.window.rootViewController?.view.alpha = 0
            self.window.rootViewController?.view.layer.cornerRadius = 5
            #if !targetEnvironment(macCatalyst)
                if let nvc = self.window.rootViewController as? UINavigationController {
                    nvc.setNavigationBarHidden(true, animated: true)
                    nvc.setToolbarHidden(true, animated: true)
                }
            #endif
            self.openConsoleButton.alpha = 1
        } completion: { _ in
            self.window.rootViewController = nil
        }
    }

    // MARK: - Factory

    private func createLogVc() -> UIViewController {
        let nvc = UINavigationController(rootViewController: BSKLogViewController())
        nvc.view.layer.borderWidth = 1
        nvc.view.layer.cornerRadius = 5
        nvc.view.frame = targetFrame
        nvc.setToolbarHidden(false, animated: false)
        setupAppearance(nvc: nvc)
        return nvc
    }

    // MARK: - ButtonAction

    @objc private func openButtonAction() {
        if isOpen {
            closeLogView()
        } else {
            openLogView()
        }
    }

    // MARK: - GestureAction

    @objc private func pangestureAction(_ gesture: UIPanGestureRecognizer) {
        guard window != nil else {
            return
        }
        let p = gesture.translation(in: gesture.view)
        switch gesture.state {
        case .began:
            oldCenter = window.center
        case .changed:
            if isOpen {
                window.center = CGPoint(x: oldCenter.x + p.x, y: oldCenter.y + p.y)
                #if targetEnvironment(macCatalyst)
                targetFrame = window.frame
                #endif
            } else {
                window.center = CGPoint(x: oldCenter.x + p.x, y: oldCenter.y + p.y)
                floatWindowFrame = window.frame
            }
        default:
            var topY: CGFloat = 0

            UIView.animate(withDuration: 0.3) { [self] in
                
                topY = window.windowScene?.statusBarManager?.statusBarFrame.maxY ?? UIApplication.shared.statusBarFrame.maxY
                if isOpen {
                    if abs(window.frame.origin.x) < 15 {
                        window.frame.origin.x = 0
                    }
                    if window.frame.origin.x < -1 * (window.frame.width - 30) {
                        window.frame.origin.x = -1 * (window.frame.width - 30)
                    } else if window.frame.origin.x > window.screen.bounds.width - 30 {
                        window.frame.origin.x = window.screen.bounds.width - 30
                    }
                } else {
                    if window.frame.origin.x < 0 {
                        window.frame.origin.x = 0
                    } else if window.frame.origin.x > window.screen.bounds.width - window.frame.width {
                        window.frame.origin.x = window.screen.bounds.width - window.frame.width
                    }
                }
                if window.frame.origin.y < topY {
                    window.frame.origin.y = window.windowScene?.statusBarManager?.statusBarFrame.height ?? UIApplication.shared.statusBarFrame.height
                } else if window.frame.origin.y > window.screen.bounds.height - 50 {
                    window.frame.origin.y = window.screen.bounds.height - 50
                }
            }
        }
    }
}

extension BSKLogViewManager: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if !isOpen {
            return true
        }
        if let nvc = window.rootViewController as? UINavigationController {
            let location = gestureRecognizer.location(in: nvc.view)
            return nvc.navigationBar.frame.contains(location) || nvc.toolbar.frame.contains(location)
        }
        return true
    }
}

/// 处理键盘事件
extension BSKLogViewManager: BSKKeyboardListenerDelegate {
    public func keyboardWillShow(_ keyboardInfo: BSKKeyboardListener.KeyboardInfo) {
        guard isOpen else {
            return
        }
        guard let endFrame = keyboardInfo.frameEnd else {
            return
        }
        keyboardOldFrame = window.frame
        if window.frame.maxY > endFrame.minY {
            let offset = endFrame.minY - window.frame.maxY
            var frame = window.frame
            frame.origin.y += offset
            UIView.animate(withDuration: 0.3) {
                self.window.frame = frame
            }
        }
    }

    public func keyboardWillHide(_ keyboardInfo: BSKKeyboardListener.KeyboardInfo) {
        guard isOpen else {
            return
        }
        UIView.animate(withDuration: 0.3) {
            self.window.frame = self.keyboardOldFrame
        }
    }
}
