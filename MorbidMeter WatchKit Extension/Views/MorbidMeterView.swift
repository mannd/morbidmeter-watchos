//
//  MorbidMeterView.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 7/22/21.
//

import SwiftUI

// See https://horrormade.com/2016/03/14/131-free-horror-fonts-you-can-use-anywhere/ for source of MM type fonts.

struct MorbidMeterView: View {
    @State var timescaleTypeInt = 0
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
            Text("MorbidMeter")
                .font(Font.custom("BlackChancery", size: 22))
            NavigationLink(destination: ConfigurationView().environmentObject(clockData), label: {
                Image("skull_button_2").resizable().aspectRatio(contentMode: .fit)
            }).buttonStyle(.plain)
            Text(morbidMeterTime)
                .font(Font.system(size: 14.0))
                .multilineTextAlignment(.center)
            ProgressView(value: progressValue)
        }
        .onDisappear(perform: {
            print("onDisappear()")
            stopTimer()
        })
        .onAppear(perform: {
            print("onAppear()")
            startTimer()
        })
        .onReceive(NotificationCenter.default.publisher(
            for: WKExtension.applicationWillResignActiveNotification
        )) { _ in
            movingToBackground()
        }
        .onReceive(NotificationCenter.default.publisher(
            for: WKExtension.applicationDidBecomeActiveNotification
        )) { _ in
            movingToForeground()
        }
    }

    func startTimer() {
        guard !firstRun else {
            morbidMeterError("Tap 💀 to configure...")
            firstRun = false
            return
        }
//        clockData.clock = Clock.activeClock()
        // TODO: ClockData must be updated when clock changes.
        updateClock()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            updateClock()
        })
    }

    func stopTimer() {
        timer?.invalidate()
        morbidMeterTime = "Loading..."
    }

    func updateClock() {
        let clockTime = clockData.getClockTime()
        progressValue = clockTime.percentage
        morbidMeterTime = clockTime.time
    }

    func morbidMeterError(_ message: String, progressValue: Double = 0) {
        self.progressValue = progressValue
        morbidMeterTime = message
    }

    func movingToBackground() {
        stopTimer()
        scheduleBackgroundRefreshTasks()
    }

    func movingToForeground() {
        startTimer()
    }

    private func scheduleBackgroundRefreshTasks() {
        print("scheduleBackgroundRefreshTasks()")
        let watchExtension = WKExtension.shared()
        let targetDate = Date().addingTimeInterval(15.0 * 60.0)
        watchExtension.scheduleBackgroundRefresh(withPreferredDate: targetDate, userInfo: nil, scheduledCompletion: { error in
            if let error = error {
                print("error in scheduling background tasks: \(error.localizedDescription)")
                return
            }
            print("background refresh scheduled")
        })
    }

}

struct MorbidMeterView_Previews: PreviewProvider {
    static var previews: some View {
        MorbidMeterView()
            .environmentObject(ClockData.shared)
    }
}
