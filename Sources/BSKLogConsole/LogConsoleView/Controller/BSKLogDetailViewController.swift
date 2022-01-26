//
//  BSKLogDetailViewController.swift
//  
//
//  Created by 刘万林 on 2021/9/14.
//

import UIKit
#if SPM
import BSKLog
#endif

class BSKLogDetailViewController: LogBaseViewController {
    var log: BSKLogObject
    private var dateFormater: DateFormatter = DateFormatter()
    private var infoLabel = UILabel()
    private var logTextView = UITextView()
    private var infoView = UIView()

    init(log: BSKLogObject) {
        self.log = log
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        transitionCoordinator?.animate(alongsideTransition: { _ in
            self.view.backgroundColor = .black.withAlphaComponent(0.5)
        }, completion: { _ in

        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        title = log.level.flag
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        logTextView.translatesAutoresizingMaskIntoConstraints = false
        infoView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(infoView)
        infoView.addSubview(infoLabel)
        view.addSubview(logTextView)

        infoView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        infoView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        infoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        infoView.backgroundColor = .black.withAlphaComponent(0.2)

        infoLabel.leftAnchor.constraint(equalTo: infoView.leftAnchor, constant: 5).isActive = true
        infoLabel.rightAnchor.constraint(equalTo: infoView.rightAnchor, constant: -5).isActive = true
        infoLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 5).isActive = true
        infoLabel.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -5).isActive = true
        let height = infoLabel.heightAnchor.constraint(equalToConstant: 44)
        height.isActive = true
        height.priority = .defaultLow

        infoLabel.font = .systemFont(ofSize: 12)
        infoLabel.textColor = UIColor.lightGray
        infoLabel.numberOfLines = 0
        logTextView.isEditable = false
        logTextView.backgroundColor = .clear
        logTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive = true
        logTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5).isActive = true
        logTextView.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: 0).isActive = true
        logTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        logTextView.font = .systemFont(ofSize: 11)
        logTextView.textColor = UIColor.lightGray
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        setLog(log: log)

        let copyItem = UIBarButtonItem(image: UIImage(inFramwork: "log_copy"), style: .plain, target: self, action: #selector(copyLog))
        self.navigationItem.rightBarButtonItem = copyItem
    }

    func setLog(log: BSKLogObject) {
        let timeZone = dateFormater.timeZone.secondsFromGMT() / 3600
        let file = log.file
        let timeZoneStr = "\(timeZone > 0 ? "+" : "")\(timeZone)"
        infoLabel.text = """
        \(dateFormater.string(from: log.date)) \(timeZoneStr) \(log.threadInfo)
        \(file):\(log.line)
        \(log.function)
        """
        logTextView.text = log.log
        switch log.level {
        case .success:
            logTextView.textColor = .systemGreen
        case .debug:
            logTextView.textColor = .lightGray
        case .log:
            logTextView.textColor = .white
        case .warn:
            logTextView.textColor = .systemYellow
        case .error:
            logTextView.textColor = .systemRed
        case .severe:
            logTextView.textColor = .systemPink
        }
    }

     @objc private func copyLog() {
        UIPasteboard.general.string = self.logTextView.text
    }
}
