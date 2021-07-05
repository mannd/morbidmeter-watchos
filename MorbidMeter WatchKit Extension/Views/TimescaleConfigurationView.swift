//
//  TimescaleConfigurationView.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/24/21.
//

import SwiftUI

struct TimescaleConfigurationView: View {
    @AppStorage(Preferences.timescaleTypeKey) var timescaleTypeInt = Preferences.timescaleType
    @AppStorage(Preferences.reverseTimeKey) var reverseTime = Preferences.reverseTime

    @State private var timescaleType: TimescaleType = TimescaleType.year

    var body: some View {
        VStack {
            Picker(selection: $timescaleType, label: Text("Timescale"), content: {
                ForEach(TimescaleType.allCases) { timescaleType in
                    Text(timescaleType.description)

                }
            })
            Toggle(isOn: $reverseTime, label: { Text("Reverse Time") })
        }
        .onAppear(perform: { convertIntToTimescaleType() })
        .onDisappear(perform: { convertTimescaleTypeToInt() })
    }

    func convertIntToTimescaleType() {
        timescaleType = TimescaleType(rawValue: timescaleTypeInt) ?? TimescaleType.year

    }

    func convertTimescaleTypeToInt() {
        timescaleTypeInt = timescaleType.rawValue
    }
    
}

struct TimescaleConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        TimescaleConfigurationView()
    }
}
