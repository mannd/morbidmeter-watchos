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
            ProgressView(value: clockData.getClockTime(date: date).percentage, total: 1.0 ) {
                Text(clockData.clock.getShortFormattedPercentage(date: date))
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
                Text("MM\n" + clockData.clock.getShortTime(date: date))
                    .complicationForeground()
                    .font(.headline)
                    .minimumScaleFactor(0.4)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                ProgressView(value: clockData.getClockTime(date: date).percentage, total: 1.0 )
                    .progressViewStyle(CircularProgressViewStyle())
                    .complicationForeground()
            }
        }
    }
}

struct ComplicationViewCornerCircular: View {
    @State var clockData = ClockData.shared
    @State var date: Date = Date()

    @Environment(\.complicationRenderingMode) var renderingMode

    var body: some View {
        ZStack {
            switch renderingMode {
            case .fullColor:
              Circle()
                .fill(Color.white)
            case .tinted:
              Circle()
                .fill(
                  RadialGradient(
                    gradient: Gradient(colors: [.clear, .white]),
                    center: .center,
                    startRadius: 10,
                    endRadius: 15))
            @unknown default:
              Circle()
                .fill(Color.white)
            }
            // TODO: tinted view can't see text
            Text(clockData.clock.getShortFormattedPercentage(date: date))
                .foregroundColor(.black)
                .complicationForeground()
            Circle()
                .stroke(Color.yellow, lineWidth: 5.0)
                .complicationForeground()
        }
    }
}

struct ComplicationViewRectangular: View {
    @State var clockData = ClockData.shared
    @State var date: Date = Date()

    var body: some View {
        VStack(alignment: .leading) {
            Text(Clock.fullName)
            Text("\(clockData.clock.getShortTime(date: date))")
                // fixedSize allows multiline text without truncation
                .fixedSize(horizontal: false, vertical: true)
                .complicationForeground()
            ProgressView(value: clockData.getClockTime(date: date).percentage, total: 1.0 )
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
            CLKComplicationTemplateGraphicCornerCircularView(ComplicationViewCornerCircular(clockData: ClockData.test)
            ).previewContext()
            CLKComplicationTemplateGraphicCornerCircularView(ComplicationViewCornerCircular(clockData: ClockData.test)
            ).previewContext(faceColor: .orange)
            CLKComplicationTemplateGraphicExtraLargeCircularView(ComplicationViewExtraLargeCircular(clockData: ClockData.test)
            ).previewContext()
            CLKComplicationTemplateGraphicExtraLargeCircularView(ComplicationViewExtraLargeCircular(clockData: ClockData.test)
            ).previewContext(faceColor: .red)
        }
    }
}
//
