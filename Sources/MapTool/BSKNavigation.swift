//
//  OpenNavigationApp.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2019/9/2.
//  Copyright © 2019 cn.liuwanlin. All rights reserved.
//

import UIKit
import MapKit
import QMUIKit

//- (NSArray*)getInstalledMapAppWithEndLocation:(CLLocationCoordinate2D)endLocation
//
//{
//
//    NSMutableArray*maps = [NSMutableArrayarray];
//
//    //苹果地图
//
//    NSMutableDictionary*iosMapDic = [NSMutableDictionarydictionary];
//
//    iosMapDic[@"title"] =@"苹果地图";
//
//    [mapsaddObject:iosMapDic];
//
//    //百度地图
//
//    if([[UIApplicationsharedApplication]canOpenURL:[NSURLURLWithString:@"baidumap://"]]) {
//
//        NSMutableDictionary*baiduMapDic = [NSMutableDictionarydictionary];
//
//        baiduMapDic[@"title"] =@"百度地图";
//
//        NSString*urlString = [[NSStringstringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=北京&mode=driving&coord_type=gcj02",endLocation.latitude,endLocation.longitude]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//        baiduMapDic[@"url"] = urlString;
//
//        [mapsaddObject:baiduMapDic];
//
//    }
//
//    //高德地图
//
//    if([[UIApplicationsharedApplication]canOpenURL:[NSURLURLWithString:@"iosamap://"]]) {
//
//        NSMutableDictionary*gaodeMapDic = [NSMutableDictionarydictionary];
//
//        gaodeMapDic[@"title"] =@"高德地图";
//
//        NSString*urlString = [[NSStringstringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"导航功能",@"nav123456",endLocation.latitude,endLocation.longitude]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//        gaodeMapDic[@"url"] = urlString;
//
//        [mapsaddObject:gaodeMapDic];
//
//    }
//
//    //谷歌地图
//
//    if([[UIApplicationsharedApplication]canOpenURL:[NSURLURLWithString:@"comgooglemaps://"]]) {
//
//        NSMutableDictionary*googleMapDic = [NSMutableDictionarydictionary];
//
//        googleMapDic[@"title"] =@"谷歌地图";
//
//        NSString*urlString = [[NSStringstringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",@"导航测试",@"nav123456",endLocation.latitude, endLocation.longitude]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//        googleMapDic[@"url"] = urlString;
//
//        [mapsaddObject:googleMapDic];
//
//    }
//
//    //腾讯地图
//
//    if([[UIApplicationsharedApplication]canOpenURL:[NSURLURLWithString:@"qqmap://"]]) {
//
//        NSMutableDictionary*qqMapDic = [NSMutableDictionarydictionary];
//
//        qqMapDic[@"title"] =@"腾讯地图";
//
//        NSString*urlString = [[NSStringstringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=终点&coord_type=1&policy=0",endLocation.latitude, endLocation.longitude]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//        qqMapDic[@"url"] = urlString;
//
//        [mapsaddObject:qqMapDic];
//
//    }
//
//    returnmaps;
//
//}

//class BSKNavigation{
//
//    struct MapApp {
//        var name:String
//        var scheme:String
//        var url:String
//    }
//
//
//    static func NavigationTo(location:CLLocation){
//
//        let app = UIApplication.shared
//        let maps:[MapApp] = []
//        let local = BSKLocalization.getLocalStr(table: "Navigation")
//
//        maps.append(MapApp(name: local.localStr(key: "Navigation_AppleMap"),
//                           scheme: "<#T##String#>",
//                           url: <#T##String#>))
//
//        let vc = QMUIAlertController(title: local.localStr(key: "Navigation_to"), message: nil, preferredStyle: .actionSheet)
//        for map in maps {
//            if let url = URL(string: map.scheme+"://") , app.canOpenURL(url),let navUrl = URL(string: map.url){
//                let action = QMUIAlertAction(title: map.name, style: .default) { (vc, action) in
//                    app.open(navUrl, options: [:])
//                }
//            }
//        }
//    }
//
//    func NavigationWithAppleMap(location:CLLocation){
//        let gps = [JZLocationConverterbd09ToWgs84:self.destinationCoordinate2D];
//
//        MKMapItem *currentLoc = [MKMapItemmapItemForCurrentLocation];
//
//        MKMapItem*toLocation = [[MKMapItemalloc]initWithPlacemark:[[MKPlacemarkalloc]initWithCoordinate:gpsaddressDictionary:nil]];
//
//        NSArray*items = @[currentLoc,toLocation];
//
//        NSDictionary*dic = @{
//
//            MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
//
//            MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
//
//            MKLaunchOptionsShowsTrafficKey : @(YES)
//
//        };
//
//        [MKMapItemopenMapsWithItems:itemslaunchOptions:dic];
//    }
//}

// TODO: 地图导航
