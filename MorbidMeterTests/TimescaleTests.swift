//
//  TimescaleTests.swift
//  MorbidMeterTests
//
//  Created by David Mann on 6/21/21.
//

import XCTest
@testable import MorbidMeter_WatchKit_Extension

class TimescaleTests: XCTestCase {
    var timescale: Timescale?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        timescale = Timescale(
            name: "Test",
            maximum: 10000,
            minimum: 0,
            formatString: "",
            units: "",
            reverseUnits: "",
            endDate: nil)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSimpleTimescale() {
        guard let timescale = timescale else {
            XCTFail("timescale is nil")
            return
        }
        XCTAssertEqual(timescale.duration, timescale.maximum)
        XCTAssertEqual(timescale.proportionalTime(percent: 1.0), timescale.maximum)
        XCTAssertEqual(timescale.proportionalTime(percent: 0), timescale.minimum)
        XCTAssertEqual(timescale.proportionalTime(percent: 0.5), timescale.maximum / 2)
        XCTAssertEqual(timescale.proportionalTime(percent: 0.3), 3000)
        XCTAssertEqual(timescale.proportionalTime(percent: 1.0, reverseTime: true), timescale.minimum)
        XCTAssertEqual(timescale.proportionalTime(percent: 0, reverseTime: true), timescale.maximum)
        XCTAssertEqual(timescale.proportionalTime(percent: 0.5, reverseTime: true), timescale.maximum / 2)
        XCTAssertEqual(timescale.proportionalTime(percent: 0.3, reverseTime: true), 7000)

        XCTAssertEqual(timescale.startDate.description, "2021-01-01 00:00:00 +0000" )
        print(Timescale.referenceDate)
    }

}
