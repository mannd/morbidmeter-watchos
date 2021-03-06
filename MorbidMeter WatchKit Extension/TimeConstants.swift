//
//  TimeConstants.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 7/30/21.
//

import Foundation

enum TimeConstants {
    static let oneMinute = 60.0
    static let fiveMinutes = 5.0 * oneMinute
    static let fifteenMinutes = 15.0 * oneMinute
    static let twentyMinutes = 20.0 * oneMinute
    static let thirtyMinutes = 30.0 * oneMinute
    static let oneHour = 60.0 * oneMinute
    static let twentyFourHours = 24.0 * oneHour
    static let oneWeek = twentyFourHours * 7.0
    static let oneYear = 365.0 * twentyFourHours // non-leap year
}
