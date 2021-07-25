//
//  TimeConfigurationView.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 7/12/21.
//

import SwiftUI

struct TimeConfigurationView: View {

//    @EnvironmentObject var clockData: ClockData
    @Binding var selectedHourIndex: Int
    @Binding var selectedMinuteIndex: Int
    @Binding var selectedSecondIndex: Int

    @State var selectedHour: Int = 0
    @State var selectedMinute: Int = 0
    @State var selectedSecond: Int = 0

    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumIntegerDigits = 2
        return formatter
    }()

    var body: some View {
        VStack {
            Text("Time").font(Font.system(size: 12))
            HStack {
                Picker("Hour", selection: $selectedHour) {
                    ForEach(0..<24) { hour in
                        Text(formatter.string(from: NSNumber(value: hour))!)
                    }
                }
                Picker("Min", selection: $selectedMinute) {
                    ForEach(0..<60) { minute in
                        Text(formatter.string(from: NSNumber(value: minute))!)
                    }
                }
                Picker("Sec", selection: $selectedSecond) {
                    ForEach(0..<60) { sec in
                        Text(formatter.string(from: NSNumber(value: sec))!)
                    }
                }
            }
        }
        .onAppear(perform: {
            // Can't use the Bindings directly, need to use State variables and copy results back to the Bindings.
            selectedHour = selectedHourIndex
            selectedMinute = selectedMinuteIndex
            selectedSecond = selectedSecondIndex
        })
        .onDisappear(perform: {
            selectedHourIndex = selectedHour
            selectedMinuteIndex = selectedMinute
            selectedSecondIndex = selectedSecond
        })
    }
}

struct TimeConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            //            TimeConfigurationView(date: .constant(Date()))
            //                .previewDevice("Apple Watch Series 3 - 38mm")
            TimeConfigurationView(selectedHourIndex: .constant(0), selectedMinuteIndex: .constant(0), selectedSecondIndex: .constant(0))
                .previewDevice("Apple Watch Series 6 - 40mm")
                .environmentObject(ClockData.shared)

            TimeConfigurationView(selectedHourIndex: .constant(23), selectedMinuteIndex: .constant(59), selectedSecondIndex: .constant(59))
                .previewDevice("Apple Watch Series 6 - 44mm")
                .environmentObject(ClockData.shared)

        }
    }
}

