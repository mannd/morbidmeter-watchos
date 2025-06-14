//
//  ContentView.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/8/21.
//

import SwiftUI
import UserNotifications
import os
import ClockCore

struct ContentView: View {

    let logger = Logger(subsystem: "org.epstudios.morbidmeter", category: "View")

    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        MorbidMeterView()
            .onChange(of: scenePhase) { (phase, _) in
                switch phase {
                case .inactive:
                    logger.info("Scene became inactive.")

                case .active:
                    logger.info("Scene became active.")

                case .background:
                    logger.info("Scene moved to the background.")
                    // Schedule a background refresh task
                    // to update the complications.
                    scheduleBackgroundRefreshTasks()

                @unknown default:
                    logger.info("Scene entered unknown state.")
                    assertionFailure()
                }
        }
    }
}

struct AllowNotificationsView: View {
    var body: some View {
        Button("Notifications") {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    print("Notifications set up successfully.")
                } else if let error = error {
                    print(error.localizedDescription)
                }
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
