//
//  ClockTests.swift
//  MorbidMeterTests
//
//  Created by David Mann on 6/27/21.
//

import XCTest
@testable import MorbidMeter_WatchKit_Extension

class ClockTests: XCTestCase {
    static let birthday = Date()
    static let deathday = Calendar.current.date(byAdding: .year, value: 80, to: birthday)

    var clock: Clock?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        clock = Clock(timescale: Timescales.getInstance(.percent)!, birthday: Self.birthday, deathday: Self.deathday!)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPercentage() {
        guard let longevity = clock?.longevity() else {
            XCTFail("longevity was null")
            return
        }
        XCTAssertEqual(longevity, Self.deathday!.timeIntervalSince(Self.birthday))
        let today = Self.birthday
        XCTAssertEqual(try clock?.percentage(date: today), 0)
        let today1 = Self.deathday
        XCTAssertEqual(try clock?.percentage(date: today1!), 1.0)
        let today2 = Calendar.current.date(byAdding: .year, value: 40, to: Self.birthday)
        XCTAssertEqual(try clock!.percentage(date: today2!), 0.5, accuracy: 0.001)
        let today3 = Calendar.current.date(byAdding: .year, value: 20, to: Self.birthday)
        XCTAssertEqual(try clock!.percentage(date: today3!), 0.25, accuracy: 0.001)
        let today4 = Calendar.current.date(byAdding: .year, value: 60, to: Self.birthday)
        XCTAssertEqual(try clock!.percentage(date: today4!), 0.75, accuracy: 0.001)
        clock?.timescale.reverseTime = true
        XCTAssertEqual(try clock!.percentage(date: today4!), 0.25, accuracy: 0.001)

        clock?.timescale.reverseTime = false
        let date = Date(timeInterval: -1, since: Self.birthday)
        XCTAssertThrowsError(try clock!.percentage(date: date))
    }


}
