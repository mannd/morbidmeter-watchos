//
//  Preferences.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/24/21.
//

import Foundation

struct Preferences {
    static let timescaleTypeKey = "timescaleTypeKey"
    static let birthdayKey = "birthdayKey"
    static let deathdayKey = "deathdayKey"
    static let reverseTimeKey = "reverseTimeKey"
    static let firstRunKey = "firstRunKey"

    static var timescaleTypeInt = TimescaleType.blank.rawValue
    static var birthday = Date()
    static var deathday = Date()
    static var reverseTime = false
    static var firstRun = true

    static func defaults() -> [String: Any] {
        let defaultPreferences: [String: Any] = [
            Self.timescaleTypeKey: Self.timescaleTypeInt,
            Self.birthdayKey: Self.birthday,
            Self.deathdayKey: Self.deathday,
            Self.reverseTimeKey: Self.reverseTime,
            Self.firstRunKey: Self.firstRun,
        ]
        return defaultPreferences
    }
}
