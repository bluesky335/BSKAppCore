//
//  String+Localization.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2019/6/27.
//  Copyright © 2019 cn.liuwanlin. All rights reserved.
//

import UIKit

internal func ResourceBundle(for resource: String) -> Bundle {
    var bundle: Bundle = .main
    if let bundlePath = Bundle.bsk.appCore.path(forResource: resource, ofType: "bundle") {
        bundle = Bundle(path: bundlePath) ?? .main
    }
    return bundle
}

open class BSKLocalization {
    var bundle: Bundle
    var table: String?

    public init(bundle: Bundle = .main, table: String? = nil) {
        self.bundle = bundle
        self.table = table
    }

    open func localStr(key: String, value: String? = nil) -> String {
        return bundle.localizedString(forKey: key, value: value, table: table)
    }

    internal static func getLocalStr(table: String) -> BSKLocalization {
        let bundle: Bundle = ResourceBundle(for: "LocalizationString")
        return BSKLocalization(bundle: bundle, table: table)
    }
}
