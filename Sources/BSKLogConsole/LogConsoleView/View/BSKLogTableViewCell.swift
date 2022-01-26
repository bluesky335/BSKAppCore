//
//  LogTableViewCell.swift
//  
//
//  Created by 刘万林 on 2021/9/9.
//

import UIKit
#if SPM
import BSKLog
#endif

class BSKLogTableViewCell: UITableViewCell {
    var infoLabel: UILabel = UILabel()
    var logLabel: UILabel = UILabel()
    var infoView = UIView()
    private var dateFormater: DateFormatter = DateFormatter()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        logLabel.translatesAutoresizingMaskIntoConstraints = false
        infoView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(infoView)
        infoView.addSubview(infoLabel)
        contentView.addSubview(logLabel)
        
        infoView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        infoView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        infoView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
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
        
        logLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5).isActive = true
        logLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5).isActive = true
        logLabel.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: 0).isActive = true
        logLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        logLabel.font = .systemFont(ofSize: 11)
        logLabel.textColor = UIColor.lightGray
        logLabel.numberOfLines = 0
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = .black.withAlphaComponent(0.2)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setLog(log: BSKLogObject) {
        let timeZone = dateFormater.timeZone.secondsFromGMT() / 3600
        var fileName = log.file
        if let name = log.file.split(separator: "/").last {
            fileName = String(name)
        }
        let timeZoneStr = "\(timeZone > 0 ? "+" : "")\(timeZone)"
        infoLabel.text = """
        \(log.level.flag) \(dateFormater.string(from: log.date)) \(timeZoneStr) \(log.threadInfo)
        \(fileName):\(log.line) \(log.function)
        """
        logLabel.text = log.log
        switch log.level {
        case .success:
            logLabel.textColor = .systemGreen
        case .debug:
            logLabel.textColor = .lightGray
        case .log:
            logLabel.textColor = .white
        case .warn:
            logLabel.textColor = .systemYellow
        case .error:
            logLabel.textColor = .systemRed
        case .severe:
            logLabel.textColor = .systemPink
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
