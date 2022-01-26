//  LimitTextView.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2021/3/18.
//
import UIKit

private class BSKLimitTextDelegator: NSObject, UITextViewDelegate {
    weak var delegate: UITextViewDelegate?

    @available(iOS 2.0, *)
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return delegate?.textViewShouldBeginEditing?(textView) ?? true
    }

    @available(iOS 2.0, *)
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return delegate?.textViewShouldEndEditing?(textView) ?? true
    }

    @available(iOS 2.0, *)
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.textViewDidBeginEditing?(textView)
    }

    @available(iOS 2.0, *)
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.textViewDidEndEditing?(textView)
    }

    @available(iOS 2.0, *)
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let view = textView as? BSKLimitTextView, let maxLength = view.maxTextLength {
            var markedTextCount = 0
            if let markedTextRange = view.markedTextRange {
                let markedText = view.text(in: markedTextRange)
                markedTextCount = markedText?.count ?? 0
            }
            if text.count > 0, view.text.count - markedTextCount >= maxLength {
                return false
            }
        }

        return delegate?.textView?(textView, shouldChangeTextIn: range, replacementText: text) ?? true
    }

    @available(iOS 2.0, *)
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textViewDidChange?(textView)
    }

    @available(iOS 2.0, *)
    func textViewDidChangeSelection(_ textView: UITextView) {
        delegate?.textViewDidChangeSelection?(textView)
    }

    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return delegate?.textView?(textView, shouldInteractWith: URL, in: characterRange, interaction: interaction) ?? true
    }

    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return delegate?.textView?(textView, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction) ?? true
    }

    @available(iOS, introduced: 7.0, deprecated: 10.0)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return delegate?.textView?(textView, shouldInteractWith: URL, in: characterRange) ?? true
    }

    @available(iOS, introduced: 7.0, deprecated: 10.0)
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {
        return delegate?.textView?(textView, shouldInteractWith: textAttachment, in: characterRange) ?? true
    }
}

/// 支持Placeholder 和 长度限制的 TextView
open class BSKLimitTextView: UITextView {
    // MARK: - 公开的属性

    /// 代理，设置时按原有方式设置，获取时将返回一个 LimitTextDelegater，你设置的代理对象保存在它的delegate属性中
    override open var delegate: UITextViewDelegate? {
        get {
            return delegator
        }
        set {
            delegator.delegate = newValue
        }
    }

    /// 占位符
    open var placeholder: String? {
        didSet {
            if let text = placeholder, text.count > 0 {
                placeHolderLabel.isHidden = false
                placeHolderLabel.text = text
            } else {
                placeHolderLabel.isHidden = true
            }
        }
    }

    /// 最大可输入文字长度
    open var maxTextLength: Int? {
        didSet {
            updateTextLimit()
        }
    }

    /// 背景颜色
    override open var backgroundColor: UIColor? {
        didSet {
            textLimitLabelBackground.backgroundColor = backgroundColor
        }
    }

    /// 内容边距
    override open var contentInset: UIEdgeInsets {
        get {
            return customContentInset
        }
        set {
            customContentInset = newValue
        }
    }

    /// 显示文字限制的Label
    private(set) public lazy var textLimitLabel: UILabel = {
        let label = UILabel()
        self.textLimitLabelBackground.addSubview(label)
        return label
    }()

    /// 显示文字限制的Label的容器，当不希望显示下面的限制字数和且期望去掉底部的边距时请隐藏此视图
    private(set) public lazy var textLimitLabelBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        self.addSubview(view)
        return view
    }()

    /// 文字为空的时候显示的占位符Label
    private(set) public lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)

        placeHolderTop = label.topAnchor.constraint(equalTo: self.topAnchor, constant: self.textContainerInset.top)
        placeHolderTop?.isActive = true
        placeHolderLeft = label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.textContainerInset.left + 5)
        placeHolderLeft?.isActive = true
        
        label.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -self.textContainerInset.right - 5 - self.textContainerInset.left - 5).isActive = true
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    /// 文字内边距
    override open var textContainerInset: UIEdgeInsets {
        didSet {
            self.placeHolderLeft?.constant = self.textContainerInset.left + 5
            self.placeHolderTop?.constant = self.textContainerInset.top
        }
    }
    
    open func showLimitTextLabel(_ show:Bool ) {
        self.textLimitLabelBackground.alpha = show ? 1 : 0
        self.setNeedsLayout()
    }

    // MARK: - 私有属性

    /// 中间代理，捕获原生代理，处理事件，然后将其转发出去。
    private var delegator: BSKLimitTextDelegator = BSKLimitTextDelegator()
    /// 自定义的内容边距，因为底部文字长度提示的存在，真实的ContentInset和自定义设置的有一定差距，这个属性用于保存自定义设置的inset
    private var customContentInset: UIEdgeInsets = .zero

    private var placeHolderTop: NSLayoutConstraint?

    private var placeHolderLeft: NSLayoutConstraint?

    // MARK: - 重载系统的方法

    override init(frame: CGRect = .zero, textContainer: NSTextContainer? = nil) {
        super.init(frame: frame, textContainer: textContainer)
        initView()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        updateTextLimitLabelFrame()
    }
    
    open override var text: String! {
        set {
            super.text = newValue
            textDidChange()
        }
        get {
            return super.text
        }
    }

    // MARK: - 私有方法

    private func updateTextLimit() {
        var textCount = "\(text.count)"

        if let maxLength = maxTextLength {
            if text.count > maxLength, markedTextRange == nil {
                text = String(text[..<text.index(text.startIndex, offsetBy: maxLength)])
            }
            textCount = "\(text.count)/\(maxLength)"
        }
        textLimitLabel.text = textCount
        updateTextLimitLabelFrame()
    }

    private func updateTextLimitLabelFrame() {
        textLimitLabel.sizeToFit()
        var frame = textLimitLabel.frame
        frame.origin.x = self.frame.width - textContainerInset.right - frame.width - 5
        frame.origin.y = 5
        textLimitLabel.frame = frame

        textLimitLabelBackground.frame = CGRect(x: 0,
                                                y: self.frame.height - frame.height - 10 + contentOffset.y,
                                                width: self.frame.width,
                                                height: frame.height + 10)
        var inset = contentInset
        if !(textLimitLabelBackground.isHidden || textLimitLabelBackground.alpha == 0) && !textLimitLabel.isHidden {
            inset.bottom += frame.height + 10
        }
        super.contentInset = inset
    }

    private func initView() {
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: self)
        super.delegate = delegator
    }

    @objc private func textDidChange() {
        updateTextLimit()
        if placeholder != nil {
            placeHolderLabel.isHidden = text.count > 0
        }
    }
}
