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
        for task in backgroundTasks {
            logger.debug("Task: \(task)")

            switch task {
            // Handle background refresh tasks.
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                scheduleBackgroundRefreshTasks()
                backgroundTask.setTaskCompletedWithSnapshot(true)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            case let relevantShortcutTask as WKRelevantShortcutRefreshBackgroundTask:
                relevantShortcutTask.setTaskCompletedWithSnapshot(false)
            case let intentDidRunTask as WKIntentDidRunRefreshBackgroundTask:
                intentDidRunTask.setTaskCompletedWithSnapshot(false)
            default:
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
}

func scheduleBackgroundRefreshTasks() {
    print("scheduleBackgroundRefreshTasks()")
    let watchExtension = WKExtension.shared()
    let targetDate = Date().addingTimeInterval(15.0 * 60.0)
    watchExtension.scheduleBackgroundRefresh(withPreferredDate: targetDate, userInfo: nil, scheduledCompletion: { error in
        if let error = error {
            print("error in scheduling background tasks: \(error.localizedDescription)")
            return
        }
        print("background refresh scheduled")
    })
}
