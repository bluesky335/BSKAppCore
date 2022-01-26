
//
//  PHAsset+outVideo.swift
//  
//
//  Created by 刘万林 on 2019/9/2.
//

import Photos
import UIKit

public extension BSKExtension where Base: PHAsset {
    struct VideoQuality {
        fileprivate var value: String
        private init(value:String){
            self.value = value
        }
        public static var low: VideoQuality { return VideoQuality(value: AVAssetExportPresetMediumQuality) }
        public static var medium: VideoQuality { return VideoQuality(value: AVAssetExportPresetMediumQuality) }
        public static var height: VideoQuality { return VideoQuality(value: AVAssetExportPresetMediumQuality) }
    }
    
    func outPutMp4(to outputURL: URL? = nil ,quality:VideoQuality, complete: @escaping (Swift.Result<URL, Error>) -> Void) {
        PHImageManager.default().requestAVAsset(forVideo: self.base, options: nil) { avAsset, _, _ in
            if let av = avAsset {
                let outUrl = outputURL ?? URL(fileURLWithPath: NSTemporaryDirectory() + "tempVideo_\(NSDate().timeIntervalSince1970)-\(Int.random(in: 10000 ... 99999)).mp4")
                if let export = AVAssetExportSession(asset: av, presetName: quality.value) {
                    export.outputURL = outUrl
                    export.shouldOptimizeForNetworkUse = true
                    export.outputFileType = .mp4
                    export.exportAsynchronously(completionHandler: {
                        complete(.success(outUrl))
                    })
                } else {
                    complete(.failure(NSError(domain: "视频压缩出错", code: 0, userInfo: nil)))
                }
            } else {
                complete(.failure(NSError(domain: "获取视频出错", code: 0, userInfo: nil)))
            }
        }
    }
}


