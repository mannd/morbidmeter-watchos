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
    @State var clockData = ClockData.shared
    @State var date: Date = Date()

    var body: some View {
        ZStack {
            ProgressView(
                "💀", value: clockData.clock.getClockTime(date: date).percentage, total: 1.0 )
                .progressViewStyle(CircularProgressViewStyle())
        }
        .onAppear(perform: { clockData.clock = Clock.activeClock()})
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
