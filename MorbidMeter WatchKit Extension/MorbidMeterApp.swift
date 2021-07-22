//
//  MorbidMeterApp.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/8/21.
//

import SwiftUI

@main
struct MorbidMeterApp: App {
    @Environment(\.scenePhase) private var scenePhase

    // TODO: Need to define app delegate here?  see sample app
    
    init() {
        UserDefaults.standard.register(defaults: Preferences.defaults())
    }
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .onChange(of: scenePhase) { phase in
                           switch phase {
                           case .active:
                               // The app has become active.
                               print("app active")
                               break
                           case .inactive:
                               // The app has become inactive.
                               print("app inactive")
                               break
                           case .background:
                               // The app has moved to the background.
                               print("app background")
                               break
                           @unknown default:
                               fatalError("The app has entered an unknown state.")
                           }
                       }
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
