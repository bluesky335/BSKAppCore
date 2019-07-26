//
//  BSKBaseViewController.swift
//  DuDuModules
//
//  Created by BlueSky335 on 2019/4/15.
//  Copyright © 2019 com.cloududu. All rights reserved.
//

import UIKit
import QMUIKit
import RxSwift
import BSKConsole

open class BSKBaseViewController: QMUICommonViewController,Routeable {
    
    //    MARK: - ● Routeable
    
    open var request: RouteRequest!
    
    open var viewController: UIViewController{
        return self
    }
    
    open var preferTransition: RouteTransitionType = .push
    
    /// 当作为NavigationController的rootViewController时也显示返回按钮
    open var alwaysShowNavBackButton:Bool = false
    
    var shouldHideKeyBoardWhenTouchBegan: Bool = true
    
    open lazy var disposeBag = DisposeBag()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        if alwaysShowNavBackButton {
            if self.navigationController?.qmui_rootViewController() == self {
                let fixedSpace = UIBarButtonItem.qmui_fixedSpaceItem(withWidth: 0)
                let backButton = UIBarButtonItem.qmui_back(withTarget: self,
                                                           action: #selector(backAction(_:)))
                self.navigationItem.leftBarButtonItems = [fixedSpace, backButton]
            }
        }
        self.view.backgroundColor = UIColor.white
    }
    
    @objc private func backAction(_ sender:Any){
        if self.navigationController == nil,self.presentationController != nil {
            self.dismiss(animated: true, completion: nil)
        }else if self.navigationController?.qmui_rootViewController() == self,
            self.navigationController?.presentationController != nil{
            self.navigationController?.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if shouldHideKeyBoardWhenTouchBegan {
            self.view.endEditing(true)
        }
    }
    
    override open func navigationBarBackgroundImage() -> UIImage? {
        return UIImage(color: UIColor.white)
    }
    
    override open func navigationBarShadowImage() -> UIImage? {
        return UIImage(color: UIColor.clear,size: CGSize(width: 0.5, height: 0.5))
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override open func navigationBarTintColor() -> UIColor? {
        return UIColor.darkText
    }
    
    override open func navigationBarBarTintColor() -> UIColor? {
        return UIColor.white
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .all
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .portrait
    }
    
    override open var prefersStatusBarHidden: Bool{
        return false
    }
    
    override open func preferredNavigationBarHidden() -> Bool {
        return false
    }
    
    override open func backBarButtonItemTitle(withPreviousViewController viewController: UIViewController?) -> String? {
        return ""
    }
    
    override open func shouldCustomizeNavigationBarTransitionIfHideable() -> Bool {
        return true
    }
    
    #if DEBUG
    
    //    MARK: - ● injectionIII调试
    
    @objc private func initializeUI(){
        
    }
    
    @objc open func injected(){
        BSKConsole.warning("💉注射成功->: \(self)")
        if self.responds(to: #selector(initializeUI)) {
            self.perform( #selector(initializeUI))
        }
    }
    
    #endif
    
    
}
