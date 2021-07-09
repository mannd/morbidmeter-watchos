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

    var body: some View {
        ZStack {
            ProgressView(
                "M", value: 0.5, total: 1.0 )
                .progressViewStyle(CircularProgressViewStyle())
        }
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
