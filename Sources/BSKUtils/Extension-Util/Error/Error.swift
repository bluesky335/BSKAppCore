//
//  Error.swift
//  
//
//  Created by 刘万林 on 2021/1/14.
//  Copyright © 2021 cheung. All rights reserved.
//

import Foundation

public protocol ErrorMessageAble:Error {
    func code() -> Int
    func message() -> String
}

extension NSError: ErrorMessageAble {
    public func message() -> String {
        return localizedDescription
    }

    public func code() -> Int {
        return code
    }
}

extension NSError {
    public convenience init(domain: String = "App", code: Int, message: String) {
        self.init(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
}

extension Error {
    public var code: Int {
        switch self {
        case let a as ErrorMessageAble:
            return a.code()
        default:
            return -1
        }
    }

    public var message: String {
        switch self {
        case let a as ErrorMessageAble:
            return a.message()
        default:
            return localizedDescription
        }
    }
}
