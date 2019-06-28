//
//  BSKUtils.swift
//  DuDuModules
//
//  Created by BlueSky335 on 2019/4/15.
//  Copyright © 2019 com.cloududu. All rights reserved.
//

import UIKit

class BSKUtils: NSObject {

    static func getImageType(data:Data)->String{
        
        let int = data.withUnsafeBytes({ (p) -> UInt8 in
            return p.load(as: UInt8.self)
        })
        switch int {
        case 0xff:
            return "image/jpeg"
        case 0x89:
            return "image/png"
        case 0x47:
            return "image/gif"
        case 0x49: fallthrough
        case 0x4D:
            return "image/tiff"
        case 0x52:
            if  data.count >= 12,
                let range = Range(NSRange(location: 0, length: 12)),
                let str = String(data: data.subdata(in: range) , encoding: .utf8),
                str.hasPrefix("RIFF"),
                str.hasSuffix("WEBP")
            {
                return "image/webp";
            }
            return "application/octet-stream"
            
        default:
            return "application/octet-stream"
        }
    }
    
    static func getImageSuffix(data:Data)->String?{
        let int = data.withUnsafeBytes({ (p) -> UInt8 in
            return p.load(as: UInt8.self)
        })
        switch int {
        case 0xff:
            return ".jpg"
        case 0x89:
            return ".png"
        case 0x47:
            return ".gif"
        case 0x49: fallthrough
        case 0x4D:
            return ".tiff"
        case 0x52:
            if  data.count >= 12,
                let range = Range(NSRange(location: 0, length: 12)),
                let str = String(data: data.subdata(in: range) , encoding: .utf8),
                str.hasPrefix("RIFF"),
                str.hasSuffix("WEBP")
            {
                return ".webp";
            }
            return nil
            
        default:
            return nil
        }
    }
    
    static func runOnMainThread(_ block:@escaping ()->Void){
        if Thread.isMainThread {
            block()
        }else{
            DispatchQueue.main.async(execute: block)
        }
    }
}
