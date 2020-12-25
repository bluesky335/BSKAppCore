//
//  URL.swift
//  BSKToolBox-Swift
//
//  Created by BlueSky335 on 2018/5/23.
//  Copyright © 2018年 LiuWanLin. All rights reserved.
//

import Foundation

extension BSKExtension where Base == URL {
    
   public var queryParameters:[String:String]?{
        guard let query = self.base.query else {return nil}
        let parametersArray = query.split(separator: "&").map{String($0)}.map{$0.split(separator: "=").map{String($0)}}
        var parameters = [String:String]()
        for str in parametersArray {
            if str.count>1 {
                if let key = str[0].removingPercentEncoding,let value = str[1].removingPercentEncoding{
                    parameters[key] = value
                }
            }else if str.count>0{
                if let key = str[0].removingPercentEncoding {
                    parameters[key] = ""
                }
            }
        }
        return parameters
    }
    
    
    /// 使用万象优图的api缩放腾讯云的图片，仅对符合正则"\.(file|cosgz|picgz)\.myqcloud\.com"的图片URL生效
    /// 限定缩略图的宽高最大值。该操作会将图像等比缩放至宽高都小于设定最大值。如原图大小为 1000x500，将参数设定为width = 500 height = 400后，图像会等比缩放至 500x250。如果只指定一边，则另一边自适应
    ///
    /// - Parameters:
    ///   - width: 最大宽度 单位px
    ///   - height: 最大高度 单位px
    ///   - quality: 图片质量，取值范围 0-100 ，默认值为原图质量；取原图质量和指定质量的最小值；
    /// - Returns: 处理后的URL
    public func CI_imageSize(width:Int?, height:Int?, quality:Int? = nil)->URL{
        let qcloudImageUrlReg = "[a-zA-Z0-9-_]+\\.(file|cosgz|picgz)\\.myqcloud\\.com"
        let qcloudImageUrlReg2 = "\\.(file|cosgz|picgz)\\.myqcloud\\.com"
        if self.base.host?.bsk.isMatch(regular: qcloudImageUrlReg) ?? false,width != nil || height != nil {
            var imageView2Str = "?imageView2/2"
            if let w = width {
                imageView2Str+="/w/\(w)"
            }
            if let h = height {
                imageView2Str+="/h/\(h)"
            }
            if let q = quality {
                imageView2Str+="/q/\(q)"
            }

            let imageView2Reg = "\\?imageView2\\/[12345](\\/w\\/\\d+)?(\\/h\\/\\d+)?(\\/q\\/\\d+!?)?"
            
            var urlStr = (try? self.base.absoluteString.bsk.replace(match: qcloudImageUrlReg2, with: ".picgz.myqcloud.com", options: [])) ?? self.base.absoluteString
            if urlStr.bsk.isMatch(regular: imageView2Reg){
                urlStr = (try? urlStr.bsk.replace(match: imageView2Reg , with: imageView2Str, options: [])) ?? urlStr
            }else{
                urlStr.append(contentsOf: imageView2Str)
            }
            return URL(string: urlStr)!
        }else{
            return self.base
        }
    }
    
}
