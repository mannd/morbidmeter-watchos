//
//  MorbidMeterView.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 7/22/21.
//

import SwiftUI
import UserNotifications

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
            })
            .buttonStyle(PlainButtonStyle())
            Text(morbidMeterTime)
                .font(Font.system(size: 14.0))
                .multilineTextAlignment(.center)
            ProgressView(value: progressValue)
        }
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
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print(error.localizedDescription)
            }
            print("Requested authorization")
        }
        if firstRun {
            morbidMeterError("Tap 💀 to configure...")
            firstRun = false
        } else {
            morbidMeterTime = "Loading..."
            stopTimer()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                updateClock()
            })
            setupNotifications()
        }

    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func setupNotifications() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            guard (settings.authorizationStatus == .authorized) ||
                    (settings.authorizationStatus == .provisional) else { return }

            // Get rid of all old notifications.
            center.removeAllPendingNotificationRequests()

            let clock = clockData.clock
            let reverseTime = clock.reverseTime

            // Notification that MM is starting.
            let startContent = UNMutableNotificationContent()
            startContent.title = "It's Started"
            startContent.body = "Timing has begun."
            startContent.sound = UNNotificationSound.default
            let startDateComponents = getStandardDateComponents(from: clock.birthday)
            let startTrigger = UNCalendarNotificationTrigger(dateMatching: startDateComponents, repeats: false)
            let startRequest = UNNotificationRequest(identifier: UUID().uuidString, content: startContent, trigger: startTrigger)
            center.add(startRequest)

            // Notification that MM finished.
            let endContent = UNMutableNotificationContent()
            endContent.title = "You're Finished"
            endContent.body = "You are living on borrowed time."
            endContent.sound = UNNotificationSound.default
            let endDateComponents = getStandardDateComponents(from: clock.deathday)
            let endTrigger = UNCalendarNotificationTrigger(dateMatching: endDateComponents, repeats: false)
            let endRequest = UNNotificationRequest(identifier: UUID().uuidString, content: endContent, trigger: endTrigger)
            center.add(endRequest)

            // 50% mark
            // Only set if longevity > 1 day
            guard clock.lifespanLongerThan(timeInterval: TimeConstants.twentyFourHours) else { return }
            let halfwayContent = UNMutableNotificationContent()
            halfwayContent.title = "You're half-way"
            halfwayContent.body = "Glass half-full or half-empty?"
            halfwayContent.sound = UNNotificationSound.default
            if let halfwayDay = clock.dateFromPercentage(percent: 0.5) {
                let halfwayDateComponents = getStandardDateComponents(from: halfwayDay)
                let halfwayTrigger = UNCalendarNotificationTrigger(dateMatching: halfwayDateComponents, repeats: false)
                let halfwayRequest = UNNotificationRequest(identifier: UUID().uuidString, content: halfwayContent, trigger: halfwayTrigger)
                center.add(halfwayRequest)
            }

            // 90% mark
            // Only set if longevity > 1 week
            guard clock.lifespanLongerThan(timeInterval: TimeConstants.oneWeek) else { return }
            let ninetyPercentContent = UNMutableNotificationContent()
            ninetyPercentContent.title = "10% Time Remaining"
            ninetyPercentContent.body = "Time flies."
            ninetyPercentContent.sound = UNNotificationSound.default
            if let ninetyPercentDay = clock.dateFromPercentage(percent: reverseTime ? 0.1 : 0.9) {
                let ninetyPercentDateComponents = getStandardDateComponents(from: ninetyPercentDay)
                let ninetyPercentTrigger = UNCalendarNotificationTrigger(dateMatching: ninetyPercentDateComponents, repeats: false)
                let ninetyPercentRequest = UNNotificationRequest(identifier: UUID().uuidString, content: ninetyPercentContent, trigger: ninetyPercentTrigger)
                center.add(ninetyPercentRequest)
            }

            // 99% mark
            let ninetyNinePercentContent = UNMutableNotificationContent()
            ninetyNinePercentContent.title = "1% Time Remaining"
            ninetyNinePercentContent.body = "Prepare yourself."
            ninetyNinePercentContent.sound = UNNotificationSound.default
            if let ninetyNinePercentDay = clock.dateFromPercentage(percent: reverseTime ? 0.01 : 0.99) {
                let ninetyNinePercentDateComponents = getStandardDateComponents(from: ninetyNinePercentDay)
                let ninetyNinePercentTrigger = UNCalendarNotificationTrigger(dateMatching: ninetyNinePercentDateComponents, repeats: false)
                let ninetyNinePercentRequest = UNNotificationRequest(identifier: UUID().uuidString, content: ninetyNinePercentContent, trigger: ninetyNinePercentTrigger)
                center.add(ninetyNinePercentRequest)
            }
        }
    }

    private func getStandardDateComponents(from date: Date) -> DateComponents {
        return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    }


    func updateClock() {
        let moment = clockData.getMoment()
        progressValue = moment.percentage
        morbidMeterTime = moment.time
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
