//
//  Clock.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 7/9/21.
//

import Foundation
import SwiftUI

struct Clock: Codable, Equatable {
    var timescaleType: TimescaleType
    var birthday: Date
    var deathday: Date
    var reverseTime: Bool

    let uuid: UUID

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

    func getClockTime(date: Date = Date()) -> ClockTime {
        var clockTime = ClockTime()
        do {
            let lifespan = try Lifespan(birthday: birthday, deathday: deathday)
            clockTime.percentage = try lifespan.percentage(date: date, reverse: reverseTime)
            if let getTime = timescale.getTime {
                if timescale.timescaleType == .daysHoursMinsSecs
                    || timescale.timescaleType == .yearsMonthsDays {
                    clockTime.time = getTime(date, reverseTime ? deathday : birthday, reverseTime)
                } else {
                    clockTime.time = (getTime(lifespan.timeInterval(date: date, reverseTime: reverseTime), clockTime.percentage, reverseTime) )
                }
                print("getClockTime()", clockTime.percentage)
            }
        } catch LifespanError.birthdayInFuture {
            clockTime.time = "Start in Future"
            clockTime.percentage = 0
        } catch LifespanError.excessLongevity {
            clockTime.time = "Time Period Too Long"
            clockTime.percentage = 0
        } catch LifespanError.alreadyDead {
            clockTime.time = "You're Finished"
            clockTime.percentage = 1.0
        } catch LifespanError.lifespanIsZero {
            clockTime.time = "Time Period Too Short"
            clockTime.percentage = 0
        } catch {
            clockTime.time = "Error"
            clockTime.percentage = 0
        }
        return clockTime
    }

    // TODO: distinguish clocktime from time: this returns string not ClockTime
    func getFormattedClockTime(formatter: Formatter, date: Date = Date()) -> String {
        // TODO: need to round percentage DOWN (otherwise we get 0% for 99.9%).
        return getClockTime(date: date).percentage < 1.0 ?
            formatter.string(for: getClockTime(date: date).percentage)! : Self.skull
    }

    func getShortFormattedPercentage(date: Date) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.roundingMode = .down
        return getClockTime(date: date).percentage < 1.0 ?
            formatter.string(for: getClockTime(date: date).percentage)! : Self.skull
    }

    /// Get time string, but replace cr with space
    /// - Parameter date: Date to calculate ClockTime from
    /// - Returns: Modified time string
    func getShortTime(date: Date) -> String {
        let time = getClockTime(date: date).time
        let shortTime = String(time.map {
            $0 == "\n" ? " " : $0
        })
        return shortTime
    }

    func getTimeAndUnits(date: Date) -> [String.SubSequence]? {
        let time = getClockTime(date: date).time
        let components = time.split(separator: "\n")
        if components.count == 2 {
            return components
        }
        return nil
    }
}

struct ClockTime {
    var percentage: Double = 0
    var time: String = "Error"
}
