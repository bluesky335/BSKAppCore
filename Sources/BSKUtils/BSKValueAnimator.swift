//
//  BSKValueAnimator.swift
//  BSKUtils
//
//  Created by 刘万林 on 2020/11/5.
//

import Foundation
import UIKit

open class BSKValueAnimator {
    open var from: Double
    open var to: Double

    public enum Speed {
        case fps30
        case fps60
        case fps120

        fileprivate var interval: TimeInterval {
            switch self {
            case .fps30:
                return 1.0 / 30.0
            case .fps60:
                return 1.0 / 60.0
            case .fps120:
                return 1.0 / 120.0
            }
        }
    }

    private var value: Double

    private var delta: Double = 0
    private var totalCount: Int = 0
    private var curentCount: Int = 0
    private var progress: ((_ value: Double, _ isDone: Bool) -> Void)?

    init(from: Double, to: Double) {
        value = from
        self.from = from
        self.to = to
    }

    private var timer: Timer?

    func fir(duration: TimeInterval, progress: @escaping (_ value: Double, _ isDone: Bool) -> Void) {
        totalCount = Int(duration / (1.0 / 60))
        curentCount = 0
        delta = (to - from) / Double(totalCount)
        self.progress = progress
        let newTimer = Timer(timeInterval: 1, target: self, selector: #selector(timerAction(_:)), userInfo: nil, repeats: true)
        RunLoop.current.add(newTimer, forMode: .common)
        timer = newTimer
        newTimer.fire()
    }

    @objc private func timerAction(_ sender: Timer) {
        value += delta
        curentCount += 1
        var isDone = false
        if curentCount >= totalCount {
            value = to
            sender.invalidate()
            timer = nil
            isDone = true
        }
        progress?(value, isDone)
    }
}
