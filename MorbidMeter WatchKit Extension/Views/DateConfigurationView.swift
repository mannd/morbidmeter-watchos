//
//  DateConfigurationView.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/24/21.
//

import SwiftUI

struct DateConfigurationView: View {
    private static let minimumYear = 1910
    private static let yearDiff = 2020 - minimumYear
    private static let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

    @Binding var date: Date

    @State private var selectedMonthIndex = 0
    @State private var selectedDayIndex = 0 // 1st of month
    @State private var selectedYearIndex = yearDiff

    var body: some View {
        VStack {
            HStack {
                Picker("Month", selection: $selectedMonthIndex) {
                    ForEach(0..<Self.months.count) { index in
                        Text(Self.months[index])
                    }
                }
                Picker("Day", selection: $selectedDayIndex) {
                    ForEach(0..<31) { day in
                        Text(String(day+1))
                    }
                }
                Picker("Year", selection: $selectedYearIndex) {
                    ForEach(0..<200) { year in
                        Text(String(year + Self.minimumYear))
                    }
                }
            }
        }
        .onAppear(perform: { convertDateToIndices() })
        .onDisappear(perform: { convertIndicesToDate() })
    }

    func convertIndicesToDate() {
        let month = selectedMonthIndex + 1
        let day = selectedDayIndex + 1
        let year = selectedYearIndex + Self.minimumYear
        let dateComponents = DateComponents(year: year, month: month, day: day)
        date = Calendar.current.date(from: dateComponents)!
        print(date)
    }

    func convertDateToIndices() {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        if let yearIndex = components.year, let monthIndex = components.month, let dayIndex = components.day {
            selectedYearIndex = yearIndex - Self.minimumYear
            selectedMonthIndex = monthIndex - 1
            selectedDayIndex = dayIndex - 1
        }
    }
}

struct DateConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        DateConfigurationView(date: .constant(Date()))
    }
}
