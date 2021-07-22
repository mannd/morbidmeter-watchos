//
//  ExtensionDelegate.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 7/22/21.
//

import WatchKit
import os

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    let logger = Logger(subsystem: "org.epstudios.MorbidMeter.watchkitapp.watchkitextension.ExtensionDelegate", category: "Extension Delegate")

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        logger.debug("Handling background task")
        logger.debug("App State: \(WKExtension.shared().applicationState.rawValue)")
        // right now there are no background task to handl

//        for task in backgroundTasks {
//            switch task {
//            case let backgroundTask as WKApplicationRefreshBackgroundTask:
//                let model = ClockData.shared
//
//            }
//        }
    }

}
