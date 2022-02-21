//
//  BSKKeyboardListener.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2021/8/18.
//

import UIKit

/// 键盘事件代理
public protocol BSKKeyboardListenerDelegate {
    
    func keyboardWillChangeFrame(_ keyboardInfo: BSKKeyboardListener.KeyboardInfo)

    func keyboardDidChangeFrame(_ keyboardInfo: BSKKeyboardListener.KeyboardInfo)

    func keyboardWillShow(_ keyboardInfo: BSKKeyboardListener.KeyboardInfo)

    func keyboardDidShow(_ keyboardInfo: BSKKeyboardListener.KeyboardInfo)

    func keyboardWillHide(_ keyboardInfo: BSKKeyboardListener.KeyboardInfo)

    func keyboardDidHide(_ keyboardInfo: BSKKeyboardListener.KeyboardInfo)
}

/// 默认实现
public extension BSKKeyboardListenerDelegate {
    func keyboardWillChangeFrame(_ keyboardInfo: BSKKeyboardListener.KeyboardInfo) {}
    func keyboardDidChangeFrame(_ keyboardInfo: BSKKeyboardListener.KeyboardInfo) {}
    func keyboardWillShow(_ keyboardInfo: BSKKeyboardListener.KeyboardInfo) {}
    func keyboardDidShow(_ keyboardInfo: BSKKeyboardListener.KeyboardInfo) {}
    func keyboardWillHide(_ keyboardInfo: BSKKeyboardListener.KeyboardInfo) {}
    func keyboardDidHide(_ keyboardInfo: BSKKeyboardListener.KeyboardInfo) {}
}

/// 键盘监听器
public class BSKKeyboardListener {
    /// 键盘事件
    public enum KeyboardEvent: CaseIterable {
        case willShow
        case willHide
        case didShow
        case didHide
        case didChangeFrame
        case willChangeFrame
    }

    /// 键盘信息
    public struct KeyboardInfo {
        public var animationDuration: TimeInterval?
        public var centerBegin: CGPoint?
        public var centerEnd: CGPoint?
        public var animationCurve: UIView.AnimationCurve?
        public var isLocal: Bool?
        public var frameEnd: CGRect?
        public var frameBegin: CGRect?
        public var bounds: CGRect?

        init(dic: [AnyHashable: Any]?) {
            animationDuration = dic?["UIKeyboardAnimationDurationUserInfoKey"] as? TimeInterval
            centerBegin = dic?["UIKeyboardCenterBeginUserInfoKey"] as? CGPoint
            centerEnd = dic?["UIKeyboardCenterEndUserInfoKey"] as? CGPoint
            animationCurve = UIView.AnimationCurve(rawValue: (dic?["UIKeyboardAnimationCurveUserInfoKey"] as? Int) ?? Int.max)
            isLocal = dic?["UIKeyboardIsLocalUserInfoKey"] as? Bool
            frameEnd = dic?["UIKeyboardFrameEndUserInfoKey"] as? CGRect
            frameBegin = dic?["UIKeyboardFrameBeginUserInfoKey"] as? CGRect
            bounds = dic?["UIKeyboardBoundsUserInfoKey"] as? CGRect
        }
    }

    public var delegate: BSKKeyboardListenerDelegate?

    let events: [KeyboardEvent]
    
    /// 初始化一个键盘监听器
    /// - Parameters:
    ///   - delegate: 键盘事件代理
    ///   - events: 要监听的事件
    public init(delegate: BSKKeyboardListenerDelegate? = nil, events: [KeyboardEvent]) {
        self.delegate = delegate
        self.events = events
    }

    deinit {
        stop()
    }
    
    /// 开始监听
    public func start() {
        if events.contains(.willShow) {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        }

        if events.contains(.willHide) {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }

        if events.contains(.didShow) {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        }

        if events.contains(.didHide) {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        }

        if events.contains(.didChangeFrame) {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        }

        if events.contains(.willChangeFrame) {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        }
    }
    
    /// 停止监听
    public func stop() {
        if events.contains(.willShow) {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        }
        if events.contains(.willHide) {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        if events.contains(.didShow) {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        }
        if events.contains(.didHide) {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
        }
        if events.contains(.didChangeFrame) {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        }
        if events.contains(.willChangeFrame) {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        }
    }

    @objc private func keyboardWillChangeFrame(_ notify: Notification) {
        let info = KeyboardInfo(dic: notify.userInfo)
        delegate?.keyboardWillChangeFrame(info)
    }

    @objc private func keyboardDidChangeFrame(_ notify: Notification) {
        let info = KeyboardInfo(dic: notify.userInfo)
        delegate?.keyboardDidChangeFrame(info)
    }

    @objc private func keyboardWillShow(_ notify: Notification) {
        let info = KeyboardInfo(dic: notify.userInfo)
        delegate?.keyboardWillShow(info)
    }

    @objc private func keyboardDidShow(_ notify: Notification) {
        let info = KeyboardInfo(dic: notify.userInfo)
        delegate?.keyboardDidShow(info)
    }

    @objc private func keyboardWillHide(_ notify: Notification) {
        let info = KeyboardInfo(dic: notify.userInfo)
        delegate?.keyboardWillHide(info)
    }

    @objc private func keyboardDidHide(_ notify: Notification) {
        let info = KeyboardInfo(dic: notify.userInfo)
        delegate?.keyboardDidHide(info)
    }
}
