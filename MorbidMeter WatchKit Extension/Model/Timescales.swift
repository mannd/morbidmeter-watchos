//
//  Timescales.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/23/21.
//

import Foundation

class Timescales {
    static let timescales: [TimescaleType: Timescale] = [
        .seconds: Timescale(name: "Seconds", maximum: 0, minimum: 0, formatString: "", units: "seconds", reverseUnits: "reverse seconds", endDate: nil),
        .minutes: Timescale(name: "Minutes", maximum: 0, minimum: 0, formatString: "", units: "minutes", reverseUnits: "reverse minutes", endDate: nil)
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
