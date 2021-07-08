//
//  Timescales.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/23/21.
//

import Foundation

class Timescales {
    private static let errorMessage = "Error"
    private static let cr = "\n"
    static let secsPerMin = 60.0
    static let secsPerHour = 60.0 * 60.0
    static let secsPerDay = secsPerHour * 24.0
    static let secsPerWeek = secsPerDay * 7.0
    static let secsPerYear = secsPerDay * 364.25
    static let secsPerMonth = secsPerYear / 12.0
    static let ageOfUniverse = 13_770_000_000.0

    static let timescales: [TimescaleType: Timescale] = [
        .seconds: Timescale(timescaleType: .seconds, clockTime: { timeInterval, _, reverseTime in
            guard let timeInterval = timeInterval as? TimeInterval else { return errorMessage }
            guard let result = integerFormattedDouble(timeInterval) else {
                return errorMessage
            }
            return [result, reverseTime ? "secs to go" : "secs lived"].joined(separator: "\n") }),
        .minutes: Timescale(timescaleType: .minutes, clockTime: { timeInterval, _, reverseTime in
            guard let timeInterval = timeInterval as? TimeInterval else { return errorMessage }
            let minutes = timeInterval / secsPerMin
            guard let result = integerFormattedDouble(minutes) else {
                return errorMessage
            }
            return [result, reverseTime ? "mins to go" : "mins lived"].joined(separator: cr) }),
        .hours: Timescale(timescaleType: .hours, clockTime: { timeInterval, _, reverseTime in
            guard let timeInterval = timeInterval as? TimeInterval else { return errorMessage }
            let hours = timeInterval / secsPerHour
            guard let result = integerFormattedDouble(hours) else {
                return errorMessage
            }
            return [result, reverseTime ? "hours to go" : "hours lived"].joined(separator: cr) }),
        .days: Timescale(timescaleType: .days, clockTime: { timeInterval, _, reverseTime in
            guard let timeInterval = timeInterval as? TimeInterval else { return errorMessage }
            let days = timeInterval / secsPerDay
            guard let result = integerFormattedDouble(days) else {
                return errorMessage
            }
            return [result, reverseTime ? "days to go" : "days lived"].joined(separator: cr) }),
        .weeks: Timescale(timescaleType: .weeks, clockTime: { TimeInterval, _, reverseTime in
            guard let timeInterval = TimeInterval as? TimeInterval else { return errorMessage }
            let weeks = timeInterval / secsPerWeek
            guard let result = integerFormattedDouble(weeks) else {
                return errorMessage
            }
            return [result, reverseTime ? "weeks to go" : "weeks lived"].joined(separator: cr) }),
        .months: Timescale(timescaleType: .months, clockTime: { timeInterval, _, reverseTime in
            guard let timeInterval = timeInterval as? TimeInterval else { return errorMessage }
            let months = timeInterval / secsPerMonth
            guard let result = integerFormattedDouble(months) else {
                return errorMessage
            }
            return [result, reverseTime ? "months to go" : "months lived"].joined(separator: cr) }),
        .years: Timescale(timescaleType: .years, clockTime: { timeInterval, _, reverseTime in
            guard let timeInterval = timeInterval as? TimeInterval else { return errorMessage }
            let years = timeInterval / secsPerYear
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.usesSignificantDigits = true
            formatter.minimumSignificantDigits = 6
            formatter.maximumSignificantDigits = 8
            guard let result = formatter.string(from: NSNumber(value: years)) else {
                return errorMessage
            }
            return [result, reverseTime ? "years to go" : "years lived"].joined(separator: cr) }),
        .daysHoursMinsSecs: Timescale(timescaleType: .daysHoursMinsSecs, clockTime: { now, date, reverseTime in
            // For this timescale we pass in current date and either birthday or deathday depending on reverseTime.
            guard let now = now as? Date, let date = date as? Date else { return errorMessage }
            var dateComponents: DateComponents
            if reverseTime {
                dateComponents = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: now, to: date)
            } else {
                dateComponents = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: date, to: now)
            }
            if let days = dateComponents.day, let hours = dateComponents.hour, let minutes = dateComponents.minute, let seconds = dateComponents.second {
                return ["\(days) d \(hours) h \(minutes) m \(seconds) s", reverseTime ? "to go" : "lived"].joined(separator: cr)
            }
            return errorMessage }),
        .yearsMonthsDays: Timescale(timescaleType: .yearsMonthsDays, clockTime: { now, date, reverseTime in
            // For this timescale we pass in current date and either birthday or deathday depending on reverseTime.
            guard let now = now as? Date, let date = date as? Date else { return errorMessage }
            var dateComponents: DateComponents
            if reverseTime {
                dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: now, to: date)
            } else {
                dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date, to: now)
            }
            if let days = dateComponents.day, let years = dateComponents.year, let months = dateComponents.month {
                return ["\(years) y \(months) m \(days) d", reverseTime ? "to go" : "lived"].joined(separator: cr)
            }
            return errorMessage }),
        .hour: Timescale(timescaleType: .year, clockTime: { _, percentage, reverseTime in
            guard let percentage = percentage as? Double else {
                return errorMessage
            }
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            let adjustedTimeInterval = percentage * secsPerHour
            let date = Timescale.referenceHour.addingTimeInterval(adjustedTimeInterval)
            return formatter.string(from: date) }),
        .day: Timescale(timescaleType: .day, clockTime: { _, percentage, reverseTime in
            guard let percentage = percentage as? Double else {
                return errorMessage
            }
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            let adjustedTimeInterval = percentage * secsPerDay
            let date = Timescale.referenceHour.addingTimeInterval(adjustedTimeInterval)
            return formatter.string(from: date) }),
        .month: Timescale(timescaleType: .month, clockTime: { _, percentage, reverseTime in
            guard let percentage = percentage as? Double else {
                return errorMessage
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd hh:mm:ss a"
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            let adjustedTimeInterval = percentage * secsPerMonth
            let date = Timescale.referenceHour.addingTimeInterval(adjustedTimeInterval)
            return formatter.string(from: date) }),
        .year: Timescale(timescaleType: .year, clockTime: { _, percentage, reverseTime in
            guard let percentage = percentage as? Double else {
                return errorMessage
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd hh:mm:ss a"
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            let adjustedTimeInterval = percentage * secsPerYear
            let date = Timescale.referenceHour.addingTimeInterval(adjustedTimeInterval)
            return formatter.string(from: date) }),
        .universe: Timescale(timescaleType: .universe, clockTime: { _, percentage, reverseTime in
            guard let percentage = percentage as? Double else {
                return errorMessage
            }
            let adjustedTimeInterval = percentage * ageOfUniverse
            guard let result = integerFormattedDouble(adjustedTimeInterval) else {
                return errorMessage
            }
            return [result, reverseTime ? "years until Big Bang" : "years since Big Bang"].joined(separator: cr) }),
        .percent: Timescale(timescaleType: .percent, clockTime: { _, percentage, reverseTime in
            guard let percentage = percentage as? Double else { return errorMessage }
            let formatter = NumberFormatter()
            formatter.numberStyle = .percent
            formatter.usesSignificantDigits = true
            formatter.minimumSignificantDigits = 4
            formatter.maximumSignificantDigits = 6
            guard let result = formatter.string(from: NSNumber(value: percentage)) else {
                return errorMessage
            }
            return [result, reverseTime ? "to go" : "lived"].joined(separator: cr) }),
        .blank: Timescale(timescaleType: .blank, clockTime: { _, _, _ in
            return "" }),
    ]

    static func getInstance(_ timescaleType: TimescaleType) -> Timescale? {
        return timescales[timescaleType]
    }

    static func integerFormattedDouble(_ number: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        guard let result = formatter.string(from: NSNumber(value: floor(abs(number)))) else {
            return nil
        }
        return result
    }

}

enum TimescaleType: Int, CustomStringConvertible, CaseIterable, Identifiable {
    case seconds
    case minutes
    case hours
    case days
    case weeks
    case months
    case years
    case daysHoursMinsSecs
    case yearsMonthsDays
    case hour
    case day
    case month
    case year
    case universe
    case percent
    case blank
    case debug

    var id: TimescaleType { self }

    var description: String {
        switch self {
        case .seconds: return "Seconds"
        case .minutes: return "Minutes"
        case .hours: return "Hours"
        case .days: return "Days"
        case .weeks: return "Weeks"
        case .daysHoursMinsSecs: return "D-H-M-S"
        case .yearsMonthsDays: return "Y-M-D"
        case .months: return "Months"
        case .years: return "Years"
        case .hour: return "One Hour"
        case .day: return "One Day"
        case .month: return "One Month"
        case .year: return "One Year"
        case .universe: return "Universe"
        case .percent: return "Percent"
        case .blank: return "None"
        case .debug: return "DEBUG"
        }
    }

    func fullDescription(reverseTime: Bool) -> String {
        return reverseTime ? [description, "-R"].joined() : description
    }
}
