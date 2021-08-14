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
        // Sample templates will always show 0%.
        let date = ClockData.shared.clock.birthday
        let template = getComplicationTemplate(for: complication, using: date)
        handler(template)
    }

    // MARK: - Helper

    func getComplicationTemplate(for complication: CLKComplication, using date: Date) -> CLKComplicationTemplate? {
        switch complication.family {
        case .modularSmall:
            return createTemplateModularSmall(forDate: date)
        case .modularLarge:
            return createTemplateModularLarge(forDate: date)
        case .utilitarianSmall, .utilitarianSmallFlat:
            return createUtilitarianSmallFlatTemplate(forDate: date)
        case .utilitarianLarge:
            return createTemplateUtilitarianLargeFlat(forDate: date)
        case .circularSmall:
            return createCircularSmallTemplate(forDate: date)
        case .extraLarge:
            return createExtraLargeTemplate(forDate: date)
        case .graphicCorner:
            return CLKComplicationTemplateGraphicCornerCircularView(ComplicationViewCornerCircular(date: date))
        case .graphicBezel:
            return createGraphicBezelTemplate(forDate: date)
        case .graphicCircular:
            return CLKComplicationTemplateGraphicCircularView(ComplicationViewCircular(date: date))
        case .graphicRectangular:
            return CLKComplicationTemplateGraphicRectangularFullView(ComplicationViewRectangular(date: date))
        case .graphicExtraLarge:
            return CLKComplicationTemplateGraphicExtraLargeCircularView(ComplicationViewExtraLargeCircular(date: date))
        @unknown default:
            return nil
        }
    }

    private func createTemplateModularSmall(forDate date: Date) -> CLKComplicationTemplate {
        let labelProvider = CLKSimpleTextProvider(text: Clock.shortName, shortText: Clock.skull)
        let percentProvider = CLKSimpleTextProvider(text: ClockData.shared.clock.getShortFormattedPercentage(date: date))
        return CLKComplicationTemplateModularSmallStackText(line1TextProvider: labelProvider, line2TextProvider: percentProvider)
    }

    private func createTemplateModularLarge(forDate date: Date) -> CLKComplicationTemplate {
        let imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Modular")!)
        let headerProvider = CLKSimpleTextProvider(text: Clock.fullName, shortText: Clock.shortName)
        let body1Provider = CLKSimpleTextProvider(text: ClockData.shared.clock.getShortFormattedPercentage(date: date))
        let body2Provider = CLKSimpleTextProvider(text: "test")
        return CLKComplicationTemplateModularLargeStandardBody(headerImageProvider: imageProvider,
                                                               headerTextProvider: headerProvider,
                                                               body1TextProvider: body1Provider,
                                                               body2TextProvider: body2Provider)
    }

    private func createTemplateUtilitarianLargeFlat(forDate date: Date) -> CLKComplicationTemplate {
        let textProvider = CLKSimpleTextProvider(text: "\(Clock.fullName) \(ClockData.shared.clock.getShortFormattedPercentage(date: date))")
        let complication = CLKComplicationTemplateUtilitarianLargeFlat(textProvider: textProvider)
        return complication
    }

    private func createCircularSmallTemplate(forDate date: Date) -> CLKComplicationTemplate {
        let appNameProvider = CLKSimpleTextProvider(text: Clock.shortName, shortText: Clock.ultraShortName)
        let percentageProvider = CLKSimpleTextProvider(text: ClockData.shared.clock.getShortFormattedPercentage(date: date))
        return CLKComplicationTemplateCircularSmallStackText(line1TextProvider: appNameProvider, line2TextProvider: percentageProvider)
    }

    // Return a utilitarian small flat template.
    private func createUtilitarianSmallFlatTemplate(forDate date: Date) -> CLKComplicationTemplate {
        // Create the data providers.
        let flatUtilitarianImageProvider = CLKImageProvider(onePieceImage: #imageLiteral(resourceName: "skull_button_2"))
        let appNameProvider = CLKSimpleTextProvider(text: Clock.shortName, shortText: Clock.ultraShortName)
        let percentageProvider = CLKSimpleTextProvider(text: ClockData.shared.clock.getShortFormattedPercentage(date: date))
        let combinedMGProvider = CLKTextProvider(format: "%@ %@", appNameProvider, percentageProvider)

        // Create the template using the providers.
        return CLKComplicationTemplateUtilitarianSmallFlat(textProvider: combinedMGProvider,
                                                           imageProvider: flatUtilitarianImageProvider)
    }

    // Return an extra large template.
    private func createExtraLargeTemplate(forDate date: Date) -> CLKComplicationTemplate {
        // Create the data providers.
        let percentageProvider = CLKSimpleTextProvider(text: ClockData.shared.clock.getShortFormattedPercentage(date: date))
        let appNameProvider = CLKSimpleTextProvider(text: Clock.fullName, shortText: Clock.shortName)

        // Create the template using the providers.
        return CLKComplicationTemplateExtraLargeStackText(line1TextProvider: appNameProvider,
                                                          line2TextProvider: percentageProvider)
    }

    // Return a circular template with text that wraps around the top of the watch's bezel.
    private func createGraphicBezelTemplate(forDate date: Date) -> CLKComplicationTemplate {

        // Create a graphic circular template with an image provider.
        let circle = CLKComplicationTemplateGraphicCircularImage(imageProvider: CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Bezel")!))

        // Create the text provider.
        let mgCaffeineProvider = CLKSimpleTextProvider(text: ClockData.shared.clock.getShortTime(date: date))
        let mgUnitProvider = CLKSimpleTextProvider(text: Clock.fullName, shortText: Clock.shortName)
        let combinedMGProvider = CLKTextProvider(format: "%@ %@", mgUnitProvider, mgCaffeineProvider)


        let textProvider = CLKTextProvider(format: "%@",
                                           combinedMGProvider)

        // Create the bezel template using the circle template and the text provider.
        return CLKComplicationTemplateGraphicBezelCircularText(circularTemplate: circle,
                                                               textProvider: textProvider)
    }
}
