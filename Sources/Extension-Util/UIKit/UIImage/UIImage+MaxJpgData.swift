//
//  UIImage+MaxJpgData.swift
//  DuDuModules
//
//  Created by BlueSky335 on 2019/5/6.
//  Copyright © 2019 com.cloududu. All rights reserved.
//

import UIKit

public extension BSKExtension where Base: UIImage {
    /// 将UIImage转换为jpg格式的Data
    /// May return nil if image has no CGImageRef or invalid bitmap format. compression is 0(most)..1(least)
    ///
    /// - Parameter maxKB: 最大体积，如果不为空，Data会被压缩到小于最大体积，单位KB
    /// - Returns: jpgData
    func zipJpg(maxKB: UInt?) -> Data? {
        if let maxSize = maxKB {
            var quality = CGFloat(1.0)
            var returnData = base.jpegData(compressionQuality: quality)
            while let data = returnData, data.count > maxSize * 1024, quality > 0.05 {
                quality -= 0.05
                returnData = base.jpegData(compressionQuality: quality)
            }
            return returnData
        } else {
            return base.jpegData(compressionQuality: 1)
        }
    }
}
