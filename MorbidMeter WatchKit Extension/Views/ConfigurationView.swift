//
//  ConfigurationUI.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/24/21.
//

import SwiftUI
import UserNotifications
import ClockCore
import os
import WidgetKit

struct ConfigurationView: View {
    let logger = Logger(subsystem: "org.epstudios.morbidmeter", category: "View")

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    static let reverseTimeSymbol = "-R"
    static let forwardTimeSymbol = ""

    @EnvironmentObject var clockData: ClockData

    var body: some View {
        ScrollView {
            VStack {
                NavigationLink(destination: TimescaleConfigurationView(timescaleType: $clockData.clock.timescaleType, reverseTime: $clockData.clock.reverseTime), label: {
                                Text("\(clockData.clock.timescaleType.fullDescription(reverseTime: clockData.clock.reverseTime))") })
                NavigationLink(destination: DateConfigurationView(endpoint: .birthday), label: {
                                Text("Start \(Self.dateFormatter.string(from: clockData.clock.birthday))") })
                NavigationLink(destination: DateConfigurationView(endpoint: .deathday), label: {
                                Text("End \(Self.dateFormatter.string(from: clockData.clock.deathday))") })
                NavigationLink(
                    destination: SecretsView(),
                    label: {
                        Text("Secrets")
                    })
            }
        }
        .onAppear {
            logger.debug("Configuration appeared")
        }
    }
}

struct ConfigurationUI_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationView()
            .environmentObject(ClockData.shared)
    }
}
