//
//  MorbidMeterComplications.swift
//  MorbidMeterComplications
//
//  Created by David Mann on 5/20/25.
//

import WidgetKit
import SwiftUI
import ClockCore
import os

struct MorbidMeterTimeLineEntry: TimelineEntry {
    var date: Date
    let percentageText: String
    let percentage: Double  // between 0 and 1.0
}

struct MorbidMeterProvider: TimelineProvider {
    //lazy var data = ClockData.shared
    let logger = Logger(subsystem: "org.epstudios.morbidmeter", category: "Complication")

    func placeholder(in context: Context) -> MorbidMeterTimeLineEntry {
        MorbidMeterTimeLineEntry(date: Date(),
                                 percentageText: "50%",
                                 percentage: 0.5)
    }

    func getSnapshot(in context: Context, completion: @escaping (MorbidMeterTimeLineEntry) -> ()) {
        logger.info("getSnapshot called at \(Date(), privacy: .public)")
        if context.isPreview {
            let entry = MorbidMeterTimeLineEntry(date: Date(),
                                                 percentageText: "50%",
                                                 percentage: 0.5)
            completion(entry)
            return
        }
        let date = Date()
        let entry = MorbidMeterTimeLineEntry(date: date, percentageText: ClockData.shared.clock.getShortFormattedMomentPercentage(date: date), percentage: ClockData.shared.clock.getMoment(date: date).percentage)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        logger.info("getTimeline called at \(Date(), privacy: .public)")

        // Complications need to load data rapidly.
        ClockData.shared.loadSynchronously()

        let now = Date()
        let endDate = ClockData.shared.clock.deathday
        var entries: [MorbidMeterTimeLineEntry] = []

        // Deal with finished clock.
        if now > endDate {
            let entry = MorbidMeterTimeLineEntry(date: now, percentageText: Clock.skull, percentage: 1.0)
            entries.append(entry)
            let timeline = Timeline(entries: entries, policy: .never)
            completion(timeline)
            return
        }

        var current = now
        let calendar = Calendar.current

        while current < endDate && entries.count < 100 {
            let entry = MorbidMeterTimeLineEntry(date: current, percentageText: ClockData.shared.clock.getShortFormattedMomentPercentage(date: current, fractionDigits: 0), percentage: ClockData.shared.clock.getMoment(date: current).percentage)
            entries.append(entry)
            current = calendar.date (byAdding: .hour, value: 1, to: current)!
        }

        let policy: TimelineReloadPolicy
        if let lastDate = entries.last?.date, lastDate < endDate {
            policy = .after(lastDate)
        } else {
            policy = .never
        }
        let timeline = Timeline(entries: entries, policy: policy)
        completion(timeline)
    }
}

struct MorbidMeterRectangularView : View {
    let entry: MorbidMeterProvider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            Text(Clock.fullName)
                .font(.caption2)
                .foregroundColor(.secondary)
            Text("Elapsed: " + entry.percentageText)
                .font(.headline)
            ProgressView(value: entry.percentage, total: 1.0 )
                .tint(entry.percentage > 0.9 ? .red : .green)
        }
    }
}

struct MorbidMeterAccessoryInlineView : View {
    let entry: MorbidMeterProvider.Entry

    var body: some View {
        Text(Clock.fullName + " " + entry.percentageText)
    }
}

struct MorbidMeterAccessoryCornerView : View {
    let entry: MorbidMeterProvider.Entry

    var body: some View {
            Gauge(value: entry.percentage) {
                Text(Clock.ultraShortName) // Label text
            } currentValueLabel: {
                Text(entry.percentageText) // e.g., "73%"
            }
            .gaugeStyle(.accessoryCircular)
        }
}

struct MorbidMeterAccessoryCircularView: View {
    let entry: MorbidMeterProvider.Entry

    var body: some View {
        Gauge(value: entry.percentage) {
            // Label is not shown in circular style, so you can use EmptyView
            EmptyView()
        } currentValueLabel: {
            Text(entry.percentageText)
                .font(.caption2)
        }
        .gaugeStyle(.accessoryCircular)
    }
}


//struct MorbidMeterAccessoryCircularView : View {
//    let entry: MorbidMeterProvider.Entry
//
//    var body: some View {
//        ZStack {
//            ProgressView(value: entry.percentage, total: 1.0 ) {
//                Text(entry.percentageText)
//            }
//            .progressViewStyle(CircularProgressViewStyle())
//        }
//    }
//}


struct MorbidMeterComplicationsEntryView : View {
    @Environment(\.widgetFamily) private var family
    var entry: MorbidMeterProvider.Entry

    var body: some View {
        switch family {
        case .accessoryRectangular:
            MorbidMeterRectangularView(entry: entry)
        case .accessoryCircular:
            MorbidMeterAccessoryCircularView(entry: entry)
        case .accessoryInline:
            MorbidMeterAccessoryInlineView(entry: entry)
        case .accessoryCorner:
            MorbidMeterAccessoryCornerView(entry: entry)
        default:
            Text(Clock.skull)
        }
    }
}

@main
struct MorbidMeterComplications: WidgetBundle {
    var body: some Widget {
        MorbidMeterComplicationWidget()
    }
}

struct MorbidMeterComplicationWidget: Widget {
    let widgetEnvironment = WidgetEnvironment()

    init() {
        ClockData.shared.environmentDelegate = widgetEnvironment
    }
    
    let kind: String = "com.epstudiossoftware.MorbidMeterComplications"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MorbidMeterProvider()) { entry in
            if #available(watchOS 10.0, *) {
                MorbidMeterComplicationsEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                MorbidMeterComplicationsEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("MorbidMeter")
        .description("This shows the current MorbidMeter time.")
        .supportedFamilies( [.accessoryRectangular, .accessoryCircular, .accessoryInline, .accessoryCorner] )
    }
}

class WidgetEnvironment: ClockEnvironmentDelegate {
    // Always save synchronously for WidgetKit, which runs briefly and then terminates.
    func shouldSaveSynchronously() -> Bool {
        return true
    }
}

#Preview(as: .accessoryCorner) {
    MorbidMeterComplicationWidget()
} timeline: {
    MorbidMeterTimeLineEntry(date: .now, percentageText: "73%", percentage: 0.73)
}

#Preview(as: .accessoryCircular) {
    MorbidMeterComplicationWidget()
} timeline: {
    MorbidMeterTimeLineEntry(date: .now, percentageText: "73%", percentage: 0.73)
}

#Preview(as: .accessoryRectangular) {
    MorbidMeterComplicationWidget()
} timeline: {
    MorbidMeterTimeLineEntry(date: .now, percentageText: "73%", percentage: 0.73)
}

#Preview(as: .accessoryRectangular) {
    MorbidMeterComplicationWidget()
} timeline: {
    MorbidMeterTimeLineEntry(date: .now, percentageText: "93%", percentage: 0.93)
}

#Preview(as: .accessoryInline) {
    MorbidMeterComplicationWidget()
} timeline: {
    MorbidMeterTimeLineEntry(date: .now, percentageText: "73%", percentage: 0.73)
}
