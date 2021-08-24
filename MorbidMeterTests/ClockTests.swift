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
        let clock1 = Clock(timescaleType: .seconds, birthday: clock.birthday.addingTimeInterval(60), deathday: clock.deathday, reverseTime: false)
        XCTAssertNotEqual(clock.birthday.description, clock1.birthday.description)
    }

    func testGetShortTime() {
        var clock = ClockData.test.clock
        clock.timescaleType = .seconds
        print(clock.getMoment(date: Date()))
        XCTAssertEqual(clock.getMoment(date: Date()).time, "3,600\nsecs passed")
        XCTAssertEqual(clock.getUnwrappedMomentTime(date: Date()), "3,600 secs passed")
    }

    func testShortenedTimeString() {
        var clock = ClockData.test.clock
        XCTAssertEqual(clock.shortenedTimeString("3,000 secs"), "3,000 s")
        XCTAssertEqual(clock.shortenedTimeString("0d 8h 20m"), "0d 8h 20m")
        XCTAssertEqual(clock.shortenedTimeString("11:30 PM"), "11:30 PM")
        XCTAssertEqual(clock.shortenedTimeString("3,000 mins"), "3,000 min")
        XCTAssertEqual(clock.shortenedTimeString("3,000 hours"), "3,000 h")
        XCTAssertEqual(clock.shortenedTimeString("3,000 years"), "3,000 y")
        XCTAssertEqual(clock.shortenedTimeString("3,000 months"), "3,000 m")
        XCTAssertEqual(clock.shortenedTimeString("3,000 weeks"), "3,000 w")
        XCTAssertEqual(clock.shortenedTimeString("3,000 days"), "3,000 d")
        XCTAssertEqual(clock.shortenedTimeString("3,000 secs"), "3,000 s")
        clock.timescaleType = .seconds
        print("shortend time units", clock.getMomentTimeShortUnits(date: Date()))
    }
}
