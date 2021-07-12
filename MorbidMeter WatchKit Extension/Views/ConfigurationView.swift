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

    @AppStorage(Preferences.timescaleTypeKey) var timescaleTypeInt = Preferences.timescaleTypeInt
    @AppStorage(Preferences.birthdayKey) var birthday = Preferences.birthday
    @AppStorage(Preferences.deathdayKey) var deathday = Preferences.deathday
    @AppStorage(Preferences.reverseTimeKey) var reverseTime = Preferences.reverseTime

    var body: some View {
        VStack {
            NavigationLink(destination: TimescaleConfigurationView(), label: { Text("\(TimescaleType(rawValue: timescaleTypeInt)!.fullDescription(reverseTime: reverseTime))") })
            NavigationLink(destination: DateConfigurationView(date: $birthday), label: {
                Text("Start \(Self.dateFormatter.string(from: birthday))") })
            NavigationLink(destination: DateConfigurationView(date: $deathday), label: {
                Text("End \(Self.dateFormatter.string(from: deathday))") })
        }
    }
}

struct ConfigurationUI_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationView()
    }
}
