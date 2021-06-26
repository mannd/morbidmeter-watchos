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

    @AppStorage(Preferences.timescaleTypeKey) var timescaleTypeInt = Preferences.timescaleType
    @AppStorage(Preferences.birthdayKey) var birthday = Preferences.birthday
    @AppStorage(Preferences.deathdayKey) var deathday = Preferences.deathday
    @AppStorage(Preferences.reverseTimeKey) var reverseTime = Preferences.reverseTime

    var body: some View {
        VStack {
            Text("Configure")
                .font(Font.custom("BlackChancery", size: 12))
            NavigationLink(destination: TimescaleConfigurationView(), label: { Text("TS \(TimescaleType(rawValue: timescaleTypeInt)!.fullDescription(reverseTime: reverseTime))") })
            NavigationLink(destination: DateConfigurationView(date: $birthday), label: {
                Text("BD \(Self.dateFormatter.string(from: birthday))") })
            NavigationLink(destination: DateConfigurationView(date: $deathday), label: {
                Text("DD \(Self.dateFormatter.string(from: deathday))") })
        }
        .padding()
    }
}

struct ConfigurationUI_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationView()
    }
}
