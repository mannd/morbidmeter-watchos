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
        formatter.maximumIntegerDigits = 2
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    var body: some View {
        ZStack {
            ProgressView(
                clockData.clock.getClockTime(date: date).percentage < 1.0 ?
                    formatter.string(for: clockData.clock.getClockTime(date: date).percentage)! :
                "💀",
                value: clockData.getClockTime(date: date).percentage, total: 1.0 )
                .progressViewStyle(CircularProgressViewStyle())
        }
    }
}

struct ComplicationViews_Previews: PreviewProvider {
    static var previews: some View {
        CLKComplicationTemplateGraphicCircularView(
            ComplicationViewCircular()
        ).previewContext()
    }
}
