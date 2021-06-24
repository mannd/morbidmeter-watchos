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

    static var timescaleType = TimescaleType.seconds.rawValue
    static var birthday = Date()
    static var deathday = Date()

    static func defaults() -> [String: Any] {
        let defaultPreferences: [String: Any] = [
            Self.timescaleTypeKey: Self.timescaleType,
            Self.birthdayKey: Self.birthday,
            Self.deathdayKey: Self.deathday,
        ]
        return defaultPreferences
    }
}
