//
//  Clock.swift
//  ClockCore
//
//  Created by David Mann on 5/22/25.
//

import Foundation
import SwiftUI

/// A Clock has a birthday, deathday, timescale type, and time direction.  It can calculate Moments based on the Lifsspan and Date.
public struct Clock: Codable, Equatable {
    public var timescaleType: TimescaleType
    public var birthday: Date
    public var deathday: Date
    public var reverseTime: Bool

    let uuid: UUID

    // Clock names used for labels, complications, etc.
    public static let fullName = "MorbidMeter"
    public static let shortName = "MM"
    public static let ultraShortName = "M"
    public static let skull = "💀"

    var timescale: Timescale {
        return Timescales.getInstance(timescaleType)
    }

    public init() {
        timescaleType = .seconds
        birthday = Date()
        deathday = Date()
        reverseTime = false
        uuid = UUID()
    }

    public init(timescaleType: TimescaleType = .seconds, birthday: Date, deathday: Date, reverseTime: Bool, uuid: UUID = UUID()) {
        self.birthday = birthday
        self.deathday = deathday
        self.reverseTime = reverseTime
        self.timescaleType = timescaleType
        self.uuid = uuid
    }

    public func dateFromPercentage(percent: Double) -> Date? {
        if let lifespan = try? Lifespan(birthday: birthday, deathday: deathday) {
            return lifespan.dateFromPercentage(percent: percent)
        }
        return nil
    }

    // Older algorithm that does work, remains for testing of behavior
    public func getClockLandmarks(minimalTimeInterval: TimeInterval = 0) -> [Date: Int] {
        var dates: [Date: Int] = [:]
        dates[birthday] = 0
        dates[deathday] = 99
        var lastDate = birthday
        for i in 1...98 {
            if let date = dateFromPercentage(percent: Double(i)/100.0) {
                if date.timeIntervalSince(lastDate) > minimalTimeInterval {
                    dates[date] = i
                    lastDate = date
                }
            }
        }
        return dates
    }

    // More efficient algorithm
    public func getClockLandmarks2(minimalTimeInterval: TimeInterval = 0) -> [Date] {
        var dates: [Date] = []
        let firstLandmark = birthday
        let lastLandmark = deathday
        dates.append(firstLandmark)
        var lastDate = firstLandmark
        for counter in 1..<100 {
            if let date = dateFromPercentage(percent: Double(counter)/100.0) {
                if date.timeIntervalSince(lastDate) > minimalTimeInterval {
                    dates.append(date)
                    lastDate = date
                }
            }
        }
        dates.append(lastLandmark)
        return dates
    }

    public func getClockLandmarkDates(minimalTimeInterval: TimeInterval = 0, after date: Date, timeInterval: TimeInterval) -> [Date] {
        let startDate = date
        let endDate = startDate.addingTimeInterval(timeInterval)

        let landmarks = getClockLandmarks2(minimalTimeInterval: minimalTimeInterval).filter { $0 >= startDate && $0 <= endDate }
        return landmarks
    }

    public func lifespanLongerThan(timeInterval: TimeInterval) -> Bool {
        if let lifespan = try? Lifespan(birthday: birthday, deathday: deathday), let longevity = try? lifespan.longevity() {
            return longevity > timeInterval
        }
        return false
    }

    public func getMoment(date: Date = Date()) -> Moment {
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
            moment.percentage = reverseTime ? 0.0 : 1.0
        } catch LifespanError.lifespanIsZero {
            moment.time = "Time Period Too Short"
            moment.percentage = 0
        } catch {
            moment.time = "Error"
            moment.percentage = 0
        }
        return moment
    }

    public func getShortFormattedMomentPercentage(date: Date, fractionDigits: Int = 0) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = fractionDigits
        formatter.roundingMode = reverseTime ? .up : .down
        let percentage = getMoment(date: date).percentage
        return percentage > 0.0 && percentage < 1.0 ?
        formatter.string(for: percentage) ?? Self.skull : Self.skull
    }

    /// Get moment time string, but replace cr with space
    /// - Parameter date: Date to calculate MomentTime from
    /// - Returns: Unwarpped moment time string
    public func getUnwrappedMomentTime(date: Date) -> String {
        let time = getMoment(date: date).time
        let unwrappedTime = String(time.map {
            $0 == "\n" ? " " : $0
        })
        return unwrappedTime
    }

    public func getMomentTimeNumberAndUnits(date: Date) -> [String.SubSequence]? {
        let time = getMoment(date: date).time
        let components = time.split(separator: "\n")
        if components.count == 2 {
            return components
        }
        return nil
    }

    public func shortenedTimeString(_ time: String) -> String {
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

    public func getMomentTimeShortUnits(date: Date) -> String {
        let time = getUnwrappedMomentTime(date: date)
        return shortenedTimeString(time)
    }
}

/// A moment of MorbidMeter time, containing elapsed percentage of time and a time string.
public struct Moment {
    public var percentage: Double = 0
    public var time: String = "Error"
}

///  The two clock endpoints are birthday and deathday.
public enum Endpoint {
    case birthday
    case deathday
}
