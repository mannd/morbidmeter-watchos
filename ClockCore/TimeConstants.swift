//
//  TimeConstants.swift
//  ClockCore
//
//  Created by David Mann on 5/22/25.
//

import Foundation

public enum TimeConstants {
    public static let oneMinute = 60.0
    public static let fiveMinutes = 5.0 * oneMinute
    public static let fifteenMinutes = 15.0 * oneMinute
    public static let twentyMinutes = 20.0 * oneMinute
    public static let thirtyMinutes = 30.0 * oneMinute
    public static let oneHour = 60.0 * oneMinute
    public static let twentyFourHours = 24.0 * oneHour
    public static let oneWeek = twentyFourHours * 7.0
    public static let oneYear = 365.0 * twentyFourHours // non-leap year
}
