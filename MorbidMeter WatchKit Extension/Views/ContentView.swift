//
//  ContentView.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/8/21.
//

import SwiftUI
import os

struct ContentView: View {

    let logger = Logger(subsystem: "org.epstudios.MorbidMeter.watchkitapp.watchkitextension.ContentView", category: "Content View")

    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        MorbidMeterView()
            .onChange(of: scenePhase) { (phase) in
                switch phase {

                case .inactive:
                    logger.debug("Scene became inactive.")

                case .active:
                    logger.debug("Scene became active.")

                case .background:
                    logger.debug("Scene moved to the background.")
                    // Schedule a background refresh task
                    // to update the complications.
                    scheduleBackgroundRefreshTasks()

                @unknown default:
                    logger.debug("Scene entered unknown state.")
                    assertionFailure()
                }
            }

   }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environmentObject(ClockData.shared)
            ContentView()
                .previewDevice("Apple Watch Series 3 - 38mm")
                .environmentObject(ClockData.shared)
            ContentView()
                .previewDevice("Apple Watch Series 6 - 40mm")
                .environmentObject(ClockData.shared)
            ContentView()
                .previewDevice("Apple Watch Series 6 - 44mm")
                .environmentObject(ClockData.shared)
        }
    }
}
