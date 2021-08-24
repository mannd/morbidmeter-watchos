//
//  TimescaleConfigurationView.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/24/21.
//

import SwiftUI

struct TimescaleConfigurationView: View {
    @Binding var timescaleType: TimescaleType
    @Binding var reverseTime: Bool

    @State var timescaleTypeState: TimescaleType = TimescaleType.seconds
    @State var reverseTimeState: Bool = false

    var body: some View {
        VStack {
            Picker(selection: $timescaleTypeState, label: Text("Timescale"), content: {
                ForEach(TimescaleType.allCases) { timescaleTypeState in
                    Text(timescaleTypeState.description)

                }
            })
            Toggle(isOn: $reverseTimeState, label: { Text("Reverse Time") })
        }
        .onAppear(perform: {
            timescaleTypeState = timescaleType
            reverseTimeState = reverseTime
        })
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
