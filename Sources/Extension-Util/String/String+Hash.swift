//
//  String+Hash.swift
//  BSKToolBox-Swift
//
//  Created by BlueSky335 on 2018/4/26.
//  Copyright © 2018年 LiuWanLin. All rights reserved.
//

import Foundation
import CommonCrypto

public extension BSKExtension where Base == String {
    
    var sha1: String {
        let data = (self.base.data(using: .utf8) ?? Data()) as NSData
        var hash = [UInt8].init(repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CC_SHA1(data.bytes, CC_LONG(data.length), &hash)
        let res = NSData(bytes: hash, length: Int(CC_SHA1_DIGEST_LENGTH))
        var hashedStr = res.description
        hashedStr = hashedStr.replacingOccurrences(of: " ", with: "")
        hashedStr = hashedStr.replacingOccurrences(of: "<", with: "")
        hashedStr = hashedStr.replacingOccurrences(of: ">", with: "")
        return hashedStr
    }

    var sha224: String {
        let data = (self.base.data(using: .utf8) ?? Data()) as NSData
        var hash = [UInt8].init(repeating: 0, count: Int(CC_SHA224_DIGEST_LENGTH))
        CC_SHA224(data.bytes, CC_LONG(data.length), &hash)
        let res = NSData(bytes: hash, length: Int(CC_SHA224_DIGEST_LENGTH))
        var hashedStr = res.description
        hashedStr = hashedStr.replacingOccurrences(of: " ", with: "")
        hashedStr = hashedStr.replacingOccurrences(of: "<", with: "")
        hashedStr = hashedStr.replacingOccurrences(of: ">", with: "")
        return hashedStr
    }

    var sha256: String {
        let data = (self.base.data(using: .utf8) ?? Data()) as NSData
        var hash = [UInt8].init(repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CC_SHA256(data.bytes, CC_LONG(data.length), &hash)
        let res = NSData(bytes: hash, length: Int(CC_SHA256_DIGEST_LENGTH))
        var hashedStr = res.description
        hashedStr = hashedStr.replacingOccurrences(of: " ", with: "")
        hashedStr = hashedStr.replacingOccurrences(of: "<", with: "")
        hashedStr = hashedStr.replacingOccurrences(of: ">", with: "")
        return hashedStr
    }

    var sha384: String {
        let data = (self.base.data(using: .utf8) ?? Data()) as NSData
        var hash = [UInt8].init(repeating: 0, count: Int(CC_SHA384_DIGEST_LENGTH))
        CC_SHA384(data.bytes, CC_LONG(data.length), &hash)
        let res = NSData(bytes: hash, length: Int(CC_SHA384_DIGEST_LENGTH))
        var hashedStr = res.description
        hashedStr = hashedStr.replacingOccurrences(of: " ", with: "")
        hashedStr = hashedStr.replacingOccurrences(of: "<", with: "")
        hashedStr = hashedStr.replacingOccurrences(of: ">", with: "")
        return hashedStr
    }

    var sha512: String {
        let data = (self.base.data(using: .utf8) ?? Data()) as NSData
        var hash = [UInt8].init(repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        CC_SHA512(data.bytes, CC_LONG(data.length), &hash)
        let res = NSData(bytes: hash, length: Int(CC_SHA512_DIGEST_LENGTH))
        var hashedStr = res.description
        hashedStr = hashedStr.replacingOccurrences(of: " ", with: "")
        hashedStr = hashedStr.replacingOccurrences(of: "<", with: "")
        hashedStr = hashedStr.replacingOccurrences(of: ">", with: "")
        return hashedStr
    }

    var MD5: String {
        let data = (self.base.data(using: .utf8) ?? Data()) as NSData
        var hash = [UInt8].init(repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(data.bytes, CC_LONG(data.length), &hash)
        let res = NSData(bytes: hash, length: Int(CC_MD5_DIGEST_LENGTH))
        var hashedStr = res.description
        hashedStr = hashedStr.replacingOccurrences(of: " ", with: "")
        hashedStr = hashedStr.replacingOccurrences(of: "<", with: "")
        hashedStr = hashedStr.replacingOccurrences(of: ">", with: "")
        return hashedStr
    }
}
