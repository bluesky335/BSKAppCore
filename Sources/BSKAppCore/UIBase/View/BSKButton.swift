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
        checkState()
    }

    open func titleFont(for state: UIControl.State) -> UIFont? {
        return fontDic[state.rawValue]
    }

    open func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        bgColorDic[state.rawValue] = color
        checkState()
    }

    open func backgroundColor(for state: UIControl.State) -> UIColor? {
        return bgColorDic[state.rawValue]
    }

    private func checkState(animated: Bool = false) {
        let updateStatue = { () -> Void in
            if let font = self.fontDic[self.state.rawValue] {
                self.titleLabel?.font = font
            }
            if let color = self.bgColorDic[self.state.rawValue] {
                self.backgroundColor = color
            }
        }
        if animated {
            UIView.animate(withDuration: 0.3) {
                updateStatue()
            }
        } else {
            updateStatue()
        }
    }

    override open var isSelected: Bool {
        didSet {
            self.checkState()
        }
    }

    override open var isHighlighted: Bool {
        didSet {
            self.checkState()
        }
    }

    override open var isEnabled: Bool {
        didSet {
            self.checkState()
        }
    }

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkState(animated: true)
    }

    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkState(animated: true)
    }

    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        checkState(animated: true)
    }

    open func setTapAction(_ action: @escaping (BSKButton) -> Void) {
        tapAction = action
    }

    @objc private func buttonAction() {
        tapAction?(self)
    }
}
