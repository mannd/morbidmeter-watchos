//
//  ContentView.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/8/21.
//

import SwiftUI

// See https://horrormade.com/2016/03/14/131-free-horror-fonts-you-can-use-anywhere/ for source of MM type fonts.

struct ContentView: View {
    @AppStorage(Preferences.timescaleTypeKey) var timescaleTypeInt = Preferences.timescaleTypeInt
    @AppStorage(Preferences.birthdayKey) var birthday = Preferences.birthday
    @AppStorage(Preferences.deathdayKey) var deathday = Preferences.deathday
    @AppStorage(Preferences.reverseTimeKey) var reverseTime = Preferences.reverseTime

    @State private var morbidMeterTime: String = "Loading"
    @State private var progressValue: Double = 0

    var body: some View {
        VStack {
            Text("MorbidMeter")
                .font(Font.custom("BlackChancery", size: 22))
            HStack {
               Button(action:  { updateClock() }, label: {
                    Image("skull_button_2").resizable().aspectRatio(contentMode: .fit)
                }).buttonStyle(PlainButtonStyle())
                NavigationLink(destination: ConfigurationView(), label: { Text(TimescaleType(rawValue: timescaleTypeInt)?.fullDescription(reverseTime: reverseTime) ?? "Error").foregroundColor(.white) })
             }
            Text(morbidMeterTime)
                .font(Font.system(size: 14.0))
                .multilineTextAlignment(.center)
            ProgressView(value: progressValue)
        }
        .onAppear(perform: {
            print(birthday.description)
            print(deathday.description)
            updateClock()
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                updateClock()
            })
        })

    }

    func printFonts() {
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
    }

    func updateClock() {
        print("updateClock()")
        let timescaleType = TimescaleType(rawValue: timescaleTypeInt) ?? TimescaleType.blank
        let clock = Clock(birthday: birthday, deathday: deathday, timescaleType: timescaleType, reverseTime: reverseTime)
        let clockTime = clock.getClockTime()
        progressValue = clockTime.percentage
        morbidMeterTime = clockTime.time
    }

    func morbidMeterError(_ message: String, progressValue: Double = 0) {
        self.progressValue = progressValue
        morbidMeterTime = message
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
