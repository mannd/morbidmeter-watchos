//
//  Configuration.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/21/21.
//

import Foundation

struct Clock {
    var timescale: Timescale
    var birthday: Date
    var deathday: Date

    func longevity() -> Double {
        return deathday.timeIntervalSince(birthday)
    }

    func percentage(date: Date) -> Double? {
        let longevity = longevity()
        let duration = date.timeIntervalSince(birthday)
        if timescale.reverseTime {
            return 1.0 - duration / longevity
        }
        return duration / longevity
    }


}
