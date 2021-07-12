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

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        print("getComplicationDescriptors()")
        let descriptors = [
            CLKComplicationDescriptor(identifier: "complication", displayName: "MorbidMeter", supportedFamilies: [CLKComplicationFamily.graphicCircular])
            // Multiple complication support can be added here with more descriptors
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
        print("getTimelineEndDate()")
        handler(Date().addingTimeInterval(60 * 60))
//        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        print("getCurrentTimelineEntry()")
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
        print("getTimelineEntries()")
        var entries: [CLKComplicationTimelineEntry] = []
        let endDate = Date().addingTimeInterval(2 * 60 * 60)
        var current = date
        while (current.compare(endDate) == .orderedAscending) && (entries.count < limit) {
            let template = getComplicationTemplate(for: complication, using: date)!
            let entry = CLKComplicationTimelineEntry(
                date: current,
                complicationTemplate: template)
            entries.append(entry)
            current = current.addingTimeInterval(5 * 60)
        }
        handler(entries)
    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
//        print("getLocalizableSampleTemplate()")
//        if let template = getComplicationTemplate(for: complication, using: Date()) {
//            handler(template)
//        } else {
//            handler(nil)
//        }
    }

    // MARK: - Helper

    func getComplicationTemplate(for complication: CLKComplication, using date: Date) -> CLKComplicationTemplate? {
        switch complication.family {
        case .graphicCircular:
//            return CLKComplicationTemplateGraphicCircularImage(imageProvider: CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Circular")!))
            return CLKComplicationTemplateGraphicCircularView(ComplicationViewCircular())
        default:
            return nil
        }
    }
}
