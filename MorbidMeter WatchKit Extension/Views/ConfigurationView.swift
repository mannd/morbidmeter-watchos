//
//  ConfigurationUI.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/24/21.
//

import SwiftUI

struct ConfigurationView: View {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    static let reverseTimeSymbol = "-R"
    static let forwardTimeSymbol = ""

    @EnvironmentObject var clockData: ClockData

    var body: some View {
        VStack {
            NavigationLink(destination: TimescaleConfigurationView(timescaleType: $clockData.clock.timescaleType, reverseTime: $clockData.clock.reverseTime), label: {
                            Text("\(clockData.clock.timescaleType.fullDescription(reverseTime: clockData.clock.reverseTime))") })
            NavigationLink(destination: DateConfigurationView(date: $clockData.clock.birthday), label: {
                            Text("Start \(Self.dateFormatter.string(from: clockData.clock.birthday))") })
            NavigationLink(destination: DateConfigurationView(date: $clockData.clock.deathday), label: {
                            Text("End \(Self.dateFormatter.string(from: clockData.clock.deathday))") })
        }
    }
}

struct ConfigurationUI_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationView()
            .environmentObject(ClockData.shared)
    }
}
