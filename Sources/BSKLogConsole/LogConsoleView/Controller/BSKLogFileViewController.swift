//
//  BSKLogFileViewController.swift
//
//
//  Created by 刘万林 on 2021/9/15.
//

import UIKit
#if SPM
import BSKLog
#endif

class BSKLogFileViewController: LogBaseViewController {
    let tableView = UITableView()

    var logs: [(destination: BSKLogFileDestination, files: [URL])] = [
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        title = "导出日志"

        loadData()
        setupTableView()
    }

    func loadData() {
        let destinationns = BSKLog.config.destination.compactMap({ dest in
            dest as? BSKLogFileDestination
        })

        let filePaths = destinationns.compactMap { dest -> (BSKLogFileDestination, [URL]) in
            let url = dest.logFileDir
            let urls = (FileManager.default.subpaths(atPath: url.path) ?? []).filter { str in
                str.hasSuffix(".log")
            }.sorted(by: >).map { fileName in
                url.appendingPathComponent(fileName)
            }
            return (dest, urls)
        }
        logs = filePaths
    }

    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
    }

    func deleteLog(at indexPath: IndexPath) {
        DispatchQueue(label: "deleteLog").async {
            do {
                try FileManager.default.removeItem(at: self.logs[indexPath.section].files[indexPath.row])
                DispatchQueue.main.async {
                    self.logs[indexPath.section].files.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            } catch _ {
                // 删除失败
            }
        }
    }

    func exportLog(at indexPath: IndexPath) {
        let vc = UIDocumentInteractionController(url: logs[indexPath.section].files[indexPath.row])
        vc.uti = "public.text"
        vc.presentOptionsMenu(from: tableView.cellForRow(at: indexPath)?.frame ?? view.bounds, in: view, animated: true)
    }
}

// MARK: - datasource delegate

extension BSKLogFileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        logs.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs[section].files.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.imageView?.image = UIImage(inFramwork: "log_file")?.withTintColor(.white)
        #if targetEnvironment(macCatalyst)
            cell.textLabel?.text = try? logs[indexPath.section].files[indexPath.row].path.subString(from: Bundle.main.bundleIdentifier ?? "")
        #else
            cell.textLabel?.text = try? logs[indexPath.section].files[indexPath.row].path.subString(from: NSHomeDirectory())
        #endif
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        cell.tintColor = .white
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = BSKLogFilePreviewController(fileURL: logs[indexPath.section].files[indexPath.row], logFileDestination: logs[indexPath.section].destination)
        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(actions: [
            UIContextualAction(style: .normal, title: "导出", handler: { _, _, _ in
                self.exportLog(at: indexPath)
            }),
            UIContextualAction(style: .destructive, title: "删除", handler: { _, _, _ in
                self.deleteLog(at: indexPath)
            }),

        ])
    }
}
