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
    private static let space = " "

    static let secsPerMin = 60.0
    static let secsPerHour = 60.0 * 60.0
    static let secsPerDay = secsPerHour * 24.0
    static let secsPerWeek = secsPerDay * 7.0
    static let secsPerYear = secsPerDay * 364.25
    static let secsPerMonth = secsPerYear / 12.0
    static let ageOfUniverse = 13_770_000_000.0

    static let timescaleBlank = Timescale(timescaleType: .blank, getTime: { _, _, _ in
        return "" })

    // TODO: get rid of getTime()
    static func getTime(result: String,
                        reverseTime: Bool,
                        forwardMessage: String = "passed",
                        backwardMessage: String = "to go") -> String {
        return [result, reverseTime ? backwardMessage : forwardMessage].joined(separator: cr)
    }

    static func getFormattedTime(result: String,
                                 units: String? = nil,
                                 reverseTime: Bool) -> String {
        var finalUnits = reverseTime ? "to go" : "passed"
        if let units = units {
            finalUnits = [units, finalUnits].joined(separator: space)
        }
        return [result, finalUnits].joined(separator: cr)
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
            formatter.dateFormat = "MMM dd hh:mm:ss a"
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
            formatter.dateFormat = "MMM dd h:mm:ss a"
            formatter.timeZone = TimeZone(secondsFromGMT: 0)

            let adjustedTimeInterval = percentage * secsPerYear
            let date = Timescale.referenceDate.addingTimeInterval(adjustedTimeInterval)
            return formatter.string(from: date)
        }),
        // TODO: Trash Big Bang?
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
            formatter.usesSignificantDigits = true
            formatter.minimumSignificantDigits = 4
            formatter.maximumSignificantDigits = 6
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

    static func integerFormattedDouble(_ number: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        guard let result = formatter.string(from: NSNumber(value: floor(abs(number)))) else {
            return nil
        }
        return result
    }

}

enum TimescaleType: Int, Codable, CustomStringConvertible, CaseIterable, Identifiable {
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

    func fullDescription(reverseTime: Bool) -> String {
        return reverseTime ? [description, "-R"].joined() : description
    }
}
