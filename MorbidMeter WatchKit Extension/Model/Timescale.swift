//
//  Timescale.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/21/21.
//

import Foundation

struct Timescale {
    let timescaleType: TimescaleType?
    // Different timescales use different parameters, such as dates, time intervals, or percentage, so the first two clock time parameters are Any to allow passing Doubles or Dates.
    let clockTime: ((Any, Any, Bool)->String)?

    // TODO: Decide whether dates are timezone independent.
    var startDate: Date {
        let utcCalendar = Calendar.current
        // Everything else is in user's time zone, so why not the start date?
//        utcCalendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return utcCalendar.date(from: DateComponents(year: 2021, month: 1, day: 1, hour: 0))!
    }

    // Date equivalent to birthday for calendar based timescales.
    // Using a non-leap year.
    static let referenceDate: Date = Calendar.current.date(from: DateComponents(year: 2021, month: 1, day: 1, hour: 0))!
}
