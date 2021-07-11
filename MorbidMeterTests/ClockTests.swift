//
//  ClockTests.swift
//  MorbidMeterTests
//
//  Created by David Mann on 7/10/21.
//

import XCTest
@testable import MorbidMeter_WatchKit_Extension

class ClockTests: XCTestCase {
    var savedBirthday: Any?
    var savedDeathday: Any?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        savedBirthday = UserDefaults.standard.object(forKey: Preferences.birthdayKey)
        savedDeathday = UserDefaults.standard.object(forKey: Preferences.deathdayKey)
        UserDefaults.standard.removeObject(forKey: Preferences.birthdayKey)
        UserDefaults.standard.removeObject(forKey: Preferences.deathdayKey)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        UserDefaults.standard.set(savedBirthday, forKey: Preferences.birthdayKey)
        UserDefaults.standard.set(savedDeathday, forKey: Preferences.deathdayKey)
    }

    func testDefaultClock() {
        var clock = Clock()
        XCTAssertEqual(clock.birthday.description, clock.deathday.description)
        clock.deathday = Date().addingTimeInterval(60)
        XCTAssertNotEqual(clock.birthday.description, clock.deathday.description)
        UserDefaults.standard.set(Date() + 600, forKey: Preferences.deathdayKey)
        let clock1 = Clock()
        XCTAssertNotEqual(clock1.birthday.description, clock1.deathday.description)
    }
}
