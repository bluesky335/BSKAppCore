//
//  BSKBaseNavigationController.swift
//  DuDuModules
//
//  Created by BlueSky335 on 2019/4/17.
//  Copyright © 2019 com.cloududu. All rights reserved.
//

import QMUIKit
import RxSwift
import UIKit

open class BSKBaseNavigationController: QMUINavigationController, Routeable {
    //    MARK: - ● Routeable

    open var request: RouteRequest!

    open var viewController: UIViewController {
        return self
    }

    open var preferTransition: RouteTransitionType {
        return .present
    }

    open lazy var disposeBag = DisposeBag()

    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        if let vc = rootViewController as? QMUINavigationControllerAppearanceDelegate {
            navigationBar.tintColor = vc.navigationBarTintColor?()
            navigationBar.barTintColor = vc.navigationBarTintColor?()
        }
    }

    public override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override var prefersStatusBarHidden: Bool {
        return self.topViewController?.prefersStatusBarHidden ?? super.prefersStatusBarHidden
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.topViewController?.preferredStatusBarStyle ?? super.preferredStatusBarStyle
    }

    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return self.topViewController?.preferredStatusBarUpdateAnimation ?? super.preferredStatusBarUpdateAnimation
    }

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.topViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }

    open override var shouldAutorotate: Bool {
        return self.topViewController?.shouldAutorotate ?? super.shouldAutorotate
    }

    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return topViewController?.preferredInterfaceOrientationForPresentation ?? super.preferredInterfaceOrientationForPresentation
    }
}
