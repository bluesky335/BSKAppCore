//
//  OpenNavigationApp.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2019/9/2.
//  Copyright © 2019 cn.liuwanlin. All rights reserved.
//

import MapKit
import UIKit
#if SPM
import BSKUtils
#endif

fileprivate let local = BSKLocalization(bundle:Bundle(for: MapNavigation.self), table: "Navigation")

public class MapNavigation {
    public enum MapApp: String, CaseIterable {
        case apple = "Navigation_AppleMap"
        case amap = "Navigation_Amap"
        case tencent = "Navigation_TencentMap"
        case google = "Navigation_GoogleMap"
        case baidu = "Navigation_BaiduMap"

        var Name: String {
            return local.localStr(key: rawValue)
        }

        var scheme: String {
            switch self {
            case .baidu:
                return "baidumap"
            case .amap:
                return "iosamap"
            case .apple:
                return ""
            case .google:
                return "comgooglemaps"
            case .tencent:
                return "qqmap"
            }
        }

        func urlWith(endLocation: CLLocationCoordinate2D, targetName: String) -> String? {
            switch self {
            case .baidu:
                return "baidumap://map/direction?origin={{\(local.localStr(key: "Navigation_MyLocation"))}}&destination=latlng:\(endLocation.latitude),\(endLocation.longitude)|name:\(targetName)&coord_type=gcj02&mode=driving&src=ios.blackfish.XHY".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            case .amap:
                return "iosamap://path?sourceApplication=ios.blackfish.XHY&dlat=\(endLocation.latitude)&dlon=\(endLocation.longitude)&dname=\(targetName)&style=2".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            case .apple:
                return ""
            case .google:
                return "comgooglemaps://?daddr=\(endLocation.latitude),\(endLocation.longitude)&directionsmode=driving".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            case .tencent:
                return "qqmap://map/routeplan?from=\(local.localStr(key: "Navigation_MyLocation"))&type=drive&to=\(targetName)&tocoord=\(endLocation.latitude),\(endLocation.longitude)&coord_type=1&referer={ios.blackfish.XHY}".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            }
        }
    }

    public static func NavigationTo(location: CLLocationCoordinate2D, targetName: String) {
        let app = UIApplication.shared
        let vc = UIAlertController(title: local.localStr(key: "Navigation_to"), message: nil, preferredStyle: .actionSheet)
        for map in MapApp.allCases {
            if map == .apple {
                let action = UIAlertAction(title: local.localStr(key: map.rawValue), style: .default) { _ in
                    NavigationWithAppleMap(location: location, targetName: targetName)
                }
                vc.addAction(action)
            } else {
                if let url = URL(string: map.scheme + "://"),
                    app.canOpenURL(url), let navUrl = URL(string: map.urlWith(endLocation: location, targetName: targetName) ?? "") {
                    let action = UIAlertAction(title: local.localStr(key: map.rawValue), style: .default) { _ in
                        app.open(navUrl, options: [:], completionHandler: nil)
                    }
                    vc.addAction(action)
                }
            }
        }
        let cancel = UIAlertAction(title: local.localStr(key: "Navigation_Cancell"), style: .cancel) { _ in
        }
        vc.addAction(cancel)
        UIApplication.shared.bsk.topViewController?.present(vc, animated: true, completion: nil)
    }

    public static func NavigationWithAppleMap(location: CLLocationCoordinate2D, targetName: String) {
        let currentLocation = MKMapItem.forCurrentLocation()
        let location = MKMapItem(placemark: MKPlacemark(coordinate: location))
        location.name = targetName

        MKMapItem.openMaps(with: [currentLocation, location], launchOptions: [
            MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
            MKLaunchOptionsShowsTrafficKey: true,
        ])
    }
}
