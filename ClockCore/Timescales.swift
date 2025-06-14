//
//  Timescales.swift
//  ClockCore
//
//  Created by David Mann on 5/22/25.
//

import Foundation

public class Timescales {
    private static let errorMessage = "Error"
    private static let cr = "\n"
    private static let space = " "

    static let secsPerMin = 60.0
    static let secsPerHour = 60.0 * 60.0
    static let secsPerDay = secsPerHour * 24.0
    static let secsPerWeek = secsPerDay * 7.0
    static let secsPerYear = secsPerDay * 365.25
    static let secsPerMonth = secsPerYear / 12.0
    static let ageOfUniverse = 13_770_000_000.0

    static let timescaleBlank = Timescale(timescaleType: .blank, getTime: { _, _, _ in
        return "" })

    public static func getTime(result: String,
                        reverseTime: Bool,
                        forwardMessage: String = "passed",
                        backwardMessage: String = "to go") -> String {
        return [result, reverseTime ? backwardMessage : forwardMessage].joined(separator: cr)
    }

    public static func getFormattedTime(result: String,
                                 units: String? = nil,
                                 reverseTime: Bool,
                                 separator: String = "\n") -> String {
        var finalUnits = reverseTime ? "to go" : "passed"
        if var units = units {
            // Handle 1 which is singular, all fractions are plural in English.
            if result == "1" {
                units = unpluralizeUnits(units)
            }
            finalUnits = [units, finalUnits].joined(separator: space)
        }
        return [result, finalUnits].joined(separator: separator)
    }


    /// Remove terminal "s" from a plural
    ///
    /// This method is fragile!  Will remove an "s" from a word ending is "s" even if it is not a plural.
    /// It can't handle irregular plurals, it can't handle internationalization.
    /// - Parameter units: time units as String
    /// - Returns: time units without terminal "s", or original String if no terminal "s"
    public static func unpluralizeUnits(_ units: String) -> String {
        guard !units.isEmpty, units.count > 1 else { return units }
        let lastCharacter = units.last
        if let lastCharacter = lastCharacter {
            if lastCharacter == "s" || lastCharacter == "S" {
                var truncatedUnits = units
                truncatedUnits.remove(at: truncatedUnits.index(before: truncatedUnits.endIndex))
                return truncatedUnits
            }
        }
        return units
    }

    static let timescales: [TimescaleType: Timescale] = [
        .seconds: Timescale(timescaleType: .seconds, getTime: { timeInterval, _, reverseTime in
            guard let timeInterval = timeInterval as? TimeInterval else { return errorMessage }
            guard let result = integerFormattedDouble(timeInterval) else {
                return errorMessage
            }
            return getFormattedTime(result: result, units: "secs", reverseTime: reverseTime)
        }),
        .minutes: Timescale(timescaleType: .minutes, getTime: { timeInterval, _, reverseTime in
            guard let timeInterval = timeInterval as? TimeInterval else { return errorMessage }
            let minutes = timeInterval / secsPerMin
            guard let result = integerFormattedDouble(minutes) else {
                return errorMessage
            }
            return getFormattedTime(result: result, units: "mins", reverseTime: reverseTime)
        }),
        .hours: Timescale(timescaleType: .hours, getTime: { timeInterval, _, reverseTime in
            guard let timeInterval = timeInterval as? TimeInterval else { return errorMessage }
            let hours = timeInterval / secsPerHour
            guard let result = integerFormattedDouble(hours) else {
                return errorMessage
            }
            return getFormattedTime(result: result, units: "hours", reverseTime: reverseTime)
        }),
        .days: Timescale(timescaleType: .days, getTime: { timeInterval, _, reverseTime in
            guard let timeInterval = timeInterval as? TimeInterval else { return errorMessage }
            let days = timeInterval / secsPerDay
            guard let result = integerFormattedDouble(days) else {
                return errorMessage
            }
            return getFormattedTime(result: result, units: "days", reverseTime: reverseTime)
        }),
        .weeks: Timescale(timescaleType: .weeks, getTime: { TimeInterval, _, reverseTime in
            guard let timeInterval = TimeInterval as? TimeInterval else { return errorMessage }
            let weeks = timeInterval / secsPerWeek
            guard let result = integerFormattedDouble(weeks) else {
                return errorMessage
            }
            return getFormattedTime(result: result, units: "weeks", reverseTime: reverseTime)
        }),
        .months: Timescale(timescaleType: .months, getTime: { timeInterval, _, reverseTime in
            guard let timeInterval = timeInterval as? TimeInterval else { return errorMessage }
            let months = timeInterval / secsPerMonth
            guard let result = integerFormattedDouble(months) else {
                return errorMessage
            }
            return getFormattedTime(result: result, units: "months", reverseTime: reverseTime)
        }),
        .years: Timescale(timescaleType: .years, getTime: { timeInterval, _, reverseTime in
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
            return getFormattedTime(result: result, units: "years", reverseTime: reverseTime)
        }),
        .daysHoursMinsSecs: Timescale(timescaleType: .daysHoursMinsSecs, getTime: { now, date, reverseTime in
            // For this timescale we pass in current date and either birthday or deathday depending on reverseTime.
            guard let now = now as? Date, let date = date as? Date else { return errorMessage }
            var dateComponents: DateComponents
            if reverseTime {
                dateComponents = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: now, to: date)
            } else {
                dateComponents = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: date, to: now)
            }
            if let days = dateComponents.day, let hours = dateComponents.hour, let minutes = dateComponents.minute, let seconds = dateComponents.second {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                let formattedDays = formatter.string(from: NSNumber(value: days))!
                return getFormattedTime(result: "\(formattedDays) d \(hours) h \(minutes) m \(seconds) s", reverseTime: reverseTime)
            }
            return errorMessage
        }),
        .yearsMonthsDays: Timescale(timescaleType: .yearsMonthsDays, getTime: { now, date, reverseTime in
            // For this timescale we pass in current date and either birthday or deathday depending on reverseTime.
            guard let now = now as? Date, let date = date as? Date else { return errorMessage }
            var dateComponents: DateComponents
            if reverseTime {
                dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: now, to: date)
            } else {
                dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date, to: now)
            }
            if let days = dateComponents.day, let years = dateComponents.year, let months = dateComponents.month {
                return getFormattedTime(result: "\(years) y \(months) m \(days) d", reverseTime: reverseTime)
            }
            return errorMessage
        }),
        .hour: Timescale(timescaleType: .hour, getTime: { _, percentage, reverseTime in
            guard let percentage = percentage as? Double else {
                return errorMessage
            }
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            let adjustedTimeInterval = percentage * secsPerHour
            let date = Timescale.referenceHour.addingTimeInterval(adjustedTimeInterval)
            return formatter.string(from: date)
        }),
        .day: Timescale(timescaleType: .day, getTime: { _, percentage, reverseTime in
            guard let percentage = percentage as? Double else {
                return errorMessage
            }
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            let adjustedTimeInterval = percentage * secsPerDay
            let date = Timescale.referenceHour.addingTimeInterval(adjustedTimeInterval)
            return formatter.string(from: date)
        }),
        .month: Timescale(timescaleType: .month, getTime: { _, percentage, reverseTime in
            guard let percentage = percentage as? Double else {
                return errorMessage
            }
            let formatter = DateFormatter()
            // We overide Locale here and for .year, since iOS 12 vs 24 hour clock settings
            // affect the watch display.
            // For example, if 24-hr clock is set, you see 07:10:10 instead of 7:10:10 AM.
            // If we force US locale, the 24 hr clock setting is ignored.
            // See https://stackoverflow.com/questions/63205346/dateformatter-strange-behaviour-on-ios-13-4-1-while-12-hour-date-style-set-in-t
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "MMM dd h:mm:ss a"
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            let adjustedTimeInterval = percentage * secsPerMonth
            let date = Timescale.referenceHour.addingTimeInterval(adjustedTimeInterval)
            return formatter.string(from: date)
        }),
        .year: Timescale(timescaleType: .year, getTime: { _, percentage, reverseTime in
            guard let percentage = percentage as? Double else {
                return errorMessage
            }
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "MMM dd h:mm:ss a"
            formatter.timeZone = TimeZone(secondsFromGMT: 0)

            let adjustedTimeInterval = percentage * secsPerYear
            let date = Timescale.referenceDate.addingTimeInterval(adjustedTimeInterval)
            return formatter.string(from: date)
        }),
        .universe: Timescale(timescaleType: .universe, getTime: { _, percentage, reverseTime in
            guard let percentage = percentage as? Double else {
                return errorMessage
            }
            let adjustedTimeInterval = percentage * ageOfUniverse
            guard let result = integerFormattedDouble(adjustedTimeInterval) else {
                return errorMessage
            }
            return getTime(result: result, reverseTime: reverseTime, forwardMessage: "years since Big Bang", backwardMessage: "years until Big Bang")
        }),
        .percent: Timescale(timescaleType: .percent, getTime: { _, percentage, reverseTime in
            guard let percentage = percentage as? Double else { return errorMessage }
            let formatter = NumberFormatter()
            formatter.numberStyle = .percent
            formatter.roundingMode = reverseTime ? .up : .down
            formatter.maximumFractionDigits = 2
            guard let result = formatter.string(from: NSNumber(value: percentage)) else {
                return errorMessage
            }
            return getFormattedTime(result: result, reverseTime: reverseTime)
        }),
        .blank: timescaleBlank,
    ]

    static func getInstance(_ timescaleType: TimescaleType) -> Timescale {
        if let timescale = timescales[timescaleType] {
            return timescale
        }
        return timescaleBlank
    }

    public static func integerFormattedDouble(_ number: Double, verbosePrecision: Bool = true) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesSignificantDigits = false
        formatter.maximumFractionDigits = 4
        if verbosePrecision && number < 1.0 {
            guard let result = formatter.string(from: NSNumber(value: abs(number))) else {
                return nil
            }
            return result
        }
        // floor() always rounds down
        guard let result = formatter.string(from: NSNumber(value: floor(abs(number)))) else {
            return nil
        }
        return result
    }
}

public enum TimescaleType: Int, Codable, CustomStringConvertible, CaseIterable, Identifiable {
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

    public var id: TimescaleType { self }

    public var description: String {
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
        case .blank: return "No Units"
        }
    }

    var units: String? {
        switch self {
        case .seconds: return "secs"
        case .minutes: return "mins"
        case .hours: return "hours"
        case .days: return "days"
        case .weeks: return "weeks"
        case .daysHoursMinsSecs: return nil
        case .yearsMonthsDays: return nil
        case .months: return "months"
        case .years: return "years"
        case .hour: return nil
        case .day: return nil
        case .month: return nil
        case .year: return nil
        case .universe: return nil
        case .percent: return nil
        case .blank: return nil
        }
    }

    public func fullDescription(reverseTime: Bool) -> String {
        return reverseTime ? [description, "-R"].joined() : description
    }
}
