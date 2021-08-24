//
//  TimescaleTests.swift
//  MorbidMeterTests
//
//  Created by David Mann on 7/6/21.
//

import XCTest
@testable import MorbidMeter_WatchKit_Extension

class TimescaleTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFormatting() {
        let n1 = 12345.6789
        XCTAssertEqual(Timescales.integerFormattedDouble(n1), "12,345")
        let n2 = 0.1111
        XCTAssertEqual(Timescales.integerFormattedDouble(n2), "0")
        // integerFormattedDouble() ignores negative sign
        let n3 = -123.456
        XCTAssertEqual(Timescales.integerFormattedDouble(n3), "123")
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

    func testTimescalesGetFormattedTime() {
        let formattedResult = Timescales.getFormattedTime(result: "100", units: "sec", reverseTime: false)
        XCTAssertEqual(formattedResult, "100\nsec passed")
        let formattedResult1 = Timescales.getFormattedTime(result: "100 secs", units: nil, reverseTime: false)
        XCTAssertEqual(formattedResult1, "100 secs\npassed")
        let formattedResult2 = Timescales.getFormattedTime(result: "100 secs", units: nil, reverseTime: true)
        XCTAssertEqual(formattedResult2, "100 secs\nto go")
        let formattedResult3 = Timescales.getFormattedTime(result: "100", units: "sec", reverseTime: true)
        XCTAssertEqual(formattedResult3, "100\nsec to go")

    }

}
