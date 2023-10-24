//
//  BSKCellAccessoryView.swift
//
//
//  Created by BlueSky335 on 2023/7/30.
//

import UIKit

open class BSKCellAccessoryView: UIView {
    open var text: String? {
        set {
            textLabel.text = newValue
        }
        get {
            textLabel.text
        }
    }

    open var accessoryType: UITableViewCell.AccessoryType? {
        didSet {
            needSetupUI = true
            DispatchQueue.main.async {
                self.setupUI()
            }
        }
    }

    open var accessoryImage: [UIImage?]? {
        didSet {
            needSetupUI = true
            DispatchQueue.main.async {
                self.setupUI()
            }
        }
    }

    private var needSetupUI = true

    private(set) var textLabel = UILabel()

    private let imageLayoutGuide = UILayoutGuide()

    public init(text: String?, accessoryType: UITableViewCell.AccessoryType, frame: CGRect) {
        self.accessoryType = accessoryType
        super.init(frame: frame)
        textLabel.text = text
        textLabel.font = .systemFont(ofSize: 14)
        addSubview(textLabel)
        addLayoutGuide(imageLayoutGuide)
        imageLayoutGuide.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
        }
        textLabel.snp.makeConstraints { make in
            make.left.greaterThanOrEqualToSuperview()
            make.top.bottom.equalToSuperview()
            make.right.equalTo(imageLayoutGuide.snp.left)
        }
        setupUI()
    }

    private func setupUI() {
        guard needSetupUI else {
            return
        }
        needSetupUI = false
        var images = accessoryImage ?? []
        if accessoryImage == nil, let accessoryType = accessoryType {
            switch accessoryType {
            case .disclosureIndicator:
                images = [UIImage(systemName: "chevron.right")?.applyingSymbolConfiguration(.init(pointSize: 12, weight: .semibold))?.withTintColor(.systemGray3, renderingMode: .alwaysOriginal)]
            case .detailDisclosureButton:
                images = [
                    UIImage(systemName: "info.circle")?.applyingSymbolConfiguration(.init(pointSize: 18, weight: .light)),
                    UIImage(systemName: "chevron.right")?.applyingSymbolConfiguration(.init(pointSize: 12, weight: .semibold))?.withTintColor(.systemGray3, renderingMode: .alwaysOriginal),
                ]
            case .checkmark:
                images = [UIImage(systemName: "checkmark")?.applyingSymbolConfiguration(.init(pointSize: 14, weight: .semibold))]
            case .detailButton:
                images = [UIImage(systemName: "info.circle")?.applyingSymbolConfiguration(.init(pointSize: 18, weight: .light))]
            default:
                break
            }
        }
        var imageViews: [UIImageView] = []
        for subview in subviews {
            if let imageView = subview as? UIImageView {
                imageView.removeFromSuperview()
                imageViews.append(imageView)
            }
        }
        var left = imageLayoutGuide.snp.left
        for (index, image) in images.enumerated() {
            let imageView = imageViews.popLast() ?? UIImageView()
            imageView.image = image
            imageView.contentMode = .center
            addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.left.equalTo(left).offset(8)
                make.centerY.equalToSuperview()
                if index == images.count - 1 {
                    make.right.equalTo(imageLayoutGuide).offset(-2.5)
                }
            }
            left = imageView.snp.right
        }
        if superview != nil {
            invalidateIntrinsicContentSize()
        }
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
