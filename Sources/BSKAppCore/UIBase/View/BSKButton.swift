//
//  BSKButton.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2019/8/1.
//  Copyright © 2019 cn.liuwanlin. All rights reserved.
//

import UIKit

open class BSKButton: UIButton {
    
    private var fontDic: [UIControl.State.RawValue: UIFont] = [:]
    private var bgColorDic: [UIControl.State.RawValue: UIColor] = [:]
    
    open var tapAction:((BSKButton)->Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        didInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didInit()
    }
    
    open func didInit() {
        self.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
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

    private func checkState() {
        if let font = fontDic[state.rawValue] {
            titleLabel?.font = font
        }
        if let color = bgColorDic[state.rawValue] {
            backgroundColor = color
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
        checkState()
    }

    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkState()
    }

    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        checkState()
    }
    
    open func setTapAction( _ action:@escaping (BSKButton)->Void) {
        self.tapAction = action
    }
    
    @objc private func buttonAction() {
        tapAction?(self)
    }
}
