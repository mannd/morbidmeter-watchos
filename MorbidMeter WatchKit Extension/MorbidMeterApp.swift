//
//  MorbidMeterApp.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/8/21.
//

import SwiftUI

@main
struct MorbidMeterApp: App {
    @WKExtensionDelegateAdaptor private var appDelegate: ExtensionDelegate
    @StateObject var clockData = ClockData.shared

    init() {
        UserDefaults.standard.register(defaults: Preferences.defaults())
    }
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .environmentObject(clockData)
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
