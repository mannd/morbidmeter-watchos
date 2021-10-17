//
//  ClockTests.swift
//  MorbidMeterTests
//
//  Created by David Mann on 7/10/21.
//

import XCTest
@testable import MorbidMeter_WatchKit_Extension
import SwiftUI

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

    func testDateFromPercentage() {
        let clock = ClockData.test.clock
        let date1 = clock.dateFromPercentage(percent: 0)
        XCTAssertEqual(clock.birthday, date1)
        let date2 = clock.dateFromPercentage(percent: 1)
        XCTAssertEqual(clock.deathday, date2)
        let date3 = clock.dateFromPercentage(percent: 0.5)
        // Just need to be approximate here, within a minute,
        // since Date() is midway between bd and dd in test clock.
        let difference = (date3?.distance(to: Date()))!
        XCTAssert(difference < 60 * 60)
    }

    func testPrintDateFromPercentageTable() {
        let clock = ClockData.test.clock
        for i in 0...100 {
            debugPrint("Percent \(i)% = \(clock.dateFromPercentage(percent: Double(i)/100.0).debugDescription))")
        }
        XCTAssertEqual(clock.dateFromPercentage(percent: 0), clock.birthday)
        XCTAssertEqual(clock.dateFromPercentage(percent: 1.0), clock.deathday)
    }

    func testGetClockLandmarks() {
        let clock = ClockData.test.clock
        let clockLandmarks = clock.getClockLandmarks()
        debugPrint(clockLandmarks as Any)
        XCTAssertEqual(clockLandmarks[clock.birthday], 0)
        XCTAssertEqual(clockLandmarks[clock.deathday], 99)
    }

    func testGetClockLandmark2() {
        let clock = ClockData.test.clock
        let clockLandmarks = clock.getClockLandmarks()
        let clockLandmarks2 = clock.getClockLandmarks2()
        debugPrint(clockLandmarks as Any)
        debugPrint(clockLandmarks2 as Any)
        XCTAssertEqual(Array(clockLandmarks.keys).sorted()[50], clockLandmarks2[50])
        XCTAssertEqual(clockLandmarks2[0], clock.birthday)
        XCTAssertEqual(clockLandmarks2[100], clock.deathday)
        XCTAssertEqual(clockLandmarks.count, 100)
        XCTAssertEqual(clockLandmarks2.count, 101)
    }

    func testGetLandmarkDates() {
        let clock = ClockData.test.clock
        let dates = clock.getClockLandmarkDates(minimalTimeInterval: 0, after: clock.birthday, timeInterval: TimeConstants.oneWeek)
        debugPrint(dates as Any)
        XCTAssertEqual(dates.count, 101)
        XCTAssertEqual(dates[0], clock.birthday)
        XCTAssertEqual(dates[dates.count-1], clock.deathday)
        let dates2 = clock.getClockLandmarkDates(minimalTimeInterval: 0, after: clock.birthday.addingTimeInterval(1), timeInterval: TimeConstants.oneHour)
        XCTAssert(dates2[0] > clock.birthday)
        XCTAssert(dates2[dates2.count-1] < clock.deathday)
    }

    // Original getClockLandmarks() 7 times slower than getClockLandmarks2()
//    func testLandmarkTiming() {
//        let clock = ClockData.test.clock
//        for _ in 0..<100000 {
//            let _ = clock.getClockLandmarks()
//            let _ = clock.getClockLandmarks2(startDate: clock.birthday, endDate: clock.deathday)
//        }
//    }

    func testLifespanLongerThan() {
        let clock = ClockData.longLifeTest.clock
        XCTAssert(clock.lifespanLongerThan(timeInterval: 40 * TimeConstants.oneYear))
        XCTAssertFalse(clock.lifespanLongerThan(timeInterval: 90 * TimeConstants.oneYear))
        XCTAssertTrue(clock.lifespanLongerThan(timeInterval: 79 * TimeConstants.oneYear))
        XCTAssertFalse(clock.lifespanLongerThan(timeInterval: 81 * TimeConstants.oneYear))
    }
}
