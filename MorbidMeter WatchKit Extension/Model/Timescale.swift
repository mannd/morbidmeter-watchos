//
//  Timescale.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/21/21.
//

import Foundation

struct Timescale {
    let name: String
    let units: String
    let reverseUnits: String
    // TODO: clockTime needs reverse clockTime, or perhaps should return a tuple
    // Maybe Timescale needs a reverseTime var, which would allow adjustedUnits to become a calculated var.
    let clockTime: ((Double)->String)? // closure that returns forward clock time as String
    let clockTime2: ((TimeInterval, Double, Bool)->String)?

    var reverseTime: Bool = false
    
    /// Adjusts timescale units depending of time direction, or if timescale doesn't provide units (like Timescale.percent).
    ///
    /// Note that a space is prepended to returned value.
    var adjustedUnits: String {
        if units.isEmpty {
            return ""
        }
        if reverseTime {
            return " \(reverseUnits)"
        }
        return " \(units)"
    }

    // TODO: Decide whether dates are timezone independent.
    var startDate: Date {
        var utcCalendar = Calendar.current
        utcCalendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return utcCalendar.date(from: DateComponents(year: 2021, month: 1, day: 1, hour: 0))!
    }

    // Date equivalent to birthday for calendar based timescales.
    // Using a non-leap year.
    static let referenceDate: Date = Calendar.current.date(from: DateComponents(year: 2021, month: 1, day: 1, hour: 0))!

}
