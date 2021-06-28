//
//  Timescale.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/21/21.
//

import Foundation

struct Timescale {
    let name: String
    let maximum: Double // if these are non-zero, and endDate is nil, timescale uses integral time
    let minimum: Double
    let units: String
    let reverseUnits: String
    let endDate: Date? // If endDate non-nil, then this is a calendar-based timescale.
    // TODO: clockTime needs reverse clockTime, or perhaps should return a tuple
    // Maybe Timescale needs a reverseTime var, which would allow adjustedUnits to become a calculated var.
    let clockTime: ((Double)->String)? // closure that returns forward clock time as String

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

    var duration: Double {
        guard let endDate = endDate else { return maximum - minimum }
        let seconds = Calendar.current.dateComponents([.second], from: Self.referenceDate, to: endDate).second
        return Double(seconds ?? 0)
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

    func proportionalTime(percent: Double, reverseTime: Bool = false) -> Double {
        if reverseTime {
            return maximum - (percent * duration)
        }
        return minimum + (percent * duration)
    }
}
