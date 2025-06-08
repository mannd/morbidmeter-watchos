//
//  TimescaleConfigurationView.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/24/21.
//

import SwiftUI
import ClockCore

struct TimescaleConfigurationView: View {
    @Binding var timescaleType: TimescaleType
    @Binding var reverseTime: Bool

    @State private var timescaleTypeState: TimescaleType = TimescaleType.seconds
    @State private var reverseTimeState: Bool = false

    var body: some View {
        VStack {
            Picker(selection: $timescaleTypeState, label: Text("Timescale"), content: {
                ForEach(TimescaleType.allCases) { option in
                    Text(option.description)

                }
            })
            Toggle(isOn: $reverseTimeState, label: { Text("Reverse Time") })
        }
        .onAppear {
            DispatchQueue.main.async {
                timescaleTypeState = timescaleType
                reverseTimeState = reverseTime
            }
        }
        .onDisappear(perform: {
            if timescaleType != timescaleTypeState {
                timescaleType = timescaleTypeState
            }
            if reverseTime != reverseTimeState {
                reverseTime = reverseTimeState
            }
        })
    }
}

struct TimescaleConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        TimescaleConfigurationView(timescaleType: .constant(.seconds), reverseTime: .constant(false))
            .environmentObject(ClockData.shared)
    }
}
