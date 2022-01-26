// swift-tools-version:5.3
//  Package.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2021/9/25.
//  Copyright © 2021 cn.liuwanlin. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "BSKAppCore",
    defaultLocalization: .init("zh-Hans"),
    platforms: [
        .iOS(.v13),
        .macOS(.v10_14)
    ],
    products: [
        .library(name: "BSKAppCore", targets: ["BSKAppCore"]),
        .library(name: "BSKLog", targets: ["BSKLog"]),
        .library(name: "BSKUtils", targets: ["BSKUtils"]),
        .library(name: "BSKLogConsole", targets: ["BSKLogConsole"]),
    ],
    dependencies:[
    ],
    targets: [
        .target(name: "BSKAppCore",dependencies: ["BSKUtils","BSKLog"],resources: [
            .copy("./MapTool/JZLocation/GCJ02.json.data")
        ],swiftSettings:[ .define("SPM")]),
        
        .target(name: "BSKLogConsole",dependencies: ["BSKLog"],swiftSettings:[ .define("SPM")]),
        
        .target(name: "BSKLog",dependencies: ["BSKUtils"]),
        
        .target(name: "BSKUtils",resources: [
            .copy("./Extension-Util/String/Pinyin/unicode_to_hanyu_pinyin.txt")
        ],swiftSettings:[ .define("SPM")]),
        
        .testTarget(name: "BSKUtilsTest",dependencies: ["BSKUtils"])
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
