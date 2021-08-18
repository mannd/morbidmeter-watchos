//
//  Timescale.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/21/21.
//

import Foundation

/// A Timescale provides a method to to create a time string used to generate Moments.
struct Timescale {
    let timescaleType: TimescaleType?
    // Different timescales use different parameters, such as dates, time intervals, or percentage, so the first two clock time parameters are Any to allow passing Doubles or Dates.
    let getTime: ((Any, Any, Bool)->String)?

    // Date equivalent to birthday for calendar based timescales.
    // Using a non-leap year.
    static var referenceDate: Date {
        var utcCalendar = Calendar.current
        utcCalendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return utcCalendar.date(from: DateComponents(year: 2021, month: 1, day: 1, hour: 0))!
    }

    static var referenceHour: Date {
        var utcCalendar = Calendar.current
        utcCalendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return utcCalendar.date(from: DateComponents(year: 2020, month: 12, day: 31, hour: 23))!
    }
}
