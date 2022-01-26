//
//  Bundle+AppCoreViewController.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2019/6/27.
//  Copyright © 2019 cn.liuwanlin. All rights reserved.
//

import UIKit

fileprivate let appcoreBundle = Bundle.init(for: BSKUtils.self)

extension BSKExtension where Base:Bundle{
    static var appCore:Bundle {
        return appcoreBundle
    }
}
