//
//  ComplicationViews.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 7/8/21.
//

import SwiftUI
import ClockKit

struct ComplicationViews: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ComplicationViewCircular: View {
    @AppStorage(Preferences.timescaleTypeKey) var timescaleTypeInt = Preferences.timescaleTypeInt
     @AppStorage(Preferences.birthdayKey) var birthday = Preferences.birthday
     @AppStorage(Preferences.deathdayKey) var deathday = Preferences.deathday
     @AppStorage(Preferences.reverseTimeKey) var reverseTime = Preferences.reverseTime
    var percentage: Double = 0

    var body: some View {
        ZStack {
            ProgressView(
                "M", value: percentage, total: 1.0 )
                .progressViewStyle(CircularProgressViewStyle())
        }
    }

    mutating func updateClock() {
        print("updateClock()")
        let timescaleType = TimescaleType(rawValue: timescaleTypeInt) ?? TimescaleType.blank
        let clock = Clock(birthday: birthday, deathday: deathday, timescaleType: timescaleType, reverseTime: reverseTime)
        let clockTime = clock.getClockTime()
        percentage = clockTime.percentage
     }

}

struct ComplicationViews_Previews: PreviewProvider {
    static var previews: some View {
        //        ComplicationViews()
        CLKComplicationTemplateGraphicCircularView(
            ComplicationViewCircular()
        ).previewContext()
    }
}
