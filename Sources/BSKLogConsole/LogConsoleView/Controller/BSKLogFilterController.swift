//
//  BSKLogFilterController.swift
//  
//
//  Created by 刘万林 on 2021/9/14.
//

import UIKit
#if SPM
import BSKLog
#endif

class BSKLogFilterController: LogBaseViewController {
    let tableView = UITableView()
    
    let logLevels = BSKLogObject.Level.allCases
    
    var selectedLevels:Set<BSKLogObject.Level> = Set()
    
    var selectDidChange:((_ selectedLevels:Set<BSKLogObject.Level>)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.backgroundColor = .darkGray
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension BSKLogFilterController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logLevels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let level = logLevels[indexPath.row]
        cell.textLabel?.text  = level.flag
        cell.backgroundColor = .clear
        cell.textLabel?.font = .systemFont(ofSize: 14)
        cell.accessoryType = selectedLevels.contains(level) ? .checkmark : .none
        cell.tintColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let level = logLevels[indexPath.row]
        if selectedLevels.contains(level) {
            selectedLevels.remove(level)
        } else {
            selectedLevels.insert(level)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
        self.selectDidChange?(self.selectedLevels)
    }
    
}
