//
//  ComplicationController.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/8/21.
//

import ClockKit
import SwiftUI
import ClockCore

class ComplicationController: NSObject, CLKComplicationDataSource, CLKComplicationWidgetMigrator {
    // MARK: - Complication Configuration
    lazy var data = ClockData.shared

    // Necessary to migrate to new WidgetKit complications.
    // See https://developer.apple.com/documentation/ClockKit/CLKComplicationWidgetMigrator/getWidgetConfiguration(from:completionHandler:) and https://developer.apple.com/documentation/widgetkit/converting-a-clockkit-app
    var widgetMigrator: any CLKComplicationWidgetMigrator { self }

    func getWidgetConfiguration(from complicationDescriptor: CLKComplicationDescriptor, completionHandler: @escaping (CLKComplicationWidgetMigrationConfiguration?) -> Void) {
        var configuration: CLKComplicationWidgetMigrationConfiguration? = nil
        switch complicationDescriptor.identifier {
        case "morbidmeter_complication":
             configuration = CLKComplicationStaticWidgetMigrationConfiguration(
                kind: "com.epstudiossoftware.MorbidMeterComplications",
                extensionBundleIdentifier: "org.epstudios.MorbidMeter.watchkitapp"
             )
        default:
            configuration = nil
        }
        completionHandler(configuration)
    }

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
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
//        let nextDate = Date().addingTimeInterval(TimeConstants.fifteenMinutes)
        let endDate = min(data.clock.deathday, Date().addingTimeInterval(TimeConstants.oneHour))
        return handler(endDate)
//        return handler(nextDate)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
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
        let landmarkDates = data.clock.getClockLandmarkDates(minimalTimeInterval: TimeConstants.fiveMinutes, after: date, timeInterval: TimeConstants.oneHour)
        for landmarkDate in landmarkDates {
            if let template = getComplicationTemplate(for: complication, using: landmarkDate) {
                let entry = CLKComplicationTimelineEntry(date: landmarkDate, complicationTemplate: template)
                if entries.count < limit {
                    entries.append(entry)
                }
            }
        }
        handler(entries)
    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        // Sample templates will always show 0%.
        let date = data.clock.reverseTime ? data.clock.deathday : data.clock.birthday
        let template = getComplicationTemplate(for: complication, using: date)
        handler(template)
    }

    // MARK: - Helper

    func getComplicationTemplate(for complication: CLKComplication, using date: Date) -> CLKComplicationTemplate? {
        switch complication.family {
        case .modularSmall:
            return createTemplateModularSmall(date: date)
        case .modularLarge:
            return createTemplateModularLarge(date: date)
        case .utilitarianSmall, .utilitarianSmallFlat:
            return createUtilitarianSmallFlatTemplate(date: date)
        case .utilitarianLarge:
            return createTemplateUtilitarianLargeFlat(date: date)
        case .circularSmall:
            return createCircularSmallTemplate(date: date)
        case .extraLarge:
            return createExtraLargeTemplate(date: date)
        case .graphicCorner:
            return createTemplateGraphicCorner(date: date)
        case .graphicBezel:
            return createGraphicBezelTemplate(date: date)
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

    private func createTemplateModularSmall(date: Date) -> CLKComplicationTemplate {
        let labelProvider = CLKSimpleTextProvider(text: Clock.shortName, shortText: Clock.skull)
        let percentProvider = CLKSimpleTextProvider(text: data.clock.getShortFormattedMomentPercentage(date: date))
        return CLKComplicationTemplateModularSmallStackText(line1TextProvider: labelProvider, line2TextProvider: percentProvider)
    }

    private func createTemplateModularLarge(date: Date) -> CLKComplicationTemplate {
        let imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Modular")!)
        let headerProvider = CLKSimpleTextProvider(text: Clock.fullName, shortText: Clock.shortName)
        let body1Provider = CLKSimpleTextProvider(text: "Last landmark: \(data.clock.getShortFormattedMomentPercentage(date: date))")
        let body2Provider = CLKSimpleTextProvider(text: data.clock.getUnwrappedMomentTime(date: date), shortText: data.clock.getMomentTimeShortUnits(date: date))
        return CLKComplicationTemplateModularLargeStandardBody(headerImageProvider: imageProvider,
                                                               headerTextProvider: headerProvider,
                                                               body1TextProvider: body1Provider,
                                                               body2TextProvider: body2Provider)
    }

    private func createTemplateUtilitarianLargeFlat(date: Date) -> CLKComplicationTemplate {
        let textProvider = CLKSimpleTextProvider(text: "\(Clock.fullName) \(data.clock.getShortFormattedMomentPercentage(date: date))")
        let complication = CLKComplicationTemplateUtilitarianLargeFlat(textProvider: textProvider)
        return complication
    }

    private func createTemplateGraphicCorner(date: Date) -> CLKComplicationTemplate {
        let percentage = data.clock.getMoment().percentage
        let gaugeColorLocations = data.clock.reverseTime ? [0.1, 0.3, 1.0] : [0.0, 0.7, 0.9] as [NSNumber]
        let gaugeColors: [UIColor] = data.clock.reverseTime ? [.red, .yellow, .green] : [.green, .yellow, .red]
        let gaugeProvider = CLKSimpleGaugeProvider(style: .fill,
                                                   gaugeColors: gaugeColors,
                                                   gaugeColorLocations: gaugeColorLocations,
                                                   fillFraction: Float(percentage))
        let outerTextProvider = percentage < 1.0 ? CLKSimpleTextProvider(text: Clock.fullName, shortText: Clock.shortName) : CLKSimpleTextProvider(text: Clock.skull)
        return CLKComplicationTemplateGraphicCornerGaugeText(gaugeProvider: gaugeProvider, leadingTextProvider: nil, trailingTextProvider: nil, outerTextProvider: outerTextProvider)
    }

    private func createCircularSmallTemplate(date: Date) -> CLKComplicationTemplate {
        let appNameProvider = CLKSimpleTextProvider(text: Clock.shortName, shortText: Clock.ultraShortName)
        let percentageProvider = CLKSimpleTextProvider(text: data.clock.getShortFormattedMomentPercentage(date: date))
        return CLKComplicationTemplateCircularSmallStackText(line1TextProvider: appNameProvider, line2TextProvider: percentageProvider)
    }

    // Return a utilitarian small flat template.
    private func createUtilitarianSmallFlatTemplate(date: Date) -> CLKComplicationTemplate {
        // Create the data providers.
        let appNameProvider = CLKSimpleTextProvider(text: Clock.shortName, shortText: Clock.ultraShortName)
        let percentageProvider = CLKSimpleTextProvider(text: data.clock.getShortFormattedMomentPercentage(date: date))
        let textProvider = CLKTextProvider(format: "%@ %@", appNameProvider, percentageProvider)

        // Create the template using the providers.
        return CLKComplicationTemplateUtilitarianSmallFlat(textProvider: textProvider)
    }

    // Return an extra large template.
    private func createExtraLargeTemplate(date: Date) -> CLKComplicationTemplate {
        // Create the data providers.
        let appNameProvider = CLKSimpleTextProvider(text: Clock.fullName, shortText: Clock.shortName)
        let percentageProvider = CLKSimpleTextProvider(text: data.clock.getShortFormattedMomentPercentage(date: date))

        // Create the template using the providers.
        return CLKComplicationTemplateExtraLargeStackText(line1TextProvider: appNameProvider,
                                                          line2TextProvider: percentageProvider)
    }

    // Return a circular template with text that wraps around the top of the watch's bezel.
    private func createGraphicBezelTemplate(date: Date) -> CLKComplicationTemplate {

        // Create a graphic circular template with an image provider.
        let circle = CLKComplicationTemplateGraphicCircularImage(imageProvider: CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Bezel")!))

        // Create the text provider.
        let timeProvider = CLKSimpleTextProvider(text: ClockData.shared.clock.getUnwrappedMomentTime(date: date))
        let nameProvider = CLKSimpleTextProvider(text: Clock.fullName, shortText: Clock.shortName)
        let textProvider = CLKTextProvider(format: "%@ %@", nameProvider, timeProvider)

        // Create the bezel template using the circle template and the text provider.
        return CLKComplicationTemplateGraphicBezelCircularText(circularTemplate: circle,
                                                               textProvider: textProvider)
    }
}
