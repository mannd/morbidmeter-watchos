//
//  MorbidMeterApp.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/8/21.
//

import SwiftUI
import ClockCore

@main
struct MorbidMeterApp: App {
    @WKApplicationDelegateAdaptor private var appDelegate: ExtensionDelegate
    @StateObject var clockData = ClockData.shared
    private let watchEnvironment = WatchEnvironment() // ← strong reference


    init() {
        UserDefaults.standard.register(defaults: Preferences.defaults())
    }
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .onAppear {
                        clockData.environmentDelegate = watchEnvironment
                    }
            }
            .environmentObject(clockData)
        }

        WKNotificationScene(controller: NotificationController.self, category: "MMNotification")
    }
}

class WatchEnvironment: ClockEnvironmentDelegate {
    func shouldSaveSynchronously() -> Bool {
        return WKApplication.shared().applicationState == .background
    }
}

