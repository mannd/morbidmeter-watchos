//
//  TimescaleConfigurationView.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/24/21.
//

import SwiftUI

// TODO: with these dialogs, we only want to update the model if there is a change in the clock data.
struct TimescaleConfigurationView: View {
    @Binding var timescaleTypeInt: Int
    @Binding var reverseTime: Bool

    @State private var timescaleType: TimescaleType = TimescaleType.year
    @State private var reverseTimeState: Bool = false

    @EnvironmentObject var clockData: ClockData


    var body: some View {
        VStack {
            Picker(selection: $timescaleType, label: Text("Timescale"), content: {
                ForEach(TimescaleType.allCases) { timescaleType in
                    Text(timescaleType.description)

                }
            })
            Toggle(isOn: $clockData.clock.reverseTime, label: { Text("Reverse Time") })
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
        TimescaleConfigurationView(timescaleTypeInt: .constant(0), reverseTime: .constant(false))
            .environmentObject(ClockData.shared)
    }
}
