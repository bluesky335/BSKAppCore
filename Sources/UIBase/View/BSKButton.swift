//
//  BSKButton.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2019/8/1.
//  Copyright © 2019 cn.liuwanlin. All rights reserved.
//

import UIKit

open class BSKButton: UIButton {

//     TODO: 完成不同状态下的字体
    private var fontDic:[UIControl.State.RawValue:UIFont] = [:]
    private var bgColorDic:[UIControl.State.RawValue:UIColor] = [:]

    open func setTitleFount(_ fount:UIFont,for state:UIControl.State){
        fontDic[state.rawValue] = fount
        checkState()
    }
    open func setBackgroundColor(_ color:UIColor,for state:UIControl.State){
        bgColorDic[state.rawValue] = color
        checkState()
    }
    
    private func checkState(){
        if let font = self.fontDic[self.state.rawValue] {
            self.titleLabel?.font = font
        }
        if let color = self.bgColorDic[self.state.rawValue] {
            self.backgroundColor = color
        }
    }
    
    open override var isSelected: Bool{
        didSet{
            self.checkState()
        }
    }
    
    open override var isHighlighted: Bool{
        didSet{
            self.checkState()
        }
    }
    
    open override var isEnabled: Bool{
        didSet{
            self.checkState()
        }
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.checkState()
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        self.checkState()
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.checkState()
    }



}
