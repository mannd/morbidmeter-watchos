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

    @State var timescaleTypeInt = 0
    @State var birthday = Date()
    @State var deathday = Date()
    @State var reverseTime = false


    var body: some View {
        VStack {
            NavigationLink(destination: TimescaleConfigurationView(timescaleTypeInt: $timescaleTypeInt, reverseTime: $reverseTime), label: { Text("\(TimescaleType(rawValue: timescaleTypeInt)!.fullDescription(reverseTime: reverseTime))") })
            NavigationLink(destination: DateConfigurationView(date: $birthday), label: {
                Text("Start \(Self.dateFormatter.string(from: birthday))") })
            NavigationLink(destination: DateConfigurationView(date: $deathday), label: {
                Text("End \(Self.dateFormatter.string(from: deathday))") })
        }
        .onAppear(perform: {
            self.timescaleTypeInt = self.clockData.clock.timescaleTypeInt
            self.birthday = self.clockData.clock.birthday
            self.deathday = self.clockData.clock.deathday
            self.reverseTime = self.clockData.clock.reverseTime
        })
        .onDisappear(perform: {
            self.clockData.clock.timescaleTypeInt = self.timescaleTypeInt
            self.clockData.clock.birthday = self.birthday
            self.clockData.clock.deathday = self.deathday
            self.clockData.clock.reverseTime = self.reverseTime
        })
    }
}

struct ConfigurationUI_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationView()
            .environmentObject(ClockData.shared)
    }
}
