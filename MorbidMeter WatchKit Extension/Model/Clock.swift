//
//  Clock.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 7/9/21.
//

import Foundation
import SwiftUI

struct Clock {
    var birthday: Date
    var deathday: Date
    var timescale: Timescale
    var reverseTime: Bool

    init() {
        let userDefaults = UserDefaults.standard
        let now = Date()
        birthday = userDefaults.object(forKey: Preferences.birthdayKey) as? Date ?? now
        deathday = userDefaults.object(forKey: Preferences.deathdayKey) as? Date ?? now
        reverseTime = userDefaults.bool(forKey: Preferences.reverseTimeKey)
        let timescaleTypeInt = userDefaults.integer(forKey: Preferences.timescaleTypeKey)
        let timescaleType = TimescaleType(rawValue: timescaleTypeInt) ?? TimescaleType.blank
        timescale = Timescales.getInstance(timescaleType)
    }

    init(birthday: Date, deathday: Date, timescaleType: TimescaleType, reverseTime: Bool) {
        self.birthday = birthday
        self.deathday = deathday
        self.timescale = Timescales.getInstance(timescaleType)
        self.reverseTime = reverseTime
    }


    func getClockTime() -> ClockTime {
        var clockTime = ClockTime()
        do {
            let now = Date()
            let lifespan = try Lifespan(birthday: birthday, deathday: deathday)
            clockTime.percentage = try lifespan.percentage(date: now, reverse: reverseTime)
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
}

struct ClockTime {
    var percentage: Double = 0
    var time: String = "Error"
}
