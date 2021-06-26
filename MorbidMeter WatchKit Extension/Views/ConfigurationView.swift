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

    @AppStorage(Preferences.timescaleTypeKey) var timescaleTypeInt = Preferences.timescaleType
    @AppStorage(Preferences.birthdayKey) var birthday = Preferences.birthday
    @AppStorage(Preferences.deathdayKey) var deathday = Preferences.deathday
    var body: some View {
        VStack {
            Text("Configure")
                .font(Font.custom("BlackChancery", size: 12))
            NavigationLink(destination: TimescaleConfigurationView(), label: { Text("TS \(TimescaleType(rawValue: timescaleTypeInt)!.description)") })
            NavigationLink(destination: DateConfigurationView(date: $birthday), label: {
                Text("BD \(Self.dateFormatter.string(from: birthday))") })
            NavigationLink(destination: DateConfigurationView(date: $deathday), label: {
                Text("DD \(Self.dateFormatter.string(from: deathday))") })
        }
        .padding()
    }
}

//            Picker(selection: $timescaleType, label: Text("Timescale"), content: {
         //                Text("Seconds").tag(TimescaleType.seconds.rawValue)
         //                Text("Minutes").tag(TimescaleType.minutes.rawValue)
         //            }).pickerStyle(.radioGroup)
         // Arg, no date picker in Swift UI
         //            TimePicker()


//struct TimePicker: View {
//   // Start timer at mid-day
//    @State private var seconds: TimeInterval = 60 * 60 * 12
//
//    static let formatter: DateComponentsFormatter = {
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = [.hour, .minute]
//        return formatter
//    }()
//
//    var body: some View {
//        Text(Self.formatter.string(from: seconds)!)
//            .font(.title)
//            .digitalCrownRotation(
//                $seconds, from: 0, through: 60 * 60 * 24 - 1, by: 60)
//    }
//}

struct ConfigurationUI_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationView()
    }
}
