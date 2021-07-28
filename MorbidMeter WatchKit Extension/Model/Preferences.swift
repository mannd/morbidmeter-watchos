//
//  Preferences.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/24/21.
//

import Foundation

struct Preferences {
    static let firstRunKey = "firstRunKey"
    static var firstRun = true

    static func defaults() -> [String: Any] {
        let defaultPreferences: [String: Any] = [
            Self.firstRunKey: Self.firstRun,
        ]
        return defaultPreferences
    }
}
