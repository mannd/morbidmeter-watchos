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
                .font(Font.system(size: 14.0))
                .multilineTextAlignment(.center)
            ProgressView(value: progressValue)
        }
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
        // TODO: replace with lifespan

        guard let timescaleType = TimescaleType(rawValue: timescaleTypeInt) else {
            morbidMeterError("TimescaleType Error")
            return
        }
        guard let timescale = Timescales.getInstance(timescaleType) else {
            morbidMeterError("Timescale Error")
            return
        }
        do {
            let now = Date()
            let lifespan = try Lifespan(birthday: birthday, deathday: deathday)
            let percentage = try lifespan.percentage(date: now, reverse: reverseTime)
            progressValue = percentage
            if let clockTime = timescale.clockTime {
                if timescale.timescaleType == .daysHoursMinsSecs
                    || timescale.timescaleType == .yearsMonthsDays {
                    morbidMeterTime = clockTime(now, reverseTime ? deathday : birthday, reverseTime)
                } else {
                    morbidMeterTime = (clockTime(lifespan.timeInterval(date: now, reverseTime: reverseTime), percentage, reverseTime) )
                }
            }
        } catch LifespanError.birthdayInFuture {
            morbidMeterError("BD after DD")
        } catch LifespanError.excessLongevity {
            morbidMeterError("Lifespan Too Long")
        } catch LifespanError.alreadyDead {
            morbidMeterError("Already Dead", progressValue: 1.0)
        } catch LifespanError.lifespanIsZero {
            morbidMeterError("Lifespan too short")
        } catch {
            morbidMeterError("Lifespan Error")
        }
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
