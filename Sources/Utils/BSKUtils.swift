//
//  BSKUtils.swift
//  DuDuModules
//
//  Created by BlueSky335 on 2019/4/15.
//  Copyright © 2019 com.cloududu. All rights reserved.
//

import UIKit

public class BSKUtils: NSObject {
    public enum FileType: String {
        case image_jpg = "image/jpeg"
        case image_png = "image/png"
        case image_gif = "image/gif"
        case image_tiff = "image/tiff"
        case image_webp = "image/webp"
        case unknown = "application/octet-stream"

        /// 扩展名，不带“.”，例如："jpg"
        var extensionName: String? {
            switch self {
            case .image_jpg: return "jpg"
            case .image_png: return "png"
            case .image_gif: return "gif"
            case .image_tiff: return "tiff"
            case .image_webp: return "webp"
            case .unknown: return nil
            }
        }
    }

    /// 根据文件内容判断图片类型
    /// - Parameter data: 图片数据
    /// - Returns: 类型
    public static func getFileType(fileData: Data) -> FileType {
        let int = fileData.withUnsafeBytes({ (p) -> UInt8 in
            p.load(as: UInt8.self)
        })
        switch int {
        case 0xFF:
            return .image_jpg
        case 0x89:
            return .image_png
        case 0x47:
            return .image_gif
        case 0x49: fallthrough
        case 0x4D:
            return .image_tiff
        case 0x52:
            if fileData.count >= 12,
               let range = Range(NSRange(location: 0, length: 12)),
               let str = String(data: fileData.subdata(in: range), encoding: .utf8),
               str.hasPrefix("RIFF"),
               str.hasSuffix("WEBP") {
                return .image_webp
            }
            return .unknown

        default:
            return .unknown
        }
    }

    public static func runOnMainThread(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async(execute: block)
        }
    }

    public static func Fen2Yuan(fen: String) -> String? {
        guard let fenNumber = Decimal(string: fen),
              let hundred = Decimal(string: "100")
        else {
            return nil
        }
        let resault = fenNumber / hundred
        return resault.description
    }

    public static func Yuan2Fen(yuan: String) -> String? {
        guard let fenNumber = Decimal(string: yuan),
              let hundred = Decimal(string: "100")
        else {
            return nil
        }
        let resault = fenNumber * hundred
        return resault.description
    }
}
