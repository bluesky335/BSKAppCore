//
//  LogViewController.swift
//  iOS Test
//
//  Created by 刘万林 on 2021/8/31.
//

import UIKit
#if SPM
import BSKLog
#endif

fileprivate var filterLevel = Set(BSKLogObject.Level.allCases)

class BSKLogViewController: LogBaseViewController {
    let tableView = UITableView()

    var logs: [BSKLogObject] = []

    var filterKeyword: String?

    var logCachePool: [BSKLogObject] = []

    // 保持在底部
    var keepBottom = true

    lazy var filterItem = UIBarButtonItem(image: UIImage(inFramwork: "log_filter"), style: .plain, target: self, action: #selector(filterAction))

    lazy var exportItem = UIBarButtonItem(image: UIImage(inFramwork: "log_export"), style: .plain, target: self, action: #selector(exportAtion))

    lazy var topItem = UIBarButtonItem(image: UIImage(inFramwork: "log_top"), style: .plain, target: self, action: #selector(topAction))

    lazy var bottomItem = UIBarButtonItem(image: UIImage(inFramwork: "log_bottom"), style: .plain, target: self, action: #selector(bottomAtion(sender:)))

    lazy var deleteItem = UIBarButtonItem(image: UIImage(inFramwork: "log_delete"), style: .plain, target: self, action: #selector(deleteAtion))

    lazy var toolItem = UIBarButtonItem(image: UIImage(inFramwork: "log_tool"), style: .plain, target: self, action: #selector(openToolAction))

    lazy var closeItem = UIBarButtonItem(image: UIImage(inFramwork: "log_close"), style: .plain, target: self, action: #selector(closeAction))

    lazy var searchTextField: UISearchBar = {
        let search = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width / 2, height: 50))
        search.backgroundColor = .darkGray.withAlphaComponent(0.6)
        search.returnKeyType = .search
        search.placeholder = "搜索"
        search.barStyle = .black
        search.delegate = self
        let image = UIImage(inFramwork: "log_search")?.withTintColor(.lightGray)
        search.setImage(image, for: .search, state: .normal)
        return search
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        navigationItem.leftBarButtonItems = [closeItem, toolItem]
        navigationItem.titleView = searchTextField
        navigationItem.rightBarButtonItems = [exportItem]
        toolbarItems = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), filterItem, topItem, bottomItem, deleteItem, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)]
        bottomItem.tintColor = .systemBlue
        BSKLogViewManager.share.dataSource.delegate = self
        loadLogs()
        updateFilterItemColor()
        setupTableView()
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

    func loadLogs() {
        logs = BSKLogViewManager.share.dataSource.logs.filter({ log -> Bool in
            guard filterLevel.contains(log.level) else {
                return false
            }
            if let keyword = filterKeyword, keyword.count > 0 {
                guard log.log.contains(keyword) else {
                    return false
                }
            }
            return true
        })
    }

    func updateFilterItemColor() {
        filterItem.tintColor = filterLevel == Set(BSKLogObject.Level.allCases) ? nil : .systemBlue
    }
}

// MARK: - ButtonActions

extension BSKLogViewController {
    @objc func closeAction() {
        BSKLogViewManager.share.closeLogView()
    }

    @objc func filterAction() {
        let vc = BSKLogFilterController()
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = CGSize(width: 100, height: 270)
        vc.popoverPresentationController?.permittedArrowDirections = .any
        #if targetEnvironment(macCatalyst)
        vc.popoverPresentationController?.sourceView = self.view
        vc.popoverPresentationController?.sourceRect = CGRect(x: BSKLogViewManager.share.targetFrame.minX + 230, y: BSKLogViewManager.share.targetFrame.minY + 360, width: 40, height: 40)
        #else
        vc.popoverPresentationController?.barButtonItem = filterItem
        #endif
        
        vc.selectedLevels = filterLevel
        vc.selectDidChange = {
            [weak self] levels in
            filterLevel = levels
            self?.updateFilterItemColor()
            DispatchQueue.global().async {
                self?.loadLogs()
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
        vc.popoverPresentationController?.delegate = self
        present(vc, animated: true, completion: nil)
    }

    @objc func exportAtion() {
        let vc = BSKLogFileViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func topAction() {
        if logs.count > 0 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
        }
        keepBottom = false
        bottomItem.tintColor = nil
    }

    @objc func bottomAtion(sender: UIBarButtonItem) {
        if logs.count > 0 {
            tableView.scrollToRow(at: IndexPath(row: logs.count - 1, section: 0), at: .bottom, animated: true)
        }
        keepBottom = true
        sender.tintColor = .systemBlue
    }

    @objc func deleteAtion() {
        logs.removeAll()
        tableView.reloadData()
        BSKLogViewManager.share.dataSource.clean()
    }

    @objc func openToolAction() {
        let open = !(navigationController?.isToolbarHidden ?? false)
        navigationController?.setToolbarHidden(open, animated: true)
    }
}

// MARK: - datasource delegate

extension BSKLogViewController: UITableViewDelegate, UITableViewDataSource {
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

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        keepBottom = false
        bottomItem.tintColor = nil
    }
}

extension BSKLogViewController: BSKLogViewDestinationDelegate {
    // 有新的日志
    func newLogDidInsert(log: BSKLogObject) {
        // 判断过滤条件，符合条件的才添加
        guard filterLevel.contains(log.level) else {
            return
        }
        if let keyword = filterKeyword, keyword.count > 0 {
            guard log.log.contains(keyword) else {
                return
            }
        }
        // 先添加进缓存
        logCachePool.append(log)
        // 下一个runloop一次性插入表格中，防止频繁刷新表格
        perform(#selector(insetLog), with: nil, afterDelay: 0)
    }

    // 将缓存中的数据插入表格，清空缓存
    @objc func insetLog() {
        let logs = logCachePool
        logCachePool.removeAll()
        var indexPath: [IndexPath] = []
        for (index, _) in logs.enumerated() {
            indexPath.append(IndexPath(row: self.logs.count + index, section: 0))
        }
        self.logs.append(contentsOf: logs)
        tableView.insertRows(at: indexPath, with: .none)
        if keepBottom, let index = indexPath.last {
            tableView.scrollToRow(at: index, at: .bottom, animated: false)
        }
    }
}

// MARK: - UIPopoverPresentationControllerDelegate 气泡弹窗所需要的代理

extension BSKLogViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension BSKLogViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filterKeyword = searchBar.text
        DispatchQueue.global().async {
            self.loadLogs()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        #if !targetEnvironment(macCatalyst)
            navigationItem.setLeftBarButtonItems([], animated: true)
            navigationItem.setRightBarButtonItems([], animated: true)
        #endif
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        #if !targetEnvironment(macCatalyst)
            navigationItem.setLeftBarButtonItems([closeItem, toolItem], animated: true)
            navigationItem.setRightBarButtonItems([exportItem], animated: true)
        #endif
        searchBar.setShowsCancelButton(false, animated: true)
    }
}
