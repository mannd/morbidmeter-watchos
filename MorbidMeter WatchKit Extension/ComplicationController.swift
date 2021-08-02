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
            CLKComplicationDescriptor(identifier: "morbidmeter_complication", displayName: "MorbidMeter", supportedFamilies: CLKComplicationFamily.allCases)
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
        // Reloading time line every 2 hours.  Update time line every hour.
//        return handler(Date().addingTimeInterval(60 * 60 * 2))
        // TODO: change to longer time interval, this is just to debug
        return handler(Date().addingTimeInterval(TimeConstants.oneHour))
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

        // Create an array to hold the timeline entries.
        var entries = [CLKComplicationTimelineEntry]()
        let updateTimeInterval = TimeConstants.fiveMinutes
        // Calculate the start and end dates.
        // Provide timeline updates every 5 minutes for an hour (and timeline is updated 4 times / hour).
        var current = date.addingTimeInterval(updateTimeInterval)
        let endDate = date.addingTimeInterval(TimeConstants.oneHour)
        while (current.compare(endDate) == .orderedAscending) && (entries.count < limit) {
            let template = getComplicationTemplate(for: complication, using: current)!
            let entry = CLKComplicationTimelineEntry(
                date: current,
                complicationTemplate: template)
            entries.append(entry)
            print(entry)
            current = current.addingTimeInterval(updateTimeInterval)
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
        switch complication.family {
        case .modularSmall:
            return createModularSmallTemplate(forDate: date)
        case .graphicCircular:
            return CLKComplicationTemplateGraphicCircularView(ComplicationViewCircular(date: date))
        case .graphicRectangular:
            return CLKComplicationTemplateGraphicRectangularFullView(ComplicationViewRectangular(date: date))
        default:
            return nil
        }
    }

    func createModularSmallTemplate(forDate date: Date) -> CLKComplicationTemplate {
        let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .percent
            formatter.roundingMode = .down
            return formatter
        }()
        let labelProvider = CLKSimpleTextProvider(text: Clock.shortName, shortText: Clock.skull)
        let percentProvider = CLKSimpleTextProvider(text: ClockData.shared.clock.getFormattedClockTime(formatter: formatter, date: date))
        return CLKComplicationTemplateModularSmallStackText(line1TextProvider: labelProvider, line2TextProvider: percentProvider)
    }
}
