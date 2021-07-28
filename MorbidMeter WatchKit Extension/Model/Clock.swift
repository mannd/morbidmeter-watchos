//
//  Clock.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 7/9/21.
//

import Foundation
import SwiftUI

struct Clock: Codable, Equatable {
    // TODO: use timescale enum directly? since it is codable
    var timescaleTypeInt: Int
    var birthday: Date
    var deathday: Date
    var reverseTime: Bool
    let uuid: UUID

    init() {
        timescaleTypeInt = 0
        birthday = Date()
        deathday = Date()
        reverseTime = false
        uuid = UUID()
    }

    init(birthday: Date, deathday: Date, timescaleTypeInt: Int, reverseTime: Bool, uuid: UUID = UUID()) {
        self.birthday = birthday
        self.deathday = deathday
        self.timescaleTypeInt = timescaleTypeInt
        self.reverseTime = reverseTime
        self.uuid = uuid
    }

    static func activeClock() -> Clock {
       return Clock()
    }

    func getClockTime(date: Date = Date()) -> ClockTime {
        var clockTime = ClockTime()
        do {
            let now = date
            let lifespan = try Lifespan(birthday: birthday, deathday: deathday)
            clockTime.percentage = try lifespan.percentage(date: now, reverse: reverseTime)
            let timescale = getTimescale()
            if let getTime = timescale.getTime {
                if timescale.timescaleType == .daysHoursMinsSecs
                    || timescale.timescaleType == .yearsMonthsDays {
                    clockTime.time = getTime(now, reverseTime ? deathday : birthday, reverseTime)
                } else {
                    clockTime.time = (getTime(lifespan.timeInterval(date: now, reverseTime: reverseTime), clockTime.percentage, reverseTime) )
                }
                print("getClockTime()", clockTime.percentage)
            }
        } catch LifespanError.birthdayInFuture {
            clockTime.time = "Start After End"
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

    private func getTimescale() -> Timescale {
        let timescaleType = TimescaleType(rawValue: timescaleTypeInt) ?? TimescaleType.blank
        let timescale = Timescales.getInstance(timescaleType)
        return timescale
    }
}

struct ClockTime {
    var percentage: Double = 0
    var time: String = "Error"
}
