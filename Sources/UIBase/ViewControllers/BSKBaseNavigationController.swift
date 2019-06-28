//
//  BSKBaseNavigationController.swift
//  DuDuModules
//
//  Created by BlueSky335 on 2019/4/17.
//  Copyright © 2019 com.cloududu. All rights reserved.
//

import UIKit
import QMUIKit
import RxSwift

open class BSKBaseNavigationController: QMUINavigationController,Routeable {
    
    public var request: RouteRequest!
    
    open lazy var disposeBag = DisposeBag()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override public init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        if let vc = rootViewController as? QMUINavigationControllerAppearanceDelegate {
            self.navigationBar.tintColor = vc.navigationBarTintColor?()
            self.navigationBar.barTintColor = vc.navigationBarTintColor?()
        }
    }
    
    override public  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open var prefersStatusBarHidden: Bool{
        return self.topViewController?.prefersStatusBarHidden ?? super.prefersStatusBarHidden
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle{
        return self.topViewController?.preferredStatusBarStyle ?? super.preferredStatusBarStyle
    }
    
    override open var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return self.topViewController?.preferredStatusBarUpdateAnimation ?? super.preferredStatusBarUpdateAnimation
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.topViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }
    
    override open var shouldAutorotate: Bool{
        return self.topViewController?.shouldAutorotate ?? super.shouldAutorotate
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return self.topViewController?.preferredInterfaceOrientationForPresentation ?? super.preferredInterfaceOrientationForPresentation
    }

}
