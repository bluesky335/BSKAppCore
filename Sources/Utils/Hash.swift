//
//  Hash.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2020/4/27.
//  Copyright © 2020 cn.liuwanlin. All rights reserved.
//

import Foundation
import CommonCrypto

public protocol HashAble {
    var hashData:Data{get}
}

public extension HashAble {
    
    var sha1: String {
        let data = self.hashData as NSData
        var hash = [UInt8].init(repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CC_SHA1(data.bytes, CC_LONG(data.length), &hash)
        let res = NSData(bytes: hash, length: Int(CC_SHA1_DIGEST_LENGTH)) as Data
        return res.bsk.hexString
    }
    
    var sha224: String {
        let data = self.hashData as NSData
        var hash = [UInt8].init(repeating: 0, count: Int(CC_SHA224_DIGEST_LENGTH))
        CC_SHA224(data.bytes, CC_LONG(data.length), &hash)
        let res = NSData(bytes: hash, length: Int(CC_SHA224_DIGEST_LENGTH)) as Data
        return res.bsk.hexString
    }
    
    var sha256: String {
        let data = self.hashData as NSData
        var hash = [UInt8].init(repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CC_SHA256(data.bytes, CC_LONG(data.length), &hash)
        let res = NSData(bytes: hash, length: Int(CC_SHA256_DIGEST_LENGTH)) as Data
        return res.bsk.hexString
    }
    
    var sha384: String {
        let data = self.hashData as NSData
        var hash = [UInt8].init(repeating: 0, count: Int(CC_SHA384_DIGEST_LENGTH))
        CC_SHA384(data.bytes, CC_LONG(data.length), &hash)
        let res = NSData(bytes: hash, length: Int(CC_SHA384_DIGEST_LENGTH))as Data
        return res.bsk.hexString
    }
    
    var sha512: String {
        let data = self.hashData as NSData
        var hash = [UInt8].init(repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        CC_SHA512(data.bytes, CC_LONG(data.length), &hash)
        let res = NSData(bytes: hash, length: Int(CC_SHA512_DIGEST_LENGTH))as Data
        return res.bsk.hexString
    }
    
    var MD5: String {
        let data = self.hashData as NSData
        var hash = [UInt8].init(repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(data.bytes, CC_LONG(data.length), &hash)
        let res = NSData(bytes: hash, length: Int(CC_MD5_DIGEST_LENGTH))as Data
        return res.bsk.hexString
    }
}

