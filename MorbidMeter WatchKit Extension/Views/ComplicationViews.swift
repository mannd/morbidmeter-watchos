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
    @AppStorage(Preferences.timescaleTypeIntKey) var timescaleTypeInt = Preferences.timescaleTypeInt
    @AppStorage(Preferences.birthdayKey) var birthday = Preferences.birthday
    @AppStorage(Preferences.deathdayKey) var deathday = Preferences.deathday
    @AppStorage(Preferences.reverseTimeKey) var reverseTime = Preferences.reverseTime
    @State var clock: Clock = Clock.activeClock()

    var body: some View {
        ZStack {
            ProgressView(
                "💀", value: clock.getClockTime().percentage, total: 1.0 )
                .progressViewStyle(CircularProgressViewStyle())
        }
        .onAppear(perform: { print( clock.getClockTime().percentage) })
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
