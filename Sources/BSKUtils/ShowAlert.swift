//
//  ShowAlert.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2022/8/22.
//

import UIKit
/// 构建一个 UIAlertController
/// - Parameters:
///   - title: 标题
///   - message: 消息
///   - style: 样式
/// - Returns: 构建器
public func BuildAlert(title: String?, message: String, style: UIAlertController.Style) -> AlertBuilder {
    return AlertBuilder(title: title, message: message, style: style)
}

/// 快捷构建UIAlertController弹窗的工具类
public class AlertBuilder {
    public struct AlertResult: Equatable {
        public let name: String
        public static let ok = AlertResult(name: "ok")
        public static let cancel = AlertResult(name: "cancel")
        public static let destructive = AlertResult(name: "destructive")
    }

    private var callbackDic: [String: () -> Void] = [:]

    private var okCallback: (() -> Void)?
    private var cancelCallback: (() -> Void)?
    private var destructiveCallback: (() -> Void)?

    private var actions: [(title: String, style: UIAlertAction.Style, result: AlertResult)] = []

    private(set) var title: String?
    private(set) var message: String?
    private(set) var style: UIAlertController.Style

    init(title: String?, message: String?, style: UIAlertController.Style) {
        self.title = title
        self.message = message
        self.style = style
    }

    private func onAction(result: AlertResult) {
        switch result {
        case .ok:
            okCallback?()
        case .cancel:
            cancelCallback?()
        case .destructive:
            destructiveCallback?()
        default:
            break
        }
    }

    public func addAction(title: String, style: UIAlertAction.Style = .default, result: AlertResult) -> AlertBuilder {
        actions.append((title, style, result))
        return self
    }
    
    /// 添加OK选项
    /// - Parameters:
    ///   - title: 标题
    ///   - style: 样式，默认 .cancel
    /// - Returns: 返回 Builder
    public func addOkAction(title: String, style: UIAlertAction.Style = .cancel) -> AlertBuilder {
        return addAction(title: title, style: style, result: .ok)
    }

    public func addCancelAction(title: String, style: UIAlertAction.Style = .cancel) -> AlertBuilder {
        return addAction(title: title, style: style, result: .cancel)
    }

    public func addDestructiveAction(title: String, style: UIAlertAction.Style = .destructive) -> AlertBuilder {
        return addAction(title: title, style: .destructive, result: .destructive)
    }

    public func onOK(_ callback: @escaping () -> Void) -> AlertBuilder {
        okCallback = callback
        return self
    }

    public func onCancel(_ callback: @escaping () -> Void) -> AlertBuilder {
        cancelCallback = callback
        return self
    }

    public func onDestructive(_ callback: @escaping () -> Void) -> AlertBuilder {
        destructiveCallback = callback
        return self
    }

    @MainActor
    public func showForResult() async -> AlertResult {
        return await withCheckedContinuation { continueation in
            showWith { result in
                continueation.resume(returning: result)
            }
        }
    }

    public func show() {
        showWith(callback: nil)
    }

    private func showWith(callback: ((AlertResult) -> Void)?) {
        let vc = UIAlertController(title: title, message: message, preferredStyle: style)
        for item in actions {
            vc.addAction(UIAlertAction(title: item.title, style: item.style, handler: {  _ in
                self.onAction(result: item.result)
                callback?(item.result)
            }))
        }
        UIApplication.shared.bsk.topViewController?.present(vc, animated: true)
    }
}
