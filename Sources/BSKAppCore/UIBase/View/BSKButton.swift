//
//  BSKButton.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2019/8/1.
//  Copyright © 2019 cn.liuwanlin. All rights reserved.
//
import UIKit
#if SPM
import BSKUtils
#endif

open class BSKButton: UIButton {
    private var fontDic: [UIControl.State.RawValue: UIFont] = [:]
    private var bgColorDic: [UIControl.State.RawValue: UIColor] = [:]

    open var tapAction: ((BSKButton) -> Void)?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        didInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didInit()
    }

    open func didInit() {
        addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }

    open func setTitleFount(_ fount: UIFont, for state: UIControl.State) {
        fontDic[state.rawValue] = fount
        stateDidChange(animated: false)
    }

    open func titleFont(for state: UIControl.State) -> UIFont? {
        return fontDic[state.rawValue]
    }

    open func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        bgColorDic[state.rawValue] = color
        if bgColorDic[UIControl.State.normal.rawValue] == nil {
            bgColorDic[UIControl.State.normal.rawValue] = backgroundColor
        }
        stateDidChange(animated: false)
    }

    open func backgroundColor(for state: UIControl.State) -> UIColor? {
        return bgColorDic[state.rawValue]
    }

    private func stateDidChange(animated: Bool = true) {
        let updateStatue = { () -> Void in
            self.titleLabel?.font = self.fontDic[self.state.rawValue] ?? self.fontDic[UIControl.State.normal.rawValue] ?? self.titleLabel?.font
            super.backgroundColor = self.bgColorDic[self.state.rawValue] ?? self.bgColorDic[UIControl.State.normal.rawValue]
        }
        if animated {
            UIView.animate(withDuration: 0.2) {
                updateStatue()
            }
        } else {
            updateStatue()
        }
    }
    
    open override var backgroundColor: UIColor? {
        set {
            self.bgColorDic[UIControl.State.normal.rawValue] = newValue
            if let newColor = newValue, self.bgColorDic[UIControl.State.highlighted.rawValue] == nil {
                self.bgColorDic[UIControl.State.highlighted.rawValue] = newColor.with(alpha: newColor.rgbaColor.alpha * 0.5)
            }
            super.backgroundColor = newValue
        }
        get {
            super.backgroundColor
        }
    }

    override open var isSelected: Bool {
        didSet {
            if !isTouchInside {
                self.stateDidChange()
            }
        }
    }

    override open var isHighlighted: Bool {
        didSet {
            if !isTouchInside {
                self.stateDidChange()
            }
        }
    }

    override open var isEnabled: Bool {
        didSet {
            if !isTouchInside {
                self.stateDidChange()
            }
        }
    }

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        stateDidChange(animated: false)
    }

    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        stateDidChange(animated: true)
    }

    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        stateDidChange(animated: true)
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        stateDidChange(animated: true)
    }
    
    open func setTapAction(_ action: @escaping (BSKButton) -> Void) {
        tapAction = action
    }

    @objc private func buttonAction() {
        tapAction?(self)
    }
}
