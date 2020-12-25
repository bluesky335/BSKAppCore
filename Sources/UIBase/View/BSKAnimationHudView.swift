//
//  BSKAnimationHudView.swift
//  BSKAppCore
//
//  Created by BlueSky335 on 2018/7/4.
//  Copyright © 2018年 ChaungMiKeJi. All rights reserved.
//
import Foundation

class BSKAnimationHudView: UIImageView {

    static public var animationImages:[UIImage] = []

    private var myWindow: UIWindow?
    private lazy var imageAnimationView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode           = .scaleAspectFit
        imageView.animationImages       = BSKAnimationHudView.animationImages
        imageView.animationDuration     = 1
        imageView.animationRepeatCount  = 0
        return imageView
    }()

//    private lazy var lottieAnimationView: LOTAnimationView = {
//        var bundle:Bundle = .main
//        if let path = Bundle.main.path(forResource: "LoadingAnimationResources", ofType: "bundle"){
//            bundle = Bundle(path: path) ?? .main
//        }
//        let lottieView = LOTAnimationView(name: "loadingAnimation", bundle: bundle)
//        lottieView.loopAnimation = true
//        return lottieView
//    }()

    private var animationView: UIView {
        return imageAnimationView as UIView
    }

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    @discardableResult
    static func showLoadingAnimation(in view: UIView?, with text: String? = nil) -> BSKAnimationHudView {
        let hud = BSKAnimationHudView()
        hud.backgroundColor = UIColor.white

        hud.showLoadingAnimation(in: view)
        return hud
    }

    static func hide(in view: UIView) {
        for subview in view.subviews {
            if let hud = subview as? BSKAnimationHudView {
                hud.hide()
            }
        }
    }

    func hide() {
        BSKUtils.runOnMainThread {
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 0
            }, completion: { [weak self] _ in
                if let window = self?.myWindow {
                    window.removeFromSuperview()
                    self?.myWindow = nil
                }

                self?.stopLoadingAnimation()

                self?.removeFromSuperview()
            })
        }
    }

    override init(image:UIImage? = nil) {
        super.init(image: image)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    func initialize() {
        isUserInteractionEnabled = true
        addSubview(animationView)
        animationView.snp.makeConstraints {
            maker in//140*24
            maker.center.equalTo(self)
        }
        layer.masksToBounds = true
        alpha = 0
    }

    func showLoadingAnimation(in view: UIView?, with text: String? = nil) {
        if let view = view {
            view.addSubview(self)
            snp.makeConstraints { maker in
                maker.left.right.top.bottom.equalTo(view)
            }
        } else {
            let aWindow = UIWindow()
            aWindow.windowLevel = UIWindow.Level.statusBar
            aWindow.backgroundColor = UIColor.clear
            myWindow = aWindow
            aWindow.addSubview(self)
            snp.makeConstraints { maker in
                maker.left.right.top.bottom.equalTo(aWindow)
            }
            aWindow.makeKeyAndVisible()
        }

        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1
        })

        startLoadingAnimation()
    }

    private func startLoadingAnimation() {
        if let view = animationView as? UIImageView {
            view.startAnimating()
        }
//        else if let view = animationView as? LOTAnimationView {
//            view.play()
//        }
    }

    private func stopLoadingAnimation() {
        if let view = animationView as? UIImageView {
            view.stopAnimating()
            view.animationImages = nil
        }
//        else if let view = animationView as? LOTAnimationView {
//            view.stop()
//        }
    }
}
