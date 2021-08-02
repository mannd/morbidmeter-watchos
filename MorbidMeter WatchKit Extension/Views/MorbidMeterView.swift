//
//  MorbidMeterView.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 7/22/21.
//

import SwiftUI

// See https://horrormade.com/2016/03/14/131-free-horror-fonts-you-can-use-anywhere/ for source of MM type fonts.

struct MorbidMeterView: View {
    @State var birthday = Date()
    @State var deathday = Date()
    @State var reverseTime = false
    @AppStorage(Preferences.firstRunKey) var firstRun = Preferences.firstRun

    @State private var timer: Timer?

    @State private var morbidMeterTime: String = "Loading"
    @State private var progressValue: Double = 0

    @EnvironmentObject var clockData: ClockData

    var body: some View {
        VStack {
            Text(Clock.fullName)
                .font(Font.custom("BlackChancery", size: 22))
            NavigationLink(destination: ConfigurationView(), label: {
                Image("skull_button_2").resizable().aspectRatio(contentMode: .fit)
            }).buttonStyle(PlainButtonStyle())
            Text(morbidMeterTime)
                .font(Font.system(size: 14.0))
                .multilineTextAlignment(.center)
            ProgressView(value: progressValue)
        }
        // Due to SwiftUI bug, .onAppear runs right after onDisappear, weirdly enough.
        // So we stop timer everytime we start it.
        // See https://forums.swift.org/t/swiftui-onappear-and-ondisappear-action-ordering/36320/5
        .onDisappear(perform: {
            print("MM onDisappear()")
            stopTimer()
        })
        .onAppear(perform: {
            print("MM onAppear()")
            startTimer()
        })
    }

    func startTimer() {
        guard !firstRun else {
            morbidMeterError("Tap 💀 to configure...")
            firstRun = false
            return
        }
        morbidMeterTime = "Loading..."
        // stop any timer that was already running
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            updateClock()
        })
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func updateClock() {
        let clockTime = clockData.getClockTime()
        progressValue = clockTime.percentage
        morbidMeterTime = clockTime.time
        if progressValue < 1.0 {
            return
        }
        WKInterfaceDevice.current().play(.stop)
        stopTimer()
    }

    func morbidMeterError(_ message: String, progressValue: Double = 0) {
        self.progressValue = progressValue
        morbidMeterTime = message
    }
}

struct MorbidMeterView_Previews: PreviewProvider {
    static var previews: some View {
        MorbidMeterView()
            .environmentObject(ClockData.shared)
    }
}
