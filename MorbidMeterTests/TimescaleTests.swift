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

}
