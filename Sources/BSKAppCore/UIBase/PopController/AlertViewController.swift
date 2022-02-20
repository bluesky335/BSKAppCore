//
//  AlertViewController.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2021/11/29.
//

import SnapKit
import UIKit
#if SPM
    import BSKUtils
#endif

/// 定义Alert弹框的按钮
class AlertAction {
    enum Style: Int {
        case `default` = 0
        case cancel = 1
        case destructive = 2
    }

    /// 标题
    private(set) var title: String
    /// 类型
    private(set) var style: AlertAction.Style
    /// 按钮
    private(set) var button: UIButton
    /// 回调
    private var handler: ((AlertAction) -> Void)?
    /// 所属的控制器
    fileprivate weak var alertVC: AlertViewController?

    /// 初始化
    /// - Parameters:
    ///   - title: 标题
    ///   - style: 类型
    ///   - handler: 回调
    init(title: String, style: AlertAction.Style, handler: ((AlertAction) -> Void)? = nil) {
        self.title = title
        self.style = style
        button = BSKButton()
        if style == .destructive {
            button.setTitleColor(.systemRed, for: .normal)
        } else {
            button.setTitleColor(.systemBlue, for: .normal)
        }
        if style == .cancel {
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        } else {
            button.titleLabel?.font = .systemFont(ofSize: 17)
        }
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }

    /// 按钮事件
    @objc private func buttonAction() {
        handler?(self)
        alertVC?.dismiss(animated: true, completion: nil)
    }
}

class AlertViewController: BSKViewController, PopupableType {
    
    var popupConfig = PopupConfig()
    
    /// 类型
    enum Style: Int {
        case actionSheet = 0
        case alert = 1
    }

    /// 按钮高度
    open var buttonHeight: CGFloat = 45
    /// 输入框
    open private(set) var textFields: [UITextField]?
    /// 消息
    open var message: String?
    /// 类型
    open private(set) var preferredStyle: AlertViewController.Style = .alert
    /// 按钮
    open private(set) var actions: [AlertAction] = []
    /// 分割线颜色
    open var seperatorColor = UIColor(light: .lightGray, dark: .gray)
    /// 背景颜色
    open var backgroundColor: UIColor = UIColor(light: .red, dark: UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1)).withAlphaComponent(0.1)
    /// 背景 Effect
    open var backgroundEfect: UIVisualEffect = UIBlurEffect(style: .regular)
    /// 滚动时最大可见的按钮数量，可以是小数
    open var maxVisibleActionCountScroll: CGFloat = 6

    private(set) lazy var contentView: UIView = {
        self.contentViewLoadid = true
        return UIView()
    }()

    /// 标题label
    private(set) var titleLabel: UILabel?
    /// 消息label
    private(set) var messageLabel: UILabel?

    private lazy var contentScrollViewContent: UIView = {
        let view = UIView()
        contentScrollView.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalTo(contentScrollView.contentLayoutGuide)
            make.width.equalTo(contentScrollView.frameLayoutGuide)
            make.height.equalTo(contentScrollView.frameLayoutGuide).priority(.high)
        }
        view.addLayoutGuide(titleLayoutGuide)
        view.addLayoutGuide(messageLayoutGuide)
        view.addLayoutGuide(contentLayoutGuide)

        titleLayoutGuide.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.width.equalToSuperview()
        }

        messageLayoutGuide.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLayoutGuide.snp.bottom)
            make.width.equalToSuperview()
        }

        contentLayoutGuide.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(messageLayoutGuide.snp.bottom)
            make.width.equalToSuperview()
        }
        return view
    }()

    private lazy var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()

        contentGroupView.contentView.addSubview(scrollView)
        scrollView.alwaysBounceVertical = false
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(contentScrollViewLayoutGuide)
        }

        return scrollView
    }()

    private lazy var actionsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        contentGroupView.contentView.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(actionsScrollViewLayoutGuide)
        }
        scrollView.alwaysBounceVertical = false
        return scrollView
    }()

    private var contentScrollViewLayoutGuide = UILayoutGuide()

    private var actionsScrollViewLayoutGuide = UILayoutGuide()

    private var contentGroupView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))

    private var cancelGroupView: UIVisualEffectView?

    private var titleLayoutGuide = UILayoutGuide()

    private var messageLayoutGuide = UILayoutGuide()

    private var contentLayoutGuide = UILayoutGuide()

    private var cancellGroupLayoutGuide = UILayoutGuide()

    private var contentViewLoadid = false

    private var seperatorWidth = 0.5

    /// 初始化
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 消息
    ///   - preferredStyle: 类型
    public convenience init(title: String?, message: String?, preferredStyle: AlertViewController.Style) {
        self.init()
        self.title = title
        self.message = message
        self.preferredStyle = preferredStyle
        modalPresentationStyle = .custom
        preferredContentSize = CGSize(width: 370, height: 200)
        switch preferredStyle {
        case .alert:
            /// 按钮高度
            buttonHeight = 45
            popupConfig.contentInset = UIEdgeInsets(top: 16, left: 50, bottom: 16, right: 50)
            popupConfig.layout = .center(size: nil)
            maxVisibleActionCountScroll = 6.5
        case .actionSheet:
            /// 按钮高度
            buttonHeight = 55
            popupConfig.contentInset = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
            popupConfig.layout = .bottomCenter(size: nil)
            maxVisibleActionCountScroll = 4.5
        }
        if let title = title {
            let titleLabel = UILabel()
            titleLabel.numberOfLines = 0
            titleLabel.textAlignment = .center
            titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
            titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
            titleLabel.text = title
            self.titleLabel = titleLabel
        }
        if let message = message {
            let messageLabel = UILabel()
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.font = .systemFont(ofSize: 13)
            messageLabel.setContentCompressionResistancePriority(.required, for: .vertical)
            messageLabel.text = message
            self.messageLabel = messageLabel
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let contentGroupView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        contentGroupView.layer.cornerRadius = 15
        contentGroupView.layer.masksToBounds = true
        contentGroupView.contentView.backgroundColor = backgroundColor
        self.contentGroupView = contentGroupView
        view.addSubview(contentGroupView)
        contentGroupView.contentView.addLayoutGuide(contentScrollViewLayoutGuide)
        contentGroupView.contentView.addLayoutGuide(actionsScrollViewLayoutGuide)
        contentScrollViewLayoutGuide.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }

        actionsScrollViewLayoutGuide.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(contentScrollViewLayoutGuide.snp.bottom)
        }
        switch preferredStyle {
        case .alert:
            contentGroupView.snp.makeConstraints { make in
                make.left.top.right.bottom.equalTo(view.safeAreaLayoutGuide)
            }
        case .actionSheet:
            view.addLayoutGuide(cancellGroupLayoutGuide)
            cancellGroupLayoutGuide.snp.makeConstraints { make in
                make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
            }
            contentGroupView.snp.makeConstraints { make in
                make.left.top.right.equalTo(view.safeAreaLayoutGuide)
                make.bottom.equalTo(cancellGroupLayoutGuide.snp.top).offset(-7)
            }
        }
        if contentViewLoadid {
            contentScrollViewContent.addSubview(contentView)
            contentView.snp.makeConstraints { make in
                make.edges.equalTo(self.contentLayoutGuide)
            }
        }
        setupTitle()
        setupMessage()
        setupActions()
    }

    private func setupTitle() {
        if let titleLabel = self.titleLabel {
            contentScrollViewContent.addSubview(titleLabel)
            titleLabel.snp.makeConstraints({ make in
                make.top.equalTo(titleLayoutGuide).inset(5)
                make.left.right.equalTo(titleLayoutGuide).inset(20)
                make.bottom.equalTo(titleLayoutGuide)
                make.bottom.lessThanOrEqualTo(contentScrollViewContent).offset(-10)
            })
        }
    }

    private func setupMessage() {
        if let messageLabel = self.messageLabel {
            contentScrollViewContent.addSubview(messageLabel)
            messageLabel.snp.makeConstraints({ make in
                make.left.bottom.right.equalTo(messageLayoutGuide).inset(20)
                make.top.equalTo(messageLayoutGuide)
                make.top.greaterThanOrEqualTo(contentScrollViewContent).offset(10)
            })
        }
    }

    private func setupActions() {
        guard actions.count > 0 else {
            return
        }
        actions.forEach { item in
            item.alertVC = self
        }
        switch preferredStyle {
        case .alert:
            setupAlertActions()
        case .actionSheet:
            setupActionSheetActions()
        }
    }

    private func setupAlertActions() {
        let stackView = UIStackView()
        actionsScrollView.addSubview(stackView)

        let lineView = UIView()
        actionsScrollView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.right.equalTo(actionsScrollView.frameLayoutGuide)
            make.top.equalTo(actionsScrollView.frameLayoutGuide)
            make.height.equalTo(seperatorWidth)
        }
        lineView.backgroundColor = seperatorColor

        if actions.count > 2 {
            let count = min(CGFloat(actions.count), maxVisibleActionCountScroll)
            actionsScrollView.snp.remakeConstraints { make in
                make.edges.equalTo(actionsScrollViewLayoutGuide)
                if count < maxVisibleActionCountScroll {
                    actionsScrollView.bounces = false
                    make.height.equalTo(stackView)
                } else {
                    actionsScrollView.bounces = true
                    make.height.greaterThanOrEqualTo(count * buttonHeight)
                }
            }
            stackView.axis = .vertical
            stackView.distribution = .equalSpacing
            stackView.snp.makeConstraints { make in
                make.edges.equalTo(actionsScrollView.contentLayoutGuide)
                make.width.equalTo(actionsScrollView)
                make.height.equalTo(actionsScrollView).priority(.low)
            }
            for (index, item) in actions.enumerated() {
                if index != 0 {
                    let lineView = UIView()
                    stackView.addArrangedSubview(lineView)
                    lineView.backgroundColor = seperatorColor
                    lineView.snp.makeConstraints { make in
                        make.height.equalTo(seperatorWidth)
                    }
                }
                stackView.addArrangedSubview(item.button)
                item.button.snp.makeConstraints { make in
                    make.height.equalTo(buttonHeight)
                }
            }
        } else {
            actionsScrollView.snp.remakeConstraints { make in
                make.edges.equalTo(actionsScrollViewLayoutGuide)
                make.height.greaterThanOrEqualTo(buttonHeight)
            }
            stackView.axis = .horizontal
            stackView.distribution = .equalSpacing
            stackView.alignment = .fill
            stackView.snp.makeConstraints { make in
                make.edges.equalTo(actionsScrollView.contentLayoutGuide)
                make.width.equalTo(actionsScrollView)
                make.height.equalTo(buttonHeight)
                make.height.equalTo(actionsScrollView).priority(.low)
            }

            for (index, item) in actions.enumerated() {
                if index != 0 {
                    let lineView = UIView()
                    lineView.backgroundColor = seperatorColor
                    lineView.snp.makeConstraints { make in
                        make.width.equalTo(seperatorWidth)
                    }
                    stackView.addArrangedSubview(lineView)
                }
                stackView.addArrangedSubview(item.button)
                item.button.snp.makeConstraints { make in
                    if actions.count > 1 {
                        make.width.equalToSuperview().multipliedBy(0.5).offset(-0.25)
                    } else {
                        make.width.equalToSuperview().multipliedBy(1)
                    }
                }
            }
        }
    }

    private func setupActionSheetActions() {
        var normalActions: [AlertAction] = []
        var cancellActions: [AlertAction] = []
        actions.forEach { action in
            if action.style == .cancel {
                cancellActions.append(action)
            } else {
                normalActions.append(action)
            }
        }

        if normalActions.count > 0 {
            let stackView = UIStackView()
            actionsScrollView.addSubview(stackView)
            stackView.axis = .vertical
            stackView.distribution = .equalSpacing
            stackView.snp.makeConstraints { make in
                make.edges.equalTo(actionsScrollView.contentLayoutGuide)
                make.width.equalTo(actionsScrollView)
                make.height.equalTo(actionsScrollView).priority(.low)
            }

            let count = min(CGFloat(normalActions.count), maxVisibleActionCountScroll)
            actionsScrollView.snp.remakeConstraints { make in
                make.edges.equalTo(actionsScrollViewLayoutGuide)
                if count < maxVisibleActionCountScroll {
                    actionsScrollView.bounces = false
                    make.height.equalTo(stackView)
                } else {
                    actionsScrollView.bounces = true
                    make.height.greaterThanOrEqualTo(count * buttonHeight)
                }
            }

            let lineView = UIView()
            actionsScrollView.addSubview(lineView)
            lineView.snp.makeConstraints { make in
                make.left.right.equalTo(actionsScrollView.frameLayoutGuide)
                make.top.equalTo(actionsScrollView.frameLayoutGuide)
                make.height.equalTo(seperatorWidth)
            }
            lineView.backgroundColor = seperatorColor

            for (index, item) in normalActions.enumerated() {
                if index != 0 {
                    let lineView = UIView()
                    lineView.backgroundColor = seperatorColor
                    stackView.addArrangedSubview(lineView)
                    lineView.snp.makeConstraints { make in
                        make.height.equalTo(seperatorWidth)
                    }
                }
                stackView.addArrangedSubview(item.button)
                item.button.snp.makeConstraints { make in
                    make.height.equalTo(buttonHeight)
                }
            }
        }

        if cancellActions.count > 0 {
            let efectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
            efectView.contentView.backgroundColor = backgroundColor
            efectView.layer.cornerRadius = 15
            efectView.layer.masksToBounds = true

            cancelGroupView = efectView
            view.addSubview(efectView)
            efectView.snp.makeConstraints { make in
                make.edges.equalTo(cancellGroupLayoutGuide)
            }
            let stackView = UIStackView()
            efectView.contentView.addSubview(stackView)
            stackView.axis = .vertical
            stackView.distribution = .equalSpacing
            stackView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }

            for (index, item) in cancellActions.enumerated() {
                if index != 0 {
                    let lineView = UIView()
                    lineView.backgroundColor = seperatorColor
                    stackView.addArrangedSubview(lineView)
                    lineView.snp.makeConstraints { make in
                        make.height.equalTo(seperatorWidth)
                    }
                }
                stackView.addArrangedSubview(item.button)
                if item.button.backgroundColor == nil {
                    item.button.backgroundColor = UIColor(light: .white, dark: UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1))
                }
                item.button.snp.makeConstraints { make in
                    make.height.equalTo(buttonHeight)
                }
            }
        }
    }

    open func addAction(_ action: AlertAction) {
        actions.append(action)
    }

    open func addTextField(configurationHandler: ((UITextField) -> Void)? = nil) {
    }
}
