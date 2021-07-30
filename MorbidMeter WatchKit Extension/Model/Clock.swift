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
            let now = date
            let lifespan = try Lifespan(birthday: birthday, deathday: deathday)
            clockTime.percentage = try lifespan.percentage(date: now, reverse: reverseTime)
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

    func getFormattedClockTime(formatter: Formatter, date: Date = Date()) -> String {
        // TODO: need to round percentage DOWN (otherwise we get 0% for 99.9%).
        return getClockTime(date: date).percentage < 1.0 ?
            formatter.string(for: getClockTime(date: date).percentage)! : "💀"
    }
}

struct ClockTime {
    var percentage: Double = 0
    var time: String = "Error"
}
