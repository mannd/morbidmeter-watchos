//
//  ComplicationController.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/8/21.
//

import ClockKit
import SwiftUI


class ComplicationController: NSObject, CLKComplicationDataSource {
    // MARK: - Complication Configuration
    let clock = Clock.activeClock()
//    @AppStorage(Preferences.timescaleTypeKey) var timescaleTypeInt = Preferences.timescaleTypeInt
//    @AppStorage(Preferences.birthdayKey) var birthday = Preferences.birthday
//    @AppStorage(Preferences.deathdayKey) var deathday = Preferences.deathday
//    @AppStorage(Preferences.reverseTimeKey) var reverseTime = Preferences.reverseTime

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        print("getComplicationDescriptors()")
        let descriptors = [
            CLKComplicationDescriptor(identifier: "complication", displayName: "MorbidMeter", supportedFamilies: [CLKComplicationFamily.graphicCircular])
        ]
        
        // Call the handler with the currently supported complication descriptors
        handler(descriptors)
    }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }

    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        return handler(nil)
        return handler(clock.deathday)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        print("getCurrentTimelineEntry()")
        handler(nil)
        let date = Date()
        if let template = getComplicationTemplate(for: complication, using: date) {
            let entry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
            handler(entry)
        } else {
            handler(nil)
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date
        handler(nil)
        var entries: [CLKComplicationTimelineEntry] = []
        var current = date
        let endDate = clock.deathday.addingTimeInterval(60 * 60)
        while (current.compare(endDate) == .orderedAscending) && (entries.count < limit) {
            let template = getComplicationTemplate(for: complication, using: date)!
            let entry = CLKComplicationTimelineEntry(
                date: current,
                complicationTemplate: template)
            entries.append(entry)
            current = current.addingTimeInterval(60 * 60)
        }
        handler(entries)
    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }

    // MARK: - Helper

    func getComplicationTemplate(for complication: CLKComplication, using date: Date) -> CLKComplicationTemplate? {
        return nil
        switch complication.family {
        case .graphicCircular:
            return CLKComplicationTemplateGraphicCircularView(ComplicationViewCircular())
        default:
            return nil
        }
    }
}
