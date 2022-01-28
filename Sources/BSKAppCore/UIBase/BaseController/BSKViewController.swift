//
//  BSKViewController.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2021/9/29.
//

import UIKit

/// 基础控制器
open class BSKViewController:UIViewController {
    
    /// 点击空白处结束编辑
    open var endEditingWhenTouch = true
    /// 状态栏颜色
    open var statusBarStyle: UIStatusBarStyle? = nil
    /// 是否已经执行过viewDidAppear
    public private(set) var isViewDidAppear: Bool = false
    /// 是否已经执行过viewDidLoad
    public private(set) var isViewDidLoad: Bool = false

    public override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        didInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        didInit()
    }
    
    open func didInit() {
        
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        isViewDidLoad = true
        self.view.backgroundColor = UIColor(light: .white, dark: UIColor(RGB: 0x444444))
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isViewDidAppear = true
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if endEditingWhenTouch {
            view.endEditing(true)
        }
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle ?? super.preferredStatusBarStyle
    }

}
