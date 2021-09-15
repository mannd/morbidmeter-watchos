//
//  LifespanTests.swift
//  MorbidMeterTests
//
//  Created by David Mann on 7/3/21.
//

import XCTest
@testable import MorbidMeter_WatchKit_Extension

class LifespanTests: XCTestCase {
    static let birthday = Date()
    static let deathday = Calendar.current.date(byAdding: .year, value: 80, to: birthday)!
    static let middleday = Calendar.current.date(byAdding: .year, value: 40, to: birthday)!


    var lifespan: Lifespan?
    var negativeLifespan: Lifespan?
    var zeroLifespan: Lifespan?
    var excessiveLifespan: Lifespan?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        lifespan = try? Lifespan(birthday: Self.birthday, deathday: Self.deathday)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        lifespan = nil
        negativeLifespan = nil
        zeroLifespan = nil
        excessiveLifespan = nil
    }

    func testLongevity() {
        XCTAssertEqual(try? lifespan!.longevity(), Self.deathday.timeIntervalSince(Self.birthday))
    }

    // Test throwing errors.
    func testBadLongevity() {
        XCTAssertThrowsError(negativeLifespan = try Lifespan(birthday: Self.deathday, deathday: Self.birthday))
        if let zeroLifespan = try? Lifespan(birthday: Self.birthday, deathday: Self.birthday) {
            XCTAssertThrowsError(try zeroLifespan.longevity())
        }
        if let excessiveLifespan = try? Lifespan(birthday: Self.birthday, deathday: Calendar.current.date(byAdding: .year, value: 120, to: Self.birthday)!) {
            XCTAssertThrowsError(try excessiveLifespan.longevity())
        }
    }

    func testPercentage() {
        guard let lifespan = lifespan else {
            XCTFail("lifespan was null")
            return
        }
        guard let longevity = try? lifespan.longevity() else {
            XCTFail("longevity was null")
            return
        }
        XCTAssertEqual(longevity, Self.deathday.timeIntervalSince(Self.birthday))
        let today1 = Self.deathday
        XCTAssertEqual(try lifespan.percentage(date: today1), 1.0)
        let today2 = Calendar.current.date(byAdding: .year, value: 40, to: Self.birthday)
        XCTAssertEqual(try lifespan.percentage(date: today2!), 0.5, accuracy: 0.001)
        let today3 = Calendar.current.date(byAdding: .year, value: 20, to: Self.birthday)
        XCTAssertEqual(try lifespan.percentage(date: today3!), 0.25, accuracy: 0.001)
        let today4 = Calendar.current.date(byAdding: .year, value: 60, to: Self.birthday)
        XCTAssertEqual(try lifespan.percentage(date: today4!), 0.75, accuracy: 0.001)
        XCTAssertEqual(try lifespan.percentage(date: today4!, reverse: true), 0.25, accuracy: 0.001)
        let date = Date(timeInterval: -1, since: Self.birthday)
        XCTAssertThrowsError(try lifespan.percentage(date: date, reverse: true))
    }

    func testTimeInterval() {
        let date = Self.deathday
        XCTAssertEqual(lifespan?.timeInterval(date: date, reverseTime: false), Self.deathday.timeIntervalSince(Self.birthday))
        XCTAssertEqual(lifespan?.timeInterval(date: date, reverseTime: true), 0)
        let date1 = Date()
        XCTAssertEqual(lifespan?.timeInterval(date: date1, reverseTime: false), date1.timeIntervalSince(Self.birthday))
        XCTAssertEqual(lifespan?.timeInterval(date: date1, reverseTime: true), Self.deathday.timeIntervalSince(date1))
    }

    func testDateFromPercentage() {
        let date1 = lifespan?.dateFromPercentage(percent: 0)
        XCTAssertEqual(lifespan?.birthday, date1)
        let date2 = lifespan?.dateFromPercentage(percent: 1)
        XCTAssertEqual(lifespan?.deathday, date2)
        let date3 = lifespan?.dateFromPercentage(percent: 0.5)
        // Just need to be approximate here, within a day, since we are using a longevity of 80 years.
        let difference = (date3?.distance(to: Self.middleday))!
        XCTAssert(difference < 24 * 60 * 60)
    }
}
