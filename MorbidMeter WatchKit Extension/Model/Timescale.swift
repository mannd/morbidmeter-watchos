//
//  Timescale.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/21/21.
//

import Foundation

//enum Timescale: CustomStringConvertible {
//
//    case seconds
//    case minutes
//    case hours
//    case days
//    case daysHoursMinsSecs
//    case years
//    case hour
//    case day
//    case month
//    case year
//    case universe
//    case percent
//    case none
//    case debug
//
//    var description: String {
//        switch self {
//        case .seconds:
//            return
//        }
//    }

struct Timescale {
    let name: String
    let maximum: Double
    let minimum: Double
    let formatString: String
    let units: String = ""
    let reverseUnits: String = ""
    let endDate: Date? = nil

    var duration: Double {
        guard let endDate = endDate else { return maximum - minimum }
        let seconds = Calendar.current.dateComponents([.second], from: Self.referenceDate, to: endDate).second
        return Double(seconds ?? 0)
    }

    // Date equivalent to birthday for calendar based time scales
    static let referenceDate: Date = Calendar.current.date(from: DateComponents(year: 2020, month: 1, day: 1))!

    func proportionalTime(percent: Double, reverseTime: Bool = false) -> Double {
        if reverseTime {
            return maximum - (percent * duration)
        }
        return minimum + (percent * duration)
    }
}
