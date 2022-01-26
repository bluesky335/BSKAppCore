//
//  BSKLogViewDestination.swift
//
//
//  Created by 刘万林 on 2021/9/6.
//

import Foundation
#if SPM
import BSKLog
#endif

protocol BSKLogViewDestinationDelegate: AnyObject {
    func newLogDidInsert(log: BSKLogObject)
}

public class BSKLogViewDestination: LogDestination {
    private var lock = NSLock()

    weak var delegate: BSKLogViewDestinationDelegate?

    private(set) var logs: [BSKLogObject] = []

    public func printLog(_ log: BSKLogObject) {
        lock.lock()
        defer {
            lock.unlock()
        }
        logs.append(log)
        DispatchQueue.main.async {
            self.delegate?.newLogDidInsert(log: log)
        }
    }

    func clean() {
        lock.lock()
        defer {
            lock.unlock()
        }
        logs.removeAll()
    }
}
