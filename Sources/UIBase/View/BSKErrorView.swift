//
//  BSKErrorView.swift
//  BSKAppCore
//
//  Created by BlueSky335 on 2019/3/7.
//  Copyright © 2019 ChaungMiKeJi. All rights reserved.
//

import UIKit
import SnapKit

class BSKErrorView: UIView {

    var buttonAction:(()->Void)?
    
    var isTapCrouse:Bool = true //是否点击穿透
    
    var info:String?{
        set{
            infoLabel.text = newValue
        }
        get{
            return infoLabel.text
        }
    }
    
    var suInfo:String?{
        set{
            suInfoLabel.text = newValue
        }
        get{
            return suInfoLabel.text
        }
    }
    
    var image:UIImage?{
        set{
            errorImage.image = newValue
        }
        get{
            return errorImage.image
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.errorImage)
        self.addSubview(self.infoLabel)
        self.addSubview(self.suInfoLabel)
        self.addSubview(self.actionButton)
        
        self.errorImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-75)
        }
        
        self.infoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.errorImage.snp.bottom)
            make.left.right.equalToSuperview().inset(16)
        }
        
        self.suInfoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.infoLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
        }
        
        self.actionButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.suInfoLabel.snp.bottom).offset(20)
            make.width.equalTo(120)
            make.height.equalTo(32)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func buttonAction(sender:UIButton) {
        if let callBack = buttonAction{
            callBack()
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == self {
            return nil
        }
        return view
    }
    
    
    lazy var errorImage: UIImageView = {
        let errorImage = UIImageView()
        return errorImage
    }()
    
    lazy var infoLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.textColor = UIColor.darkText
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        infoLabel.textAlignment = NSTextAlignment.center
        return infoLabel
    }()
    
    lazy var suInfoLabel: UILabel = {
        let suInfoLabel = UILabel()
        suInfoLabel.textColor = UIColor.lightGray
        suInfoLabel.font = UIFont.systemFont(ofSize: 12)
        suInfoLabel.textAlignment = NSTextAlignment.center
        return suInfoLabel
    }()
    
    lazy var actionButton: UIButton = {
        let actionButton = UIButton(type: .custom)
        actionButton.backgroundColor   = UIColor.white
        actionButton.setTitleColor(UIColor.blue, for: .normal)
        actionButton.cornerRadius = 16
        actionButton.borderColor = UIColor.blue
        actionButton.borderWidth = 1
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        actionButton.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        return actionButton
    }()
    
}
