//
//  TimescaleTests.swift
//  MorbidMeterTests
//
//  Created by David Mann on 7/6/21.
//

import XCTest
import ClockCore
@testable import MorbidMeter_WatchKit_App

class TimescaleTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFormatting() {
        // Assumes verbosePrecision uses max fractional precision of 4.
        let n1 = 12345.6789
        XCTAssertEqual(Timescales.integerFormattedDouble(n1), "12,345")
        let n2 = 0.1111
        XCTAssertEqual(Timescales.integerFormattedDouble(n2, verbosePrecision: false), "0")
        XCTAssertEqual(Timescales.integerFormattedDouble(n2, verbosePrecision: true), "0.1111")
        // integerFormattedDouble() ignores negative sign
        let n3 = -123.456
        XCTAssertEqual(Timescales.integerFormattedDouble(n3, verbosePrecision: false), "123")
        XCTAssertEqual(Timescales.integerFormattedDouble(n3, verbosePrecision: true), "123.456")
        let n4 = -123.456789
        XCTAssertEqual(Timescales.integerFormattedDouble(n4, verbosePrecision: false), "123")
        XCTAssertEqual(Timescales.integerFormattedDouble(n4, verbosePrecision: true), "123.4568")
    }

    func testTimescalesGetTime() {
        let result = Timescales.getTime(result: "100 sec", reverseTime: false)
        XCTAssertEqual(result, "100 sec\npassed")
        let result0 = Timescales.getTime(result: "100 sec", reverseTime: true)
        XCTAssertEqual(result0, "100 sec\nto go")
        let result1 = Timescales.getTime(result: "100", reverseTime: false, forwardMessage: "sec passed", backwardMessage: "sec to go")
        XCTAssertEqual(result1, "100\nsec passed")
        let result2 = Timescales.getTime(result: "100", reverseTime: true, forwardMessage: "sec passed", backwardMessage: "sec to go")
        XCTAssertEqual(result2, "100\nsec to go")
    }

    public func testTimescalesGetFormattedTime() {
        let formattedResult = Timescales.getFormattedTime(result: "100", units: "sec", reverseTime: false)
        XCTAssertEqual(formattedResult, "100\nsec passed")
        let formattedResult1 = Timescales.getFormattedTime(result: "100 secs", units: nil, reverseTime: false)
        XCTAssertEqual(formattedResult1, "100 secs\npassed")
        let formattedResult2 = Timescales.getFormattedTime(result: "100 secs", units: nil, reverseTime: true)
        XCTAssertEqual(formattedResult2, "100 secs\nto go")
        let formattedResult3 = Timescales.getFormattedTime(result: "100", units: "sec", reverseTime: true)
        XCTAssertEqual(formattedResult3, "100\nsec to go")
    }

    func testUnpluralizeUnits() {
        // strings with length 0 or 1 are just returned
        let units0 = "s"
        XCTAssertEqual(Timescales.unpluralizeUnits(units0), "s")
        let units00 = ""
        XCTAssertEqual(Timescales.unpluralizeUnits(units00), "")
        let units1 = "minute"
        XCTAssertEqual(Timescales.unpluralizeUnits(units1), "minute")
        let units2 = "minutes"
        XCTAssertEqual(Timescales.unpluralizeUnits(units2), "minute")
        let units3 = "MINUTES"
        XCTAssertEqual(Timescales.unpluralizeUnits(units3), "MINUTE")
    }

    func testTimescalesGetFormattedTimeAndHandlePlurals() {
        let formattedResult = Timescales.getFormattedTime(result: "1.1", units: "secs", reverseTime: false)
        XCTAssertEqual(formattedResult, "1.1\nsecs passed")
        let formattedResult1 = Timescales.getFormattedTime(result: "0.9", units: "secs", reverseTime: false)
        XCTAssertEqual(formattedResult1, "0.9\nsecs passed")
        let formattedResult2 = Timescales.getFormattedTime(result: "1", units: "secs", reverseTime: true)
        XCTAssertEqual(formattedResult2, "1\nsec to go")
        let formattedResult3 = Timescales.getFormattedTime(result: "1", units: "SECS", reverseTime: true)
        XCTAssertEqual(formattedResult3, "1\nSEC to go")
        let formattedResult4 = Timescales.getFormattedTime(result: "1", units: "secs", reverseTime: true)
        XCTAssertEqual(formattedResult4, "1\nsec to go")
        let formattedResult5 = Timescales.getFormattedTime(result: "2", units: "secs", reverseTime: true)
        XCTAssertEqual(formattedResult5, "2\nsecs to go")
    }
}
