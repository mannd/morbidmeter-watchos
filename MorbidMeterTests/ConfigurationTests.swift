//
//  ConfigurationTests.swift
//  MorbidMeterTests
//
//  Created by David Mann on 6/21/21.
//

import XCTest
@testable import MorbidMeter_WatchKit_Extension

class ConfigurationTests: XCTestCase {
    var timescale: Timescale?
    var configuration: Clock?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        timescale = Timescale(name: "Test", maximum: 0, minimum: 0, units: "", reverseUnits: "", endDate: nil, clockTime: nil)
        configuration = Clock(timescale: timescale!, birthday: Date(timeInterval: 10000, since: .distantPast), deathday: Date(timeInterval: 20000, since: .distantPast))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        timescale = nil
        configuration = nil
    }

    func testSimpleConfiguration() {
        XCTAssertEqual(configuration?.longevity(), 10000)
    }

    func testPercentage() {
        let date = Date(timeInterval: 20000, since: .distantPast)
        XCTAssertEqual(try configuration?.percentage(date: date), 1.0)
        let date1 = Date(timeInterval: 10000, since: .distantPast)
        XCTAssertEqual(try configuration?.percentage(date: date1), 0)
        let date2 = Date(timeInterval: 15000, since: .distantPast)
        XCTAssertEqual(try configuration?.percentage(date: date2), 0.5)
        let date3 = Date(timeInterval: 30000, since: .distantPast)
        XCTAssertThrowsError(try configuration?.percentage(date: date3))
    }
}
