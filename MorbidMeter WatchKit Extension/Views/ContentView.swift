//
//  ContentView.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/8/21.
//

import SwiftUI

// See https://horrormade.com/2016/03/14/131-free-horror-fonts-you-can-use-anywhere/ for source of MM type fonts.

struct ContentView: View {
    @AppStorage(Preferences.timescaleTypeKey) var timescaleTypeInt = Preferences.timescaleType
    @AppStorage(Preferences.birthdayKey) var birthday = Preferences.birthday
    @AppStorage(Preferences.deathdayKey) var deathday = Preferences.deathday
    @AppStorage(Preferences.reverseTimeKey) var reverseTime = Preferences.reverseTime

    @State private var morbidMeterTime: String = "Aug 25, 10:15:20 PM"
    @State private var progressValue: Double = 0.7

    var body: some View {
        VStack {
            // TODO: Skull button should go to configuration and title refreshes.
            NavigationLink(destination: ConfigurationView()) {
                Text("MorbidMeter")
                    .font(Font.custom("BlackChancery", size: 20))
            }
            Button(action:  { updateClock() }, label: {
                HStack {
                    Image("skull_button_2").resizable().aspectRatio(contentMode: .fit)
                    Text(TimescaleType(rawValue: timescaleTypeInt)?.fullDescription(reverseTime: reverseTime) ?? "Error").foregroundColor(.white)

                }
            })
                .buttonStyle(BorderedButtonStyle())
            Text(morbidMeterTime)
            ProgressView(value: progressValue)
        }
        .padding()
        .onAppear(perform: { updateClock() })
    }

    func printFonts() {
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
    }

    func updateClock() {
        print("Updating MorbidMeter")
        guard deathday > birthday else {
            morbidMeterError("BD is after DD?")
            return
        }
        guard let timescaleType = TimescaleType(rawValue: timescaleTypeInt) else {
            morbidMeterError("Timescale Error")
            return
        }
        guard let timescale = Timescales.getInstance(timescaleType) else {
            morbidMeterError("Timescale Error")
            return
        }
        let clock = Clock(timescale: timescale, reverseTime: reverseTime, birthday: birthday, deathday: deathday)
        guard let percentage = clock.percentage(date: Date()) else {
            morbidMeterError("Longevity Error")
            return
        }
        progressValue = percentage
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        let x = formatter.string(from: NSNumber(value: percentage))
        morbidMeterTime = x!
    }

    func morbidMeterError(_ message: String) {
        progressValue = 0
        morbidMeterTime = message
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
