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

    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.roundingMode = .down
        return formatter
    }()

    var body: some View {
        ZStack {
            ProgressView(value: clockData.getClockTime(date: date).percentage, total: 1.0 ) {
                Text(clockData.clock.getFormattedClockTime(formatter: formatter, date: date))
                    .complicationForeground()
            }
            .progressViewStyle(CircularProgressViewStyle())
        }
    }
}

struct ComplicationViewRectangular: View {
    @State var clockData = ClockData.shared
    @State var date: Date = Date()

    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.roundingMode = .down
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading) {
            Text(Clock.fullName)                .font(Font.custom("BlackChancery", size: 22))
            Text("\(clockData.clock.getFormattedClockTime(formatter: formatter, date: date))")
                .complicationForeground()
            ProgressView(value: clockData.getClockTime(date: date).percentage, total: 1.0 )
                .progressViewStyle(LinearProgressViewStyle(tint: .accentColor))
        }
    }
}

struct ComplicationViews_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            CLKComplicationTemplateGraphicCircularView(
                ComplicationViewCircular(clockData: ClockData.test)
            ).previewContext()
            CLKComplicationTemplateGraphicCircularView(
                ComplicationViewCircular(clockData: ClockData.test)
            ).previewContext(faceColor: .blue)
            CLKComplicationTemplateGraphicRectangularFullView(
                ComplicationViewRectangular(clockData: ClockData.test)
            ).previewContext(faceColor: .green)
        }
    }
}
