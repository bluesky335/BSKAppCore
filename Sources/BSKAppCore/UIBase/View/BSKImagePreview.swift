//
//  BSKImagePreview.swift
//  CoverUtils
//
//  Created by 刘万林 on 2022/5/24.
//

import UIKit

/// 图片预览视图，支持缩放
public class BSKImagePreview: UIScrollView {
    public var image: UIImage? {
        set {
            imageView.image = newValue
            perform(#selector(updateImageSize), with: nil, afterDelay: 0)
        }
        get {
            return imageView.image
        }
    }

    var imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        delegate = self
        maximumZoomScale = 5
        minimumZoomScale = 0.2
        alwaysBounceVertical = true
        alwaysBounceHorizontal = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        delegate = self
    }

    @objc private func updateImageSize() {
        let imageSize = image?.size ?? CGSize(width: 1, height: 1)
        imageView.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        let x_scale = frame.size.width / imageSize.width
        let y_scale = frame.size.height / imageSize.height
        let scale = x_scale < y_scale ? x_scale : y_scale
        zoomScale = max(minimumZoomScale, min(1, scale))
    }
}

extension BSKImagePreview: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var contentFrame = imageView.frame

        if contentFrame.width < scrollView.frame.width {
            contentFrame.origin.x = (scrollView.frame.width - contentFrame.width) / 2
        } else {
            contentFrame.origin.x = 0
        }
        if contentFrame.height < scrollView.frame.height {
            contentFrame.origin.y = (scrollView.frame.height - contentFrame.height) / 2
        } else {
            contentFrame.origin.y = 0
        }
        imageView.frame = contentFrame
    }
}
