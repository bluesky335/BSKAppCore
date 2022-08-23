//
//  ShowAlertDemo.swift
//  Demo
//
//  Created by 刘万林 on 2022/8/23.
//

import BSKAppCore
import UIKit

class ShowAlertDemoController: BSKViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let alertButton = UIButton()
        alertButton.setTitleColor(UIColor.systemBlue, for: .normal)
        alertButton.setTitle("alert", for: .normal)
        alertButton.addTarget(self, action: #selector(alertAction(_:)), for: .touchUpInside)

        let alertAsyncButton = UIButton()
        alertAsyncButton.setTitleColor(UIColor.systemBlue, for: .normal)
        alertAsyncButton.setTitle("alert async", for: .normal)
        alertAsyncButton.addTarget(self, action: #selector(alertAsyncAction(_:)), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [
            alertButton, alertAsyncButton,
        ])
        stackView.axis = .vertical

        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    @objc func alertAction(_ action: UIAction) {
        BuildAlert(title: "提示", message: "消息", style: .alert)
            .okAction(title: "👌")
            .cancelAction(title: "❌")
            .destructiveAction(title: "⚠️")
            .onOK {
                print("callBack:👌")
            }.onCancel {
                print("callBack:❌")
            }.onDestructive {
                print("callBack:⚠️")
            }.show()
    }

    @objc func alertAsyncAction(_ action: UIAction) {
        Task {
            let result = await BuildAlert(title: "提示", message: "消息", style: .alert)
                .okAction(title: "👌")
                .cancelAction(title: "❌")
                .destructiveAction(title: "⚠️")
                .onOK {
                    print("callBack:👌")
                }.onCancel {
                    print("callBack:❌")
                }.onDestructive {
                    print("callBack:⚠️")
                }.showForResult()
            switch result {
            case .ok:
                print("👌")
            case .cancel:
                print("❌")
            case .destructive:
                print("⚠️")
            default:
                break
            }
        }
    }
}
