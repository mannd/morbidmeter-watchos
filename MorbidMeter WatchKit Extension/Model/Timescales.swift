//
//  Timescales.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/23/21.
//

import Foundation

class Timescales {
    static let timescales: [TimescaleType: Timescale] = [
        .seconds: Timescale(
            name: "Seconds",
            units: "seconds",
            reverseUnits: "reverse seconds",
            clockTime: nil,
            clockTime2: { timeInterval, percentage, reverseTime in
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        var result: Double = 0
        //        if reverseTime {
        //            result =
        //        }
        result = timeInterval
        result = floor(abs(result))
        guard let result = formatter.string(from: NSNumber(value: result)) else {
            return "Error"
        }
        if reverseTime {
            return result + "\nsecs to go"
        }
        return result + "\nsecs lived"
    }


        ),
        .minutes: Timescale(
            name: "Minutes",
            units: "minutes",
            reverseUnits: "reverse minutes",
            clockTime: nil,
            clockTime2: nil),
        .percent: Timescale(
            name: "Percent",
            units: "lived",
            reverseUnits: "to go",
            clockTime: { percentage in
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.usesSignificantDigits = true
        formatter.minimumSignificantDigits = 6
        formatter.maximumSignificantDigits = 8
        return formatter.string(from: NSNumber(value: percentage)) ?? "Error"
    },
            clockTime2: { timeInterval, percentage, reverse in
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.usesSignificantDigits = true
        formatter.minimumSignificantDigits = 4
        formatter.maximumSignificantDigits = 6
        guard let result = formatter.string(from: NSNumber(value: percentage)) else {
            return "Error"
        }
        if reverse {
            return result + " to go"
        }
        return result + " lived"
    }
        ),
        // etc.
    ]

    static func getInstance(_ timescaleType: TimescaleType) -> Timescale? {
        return timescales[timescaleType]
    }
}

enum TimescaleType: Int, CustomStringConvertible, CaseIterable, Identifiable {
    case seconds
    case minutes
    case hours
    case days
    case daysHoursMinsSecs
    case years
    case hour
    case day
    case month
    case year
    case universe
    case percent
    case none
    case debug

    var id: TimescaleType { self }

    var description: String {
        switch self {
        case .seconds: return "Seconds"
        case .minutes: return "Minutes"
        case .hours: return "Hours"
        case .days: return "Days"
        case .daysHoursMinsSecs: return "D-H-M-S"
        case .years: return "Years"
        case .hour: return "One Hour"
        case .day: return "One Day"
        case .month: return "One Month"
        case .year: return "One Year"
        case .universe: return "Universe"
        case .percent: return "Percent"
        case .none: return "None"
        case .debug: return "DEBUG"
        }
    }

    func fullDescription(reverseTime: Bool) -> String {
        if reverseTime {
            return description + "-R"
        }
        return description
    }
}
