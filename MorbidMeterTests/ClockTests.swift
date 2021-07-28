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
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDefaultClock() {
        var clock = Clock()
        XCTAssertEqual(clock.birthday.description, clock.deathday.description)
        clock.deathday = Date().addingTimeInterval(60)
        XCTAssertNotEqual(clock.birthday.description, clock.deathday.description)
        let clock1 = Clock(birthday: clock.birthday.addingTimeInterval(60), deathday: clock.deathday, timescaleTypeInt: 0, reverseTime: false)
        XCTAssertNotEqual(clock.birthday.description, clock1.birthday.description)
    }
}
