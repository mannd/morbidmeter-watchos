//
//  Lifespan.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 7/3/21.
//

import Foundation

/// A Lifespan contains a birthday and deathday, and can determine time intervals and percentages of the Lifespan from a specific Date.
struct Lifespan {
    private let dateInterval: DateInterval

    var birthday: Date { dateInterval.start }
    var deathday: Date { dateInterval.end }

    init(birthday: Date, deathday: Date) throws {
        guard deathday >= birthday else { throw LifespanError.negativeLongevity }
        dateInterval = DateInterval(start: birthday, end: deathday)
    }

    func longevity() throws -> TimeInterval {
        let duration = dateInterval.duration
        guard duration > 0 else { throw LifespanError.lifespanIsZero }
        guard duration / TimeConstants.oneYear < 120 else { throw LifespanError.excessLongevity }
        return duration
    }

    func dateFromPercentage(percent: Double) -> Date? {
        guard percent >= 0 && percent <= 1.0 else { return nil }
        do {
            var duration = try longevity()
            duration *= percent
            return birthday.addingTimeInterval(duration)
        } catch {
            return nil
        }
    }

    func percentage(date: Date, reverse: Bool = false) throws -> Double {
        let duration = date.timeIntervalSince(dateInterval.start)
        let ratio = try duration / longevity()
        guard ratio <= 1.0 else { throw LifespanError.alreadyDead }
        guard ratio >= 0 else { throw LifespanError.birthdayInFuture }
        if reverse {
            return 1.0 - ratio
        }
        return ratio
    }

    func timeInterval(date: Date, reverseTime: Bool) -> TimeInterval {
        if reverseTime {
            return timeUntilDeath(date: date)
        }
        return timeSinceBirth(date: date)
    }

    private func timeSinceBirth(date: Date) -> TimeInterval {
        return date.timeIntervalSince(dateInterval.start)
    }

    private func timeUntilDeath(date: Date) -> TimeInterval {
        return dateInterval.end.timeIntervalSince(date)
    }
}

enum LifespanError: Error {
    case negativeLongevity
    case lifespanIsZero
    case excessLongevity
    case alreadyDead
    case birthdayInFuture
}

