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
            Text("MorbidMeter")
                .font(Font.custom("BlackChancery", size: 22))
            HStack {
               Button(action:  { updateClock() }, label: {
                    Image("skull_button_2").resizable().aspectRatio(contentMode: .fit)
                }).buttonStyle(PlainButtonStyle())
                NavigationLink(destination: ConfigurationView(), label: { Text(TimescaleType(rawValue: timescaleTypeInt)?.fullDescription(reverseTime: reverseTime) ?? "Error").foregroundColor(.white) })
             }
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
        print(birthday)
        print(deathday)
        guard let timescaleType = TimescaleType(rawValue: timescaleTypeInt) else {
            morbidMeterError("TimescaleType Error")
            return
        }
        guard var timescale = Timescales.getInstance(timescaleType) else {
            morbidMeterError("Timescale Error")
            return
        }
        timescale.reverseTime = reverseTime
        let clock = Clock(timescale: timescale, birthday: birthday, deathday: deathday)
        do {
            let percentage = try clock.percentage(date: Date())
            progressValue = percentage
            // TODO: add units/reverseUnits
            if let clockTime = clock.timescale.clockTime {
                morbidMeterTime = clockTime(percentage) + timescale.adjustedUnits
            } else {
                morbidMeterError("Clock Time Error")
            }
        } catch ClockError.negativeLongevity {
            morbidMeterError("BD after DD")
        } catch ClockError.alreadyDead {
            morbidMeterError("Already Dead")
        } catch ClockError.birthdayInFuture {
            morbidMeterError("Birthday in Future")
        } catch {
            morbidMeterError("Longevity Error")
        }
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
