//
//  DateTests.swift
//  MorbidMeterTests
//
//  Created by David Mann on 7/12/21.
//

import XCTest
@testable import MorbidMeter_WatchKit_App

class DateTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testISODate() {
        let now = Date()
        print(now.rawValue)
        print(Date(rawValue: now.rawValue) as Any)
        XCTAssertEqual(now.description, Date(rawValue: now.rawValue)!.description)
    }
}
