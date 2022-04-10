//
//  AppInfo.swift
//  
//
//  Created by 刘万林 on 2022/2/16.
//

import UIKit

// 应用相关信息
public struct AppInfo {
    private init() {}
    /// 版本号
    public static var shortVersion: String {
        return (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
    }

    /// App名称
    public static var bundleName: String {
        return (Bundle.main.infoDictionary?[String(kCFBundleNameKey)] as? String) ?? ""
    }

    /// App名称
    public static var displayName: String {
        return (Bundle.main.infoDictionary?[String("CFBundleDisplayName")] as? String) ?? ""
    }

    /// build version
    public static var buildVersion: String {
        return (Bundle.main.infoDictionary?[String(kCFBundleVersionKey)] as? String) ?? ""
    }
}

/// 设备信息
public struct DeviceInfo {
    private init() {}
    // 系统版本
    public static var systemVersion: String {
        return UIDevice.current.systemVersion
    }

    // 系统名称：iOS/iPad OS/TV OS 等
    public static var systemName: String {
        return UIDevice.current.systemName
    }

    /// 设备型号，例如： "iPhone11,1",请注意，此型号并不是Apple在销售时宣传的手机型号，而是更具体的型号，
    /// 逗号前面的部分表示产品线和代数（例如 ：iPhone9 表示第九代iPhone，就是消费者知道的iPhone7 系列），
    /// 逗号后面为不同的型号，例如：iPhone9,1 为国行、日版、港行iPhone7，iPhone9,2为港行、国行iPhone 7 Plus，iPhone9,3为美版、台版iPhone 7，iPhone9,4为美版、台版iPhone 7 Plus。
    public static var model: String {
        #if targetEnvironment(simulator)
            let model = "simulator-\(ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "Unknowk iOS Device")"
            return model
        #else
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let model = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
            return model
        #endif
    }

    public static var isSimulator: Bool {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }
}
