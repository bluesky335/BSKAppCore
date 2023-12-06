//
//  BSKImagePreview.swift
//  CoverUtils
//
//  Created by 刘万林 on 2022/5/24.
//

import UIKit

/// 图片预览视图，支持缩放
open class BSKImagePreview: UIScrollView {
    public var image: UIImage? {
        set {
            imageView.image = newValue
            if frame != .zero {
                updateImageSize()
            }
        }
        get {
            return imageView.image
        }
    }

    public private(set) var initialZoomScale: CGFloat = 1
    public private(set) var initialCenter: CGPoint = .zero

    public private(set) var imageView = UIImageView()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        delegate = self
        maximumZoomScale = 5
        minimumZoomScale = 0.2
        alwaysBounceVertical = true
        alwaysBounceHorizontal = true
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        delegate = self
    }

    @objc private func updateImageSize() {
        maximumZoomScale = 5
        minimumZoomScale = 0.2

        var imageSize = image?.size ?? CGSize(width: 1, height: 1)
        let srollHeight = frame.height - safeAreaInsets.vertical
        let srollWidth = frame.width - safeAreaInsets.horizontal

        if imageSize.width < srollWidth,
           imageSize.height < srollHeight {
            minimumZoomScale = 1
        }

        let x_scale = srollWidth / imageSize.width
        let y_scale = srollHeight / imageSize.height
        let scale = x_scale < y_scale ? x_scale : y_scale
        imageSize = .init(width: imageSize.width * scale, height: imageSize.height * scale)

        let x = imageSize.width < srollWidth ? (srollWidth - imageSize.width) / 2 : 0
        let y = imageSize.height < srollHeight ? (srollHeight - imageSize.height) / 2 : 0
        imageView.frame = CGRect(x: x, y: y, width: imageSize.width, height: imageSize.height)
        zoomScale = 1
        initialZoomScale = 1
        initialCenter = imageView.center
        scrollViewDidZoom(self)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        if imageView.frame == .zero {
            updateImageSize()
        }
    }
}

extension BSKImagePreview: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var contentFrame = imageView.frame
        let srollHeight = scrollView.frame.height - scrollView.safeAreaInsets.vertical
        let srollWidth = scrollView.frame.width - scrollView.safeAreaInsets.horizontal

        if contentFrame.width < srollWidth {
            contentFrame.origin.x = (srollWidth - contentFrame.width) / 2
        } else {
            contentFrame.origin.x = 0
        }
        if contentFrame.height < srollHeight {
            contentFrame.origin.y = (srollHeight - contentFrame.height) / 2
        } else {
            contentFrame.origin.y = 0
        }
        imageView.frame = contentFrame
    }
}
