//
//  BSKCheckButton.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2019/8/4.
//  Copyright © 2019 cn.liuwanlin. All rights reserved.
//

import UIKit

open class BSKCheckButton: BSKButton {


    open override func didInit(){
        super.didInit()
        self.addTarget(self, action: #selector(selectedAction(_:)), for: .touchUpInside)
    }

    @objc private func selectedAction(_ sender:BSKRadioButton){
        self.isSelected = !self.isSelected
    }

}
