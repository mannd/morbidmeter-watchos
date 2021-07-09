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
            clockTime.time = "BD after DD"
            clockTime.percentage = 0
        } catch LifespanError.excessLongevity {
            clockTime.time = "Lifespan Too Long"
            clockTime.percentage = 0
        } catch LifespanError.alreadyDead {
            clockTime.time = "Already Dead"
            clockTime.percentage = 1.0
        } catch LifespanError.lifespanIsZero {
            clockTime.time = "Lifespan too short"
            clockTime.percentage = 0
        } catch {
            clockTime.time = "Lifespan Error"
            clockTime.percentage = 0
        }
        return clockTime
    }
}

struct ClockTime {
    var percentage: Double = 0
    var time: String = "Error"
}
