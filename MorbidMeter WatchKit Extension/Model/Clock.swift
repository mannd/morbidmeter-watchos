//
//  Configuration.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/21/21.
//

import Foundation
import UIKit

struct Clock {
    var timescale: Timescale
    var birthday: Date
    var deathday: Date

    func longevity() -> Double {
        return deathday.timeIntervalSince(birthday)
    }

    func percentage(date: Date) throws -> Double {
        let longevity = longevity()
        guard longevity > 0 else { throw ClockError.negativeLongevity }
        let duration = date.timeIntervalSince(birthday)
        let ratio = duration / longevity
        guard ratio <= 1.0 else { throw ClockError.alreadyDead }
        guard ratio >= 0 else { throw ClockError.birthdayInFuture }
        if timescale.reverseTime {
            return 1.0 - duration / longevity
        }
        return duration / longevity
    }
}

enum ClockError: Error {
    case negativeLongevity
    case alreadyDead
    case birthdayInFuture
}

