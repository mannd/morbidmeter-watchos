//
//  Clock.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 7/9/21.
//

import Foundation
import SwiftUI

struct Clock {
    @AppStorage(Preferences.timescaleTypeIntKey) var timescaleTypeInt = Preferences.timescaleTypeInt
    @AppStorage(Preferences.birthdayKey) var birthday = Preferences.birthday
    @AppStorage(Preferences.deathdayKey) var deathday = Preferences.deathday
    @AppStorage(Preferences.reverseTimeKey) var reverseTime = Preferences.reverseTime

    init() {}

    init(birthday: Date, deathday: Date, timescaleTypeInt: Int, reverseTime: Bool) {
        self.birthday = birthday
        self.deathday = deathday
        self.timescaleTypeInt = timescaleTypeInt
        self.reverseTime = reverseTime
    }

    static func activeClock() -> Clock {
       return Clock()
    }

    func getClockTime() -> ClockTime {
        var clockTime = ClockTime()
        do {
            let now = Date()
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
