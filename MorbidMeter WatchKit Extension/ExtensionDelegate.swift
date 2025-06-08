//
//  ExtensionDelegate.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 7/22/21.
//

import WatchKit
import ClockKit
import os
import ClockCore

class ExtensionDelegate: NSObject, WKApplicationDelegate {
    let logger = Logger(subsystem: "org.epstudios.morbidmeter", category: "Extension Delegate")

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        logger.info("Handling background task")
        logger.info("App State: \(WKApplication.shared().applicationState.rawValue)")
        for task in backgroundTasks {
            logger.info("Task: \(task)")
            switch task {
            // Handle background refresh tasks.
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Don't bother refreshing if we are done.
                if ClockData.shared.clock.getMoment().percentage < 1.0 {
                    extendComplications()
                    scheduleBackgroundRefreshTasks()
                }
                backgroundTask.setTaskCompletedWithSnapshot(false)
                logger.info("MorbidMeter app background refresh scheduled")
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
    let updateFrequency = TimeConstants.fifteenMinutes
    let watchExtension = WKApplication.shared()
    let targetDate = Date().addingTimeInterval(updateFrequency)
    watchExtension.scheduleBackgroundRefresh(withPreferredDate: targetDate, userInfo: nil, scheduledCompletion: { error in
        if let error = error {
            print("error in scheduling background tasks: \(error.localizedDescription)")
            return
        }
    })
}

func reloadComplications() {
    let server = CLKComplicationServer.sharedInstance()
    for complication in server.activeComplications ?? [] {
        server.reloadTimeline(for: complication)
    }
}

func extendComplications() {
    let server = CLKComplicationServer.sharedInstance()
    for complication in server.activeComplications ?? [] {
        server.extendTimeline(for: complication)
    }
}
