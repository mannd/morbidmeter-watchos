//
//  ComplicationViews.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 7/8/21.
//

import SwiftUI
import ClockKit
import ClockCore

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
            ProgressView(value: clockData.getMoment(date: date).percentage, total: 1.0 ) {
                Text(clockData.clock.getShortFormattedMomentPercentage(date: date))
                    .complicationForeground()
            }
            .progressViewStyle(CircularProgressViewStyle())
        }
    }
}

struct ComplicationViewExtraLargeCircular: View {
    @State var clockData = ClockData.shared
    @State var date: Date = Date()

    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .foregroundColor(.blue)
            VStack {
                Text(Clock.shortName + "\n" + clockData.clock.getUnwrappedMomentTime(date: date))
                    .complicationForeground()
                    .font(.headline)
                    .minimumScaleFactor(0.4)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                ZStack {
                    ProgressView(value: clockData.getMoment(date: date).percentage, total: 1.0 )
                        .progressViewStyle(CircularProgressViewStyle())
                        .complicationForeground()
                    Text(clockData.clock.getShortFormattedMomentPercentage(date: date))
                        .font(Font.caption)
                        .complicationForeground()
                }
            }
        }
    }
}

struct ComplicationViewRectangular: View {
    @State var clockData = ClockData.shared
    @State var date: Date = Date()

    var body: some View {
        VStack(alignment: .leading) {
            Text(Clock.fullName)
            Text("\(clockData.clock.getUnwrappedMomentTime(date: date))")
                // fixedSize allows multiline text without truncation
                .fixedSize(horizontal: false, vertical: true)
                .complicationForeground()
            ProgressView(value: clockData.getMoment(date: date).percentage, total: 1.0 )
                .progressViewStyle(LinearProgressViewStyle())
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
            ).previewContext()
            CLKComplicationTemplateGraphicRectangularFullView(
                ComplicationViewRectangular(clockData: ClockData.test)
            ).previewContext(faceColor: .blue)
            CLKComplicationTemplateGraphicExtraLargeCircularView(ComplicationViewExtraLargeCircular(clockData: ClockData.test)
            ).previewContext()
            CLKComplicationTemplateGraphicExtraLargeCircularView(ComplicationViewExtraLargeCircular(clockData: ClockData.test)
            ).previewContext(faceColor: .red)
        }
    }
}
//
