//
//  String+Localization.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2019/6/27.
//  Copyright © 2019 cn.liuwanlin. All rights reserved.
//

import UIKit

open class BSKLocalization {
    var bundle:Bundle
    var table:String?
    
    init(bundle:Bundle = .main,table:String? = nil) {
        self.bundle = bundle
        self.table  = table
    }
    
    open func localStr(key:String,value:String? = nil)->String{
        return bundle.localizedString(forKey: key, value: value, table: table)
    }
}

