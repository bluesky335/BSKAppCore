//
//  BSKLogFilePreviewController.swift
//  
//
//  Created by 刘万林 on 2021/9/16.
//

import UIKit
#if SPM
import BSKLog
import BSKUtils
#endif

class BSKLogFilePreviewController: LogBaseViewController {
    private let tableView = UITableView()

    private let loadingView = UIActivityIndicatorView(style: .medium)

    private var logs: [BSKLogObject] = []

    private let logFileDestination: BSKLogFileDestination
    
    private let fileURL:URL
    
    private lazy var exportItem = UIBarButtonItem(image: UIImage(inFramwork: "log_export"), style: .plain, target: self, action: #selector(exportLog))

    init(fileURL:URL,logFileDestination: BSKLogFileDestination) {
        self.logFileDestination = logFileDestination
        self.fileURL = fileURL
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        setupTableView()
        setupLoadingView()
        title = try? fileURL.path.subString(from: NSHomeDirectory())
        loadData()
        self.navigationItem.rightBarButtonItem = exportItem
    }

    /// 从文件加载数据
    func loadData() {
        loadingView.startAnimating()
        DispatchQueue(label: "readLog").async {
            guard let fileReader = BSKFileReader(path: self.fileURL.path) else {
                return
            }
            var logs: [BSKLogObject] = []
            while let line = fileReader.nextLine() {
                guard let log = self.logFileDestination.LogFrom(logStr: line) else {
                    continue
                }
                logs.append(log)
            }
            self.logs = logs
            DispatchQueue.main.async {
                self.loadingView.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }

    func setupLoadingView() {
        loadingView.backgroundColor = .black.withAlphaComponent(0.5)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        loadingView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        loadingView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.register(BSKLogTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
    }
    
     @objc private func exportLog() {
        let vc =  UIDocumentInteractionController(url: fileURL)
        vc.uti = "public.text"
        vc.presentOptionsMenu(from: self.exportItem, animated: true)
    }
}

// MARK: - datasource delegate

extension BSKLogFilePreviewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let logCell = cell as? BSKLogTableViewCell {
            logCell.setLog(log: logs[indexPath.row])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let log = logs[indexPath.row]
        let vc = BSKLogDetailViewController(log: log)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
