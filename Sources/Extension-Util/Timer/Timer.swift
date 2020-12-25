//
//  Timer.swift
//  BSKAppCore
//
//  Created by 刘万林 on 2019/7/25.
//  Copyright © 2019 cn.liuwanlin. All rights reserved.
//

import UIKit
import RxSwift

public extension BSKExtension where Base:Timer{
    
    static func getCount(for key:AnyHashable)->Observable<Int>?{
        return subjects[key]
    }
    
    static func startCount(_ count:Int,time:TimeInterval,for Key:AnyHashable)->Observable<Int>{
        if let subject = subjects[Key] {
            return subject
        }
        else{
            let subject = BehaviorSubject<Int>(value: count)
            subjects[Key] = subject
            addTimer(time: time, for: Key) { () -> Bool in
                guard var v = try? subject.value() else {
                    subjects.removeValue(forKey: Key)
                    subject.onCompleted()
                    return false
                }
                
                v-=1
                
                subject.onNext(v)
                
                if v == 0 {
                    subjects.removeValue(forKey: Key)
                    subject.onCompleted()
                }
                return true
            }
            return subject.asObservable()
        }
    }
}


var subjects:[AnyHashable:BehaviorSubject<Int>] = [:]

fileprivate func addTimer(time:TimeInterval,for Key:AnyHashable,callBack:@escaping ()->Bool){
    let _ = Timer.scheduledTimer(withTimeInterval: time, repeats: true) { (t) in
        let shouldContinue = callBack()
        if !shouldContinue {
            t.invalidate()
        }
    }
}
