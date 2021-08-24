//
//  Clock.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 7/9/21.
//

import Foundation
import SwiftUI

/// A Clock has a birthday, deathday, timescale type, and time direction.  It can calculate Moments based on the Lifsspan and Date.
struct Clock: Codable, Equatable {
    var timescaleType: TimescaleType
    var birthday: Date
    var deathday: Date
    var reverseTime: Bool

    let uuid: UUID

    // Clock names used for labels, complications, etc.
    static let fullName = "MorbidMeter"
    static let shortName = "MM"
    static let ultraShortName = "M"
    static let skull = "💀"

    var timescale: Timescale {
        return Timescales.getInstance(timescaleType)
    }

    init() {
        timescaleType = .seconds
        birthday = Date()
        deathday = Date()
        reverseTime = false
        uuid = UUID()
    }

    init(timescaleType: TimescaleType = .seconds, birthday: Date, deathday: Date, reverseTime: Bool, uuid: UUID = UUID()) {
        self.birthday = birthday
        self.deathday = deathday
        self.reverseTime = reverseTime
        self.timescaleType = timescaleType
        self.uuid = uuid
    }

    func getMoment(date: Date = Date()) -> Moment {
        var moment = Moment()
        do {
            let lifespan = try Lifespan(birthday: birthday, deathday: deathday)
            moment.percentage = try lifespan.percentage(date: date, reverse: reverseTime)
            if let getTime = timescale.getTime {
                if timescale.timescaleType == .daysHoursMinsSecs
                    || timescale.timescaleType == .yearsMonthsDays {
                    moment.time = getTime(date, reverseTime ? deathday : birthday, reverseTime)
                } else {
                    moment.time = (getTime(lifespan.timeInterval(date: date, reverseTime: reverseTime), moment.percentage, reverseTime) )
                }
            }
        } catch LifespanError.birthdayInFuture {
            moment.time = "Start in Future"
            moment.percentage = 0
        } catch LifespanError.excessLongevity {
            moment.time = "Time Period Too Long"
            moment.percentage = 0
        } catch LifespanError.alreadyDead {
            moment.time = "You're Finished"
            moment.percentage = 1.0
        } catch LifespanError.lifespanIsZero {
            moment.time = "Time Period Too Short"
            moment.percentage = 0
        } catch {
            moment.time = "Error"
            moment.percentage = 0
        }
        return moment
    }

    func getFormattedMomentTime(formatter: Formatter, date: Date = Date()) -> String {
        // TODO: need to round percentage DOWN (otherwise we get 0% for 99.9%).
        return getMoment(date: date).percentage < 1.0 ?
            formatter.string(for: getMoment(date: date).percentage)! : Self.skull
    }

    func getShortFormattedMomentPercentage(date: Date) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.roundingMode = .down
        return getMoment(date: date).percentage < 1.0 ?
            formatter.string(for: getMoment(date: date).percentage)! : Self.skull
    }

    /// Get moment time string, but replace cr with space
    /// - Parameter date: Date to calculate MomentTime from
    /// - Returns: Unwarpped moment time string
    func getUnwrappedMomentTime(date: Date) -> String {
        let time = getMoment(date: date).time
        let unwrappedTime = String(time.map {
            $0 == "\n" ? " " : $0
        })
        return unwrappedTime
    }

    // TODO: Need short time with just units, not passed or to go for
    // Modular large template ir just with short units ("m" instead of "min")

    func getMomentTimeNumberAndUnits(date: Date) -> [String.SubSequence]? {
        let time = getMoment(date: date).time
        let components = time.split(separator: "\n")
        if components.count == 2 {
            return components
        }
        return nil
    }

    func shortenedTimeString(_ time: String) -> String {
        let components = time.split(separator: " ")
        var shortUnits = ""
        if components.count >= 2 {
            switch components[1] {
            case "years":
                shortUnits = "y"
            case "months":
                shortUnits = "m"
            case "weeks":
                shortUnits = "w"
            case "days":
                shortUnits = "d"
            case "hours":
                shortUnits = "h"
            case "mins", "minutes":
                shortUnits = "min"
            case "secs", "seconds":
                shortUnits = "s"
            default:
                return time
            }
            return [String(components[0]), shortUnits].joined(separator: " ")
        }
        return time
    }

    func getMomentTimeShortUnits(date: Date) -> String {
        let time = getUnwrappedMomentTime(date: date)
        return shortenedTimeString(time)
    }
}

/// A moment of MorbidMeter time, containing elapsed percentage of time and a time string.
struct Moment {
    var percentage: Double = 0
    var time: String = "Error"
}
