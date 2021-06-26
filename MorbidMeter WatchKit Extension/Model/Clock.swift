//
//  Configuration.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/21/21.
//

import Foundation

struct Clock {
    var timescale: Timescale
    var reverseTime: Bool
    var birthday: Date
    var deathday: Date

    func longevity() -> Int? {
        return Calendar.current.dateComponents([.second], from: birthday, to: deathday).second
    }

    func percentage(date: Date) -> Double? {
        guard let longevity = longevity() else { return nil }
        guard let duration = Calendar.current.dateComponents([.second], from: birthday, to: date).second else { return nil }
        return Double(duration) / Double(longevity)
    }
}
