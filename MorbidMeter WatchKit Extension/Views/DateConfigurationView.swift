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

    @State private var selectedHourIndex = 0
    @State private var selectedMinuteIndex = 0
    @State private var selectedSecondIndex = 0

    var body: some View {
            GeometryReader { geometry in
                VStack {
                    Text("Date").font(Font.system(size: 13))
                    HStack {
                        Picker("Year", selection: $selectedYearIndex) {
                            ForEach(0..<200) { year in
                                Text(String(year + Self.minimumYear))
                            }
                        }
                        .frame(width: geometry.size.width * 0.38)
                        Picker("Month", selection: $selectedMonthIndex) {
                            ForEach(0..<Self.months.count) { index in
                                Text(Self.months[index])
                            }
                        }
                        .frame(width: geometry.size.width * 0.32)
                        Picker("Day", selection: $selectedDayIndex) {
                            ForEach(0..<31) { day in
                                Text(String(day+1))
                            }
                        }
                    }
                    .font(geometry.size.width > WatchSize.sizeInPoints(WatchSize.size38mm).width ? Font.system(size: 17) : Font.system(size: 13))
                    NavigationLink(destination: TimeConfigurationView(selectedHourIndex: $selectedHourIndex, selectedMinuteIndex: $selectedMinuteIndex, selectedSecondIndex: $selectedSecondIndex), label: { Text("Time")})
                }
                .onAppear(perform: { convertDateToIndices() })
                .onDisappear(perform: { convertIndicesToDate() })
            }
    }


    func convertIndicesToDate() {
        let month = selectedMonthIndex + 1
        let day = selectedDayIndex + 1
        let year = selectedYearIndex + Self.minimumYear
        let hour = selectedHourIndex
        let minute = selectedMinuteIndex
        let second = selectedSecondIndex
        let dateComponents = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
        if let newDate = Calendar.current.date(from: dateComponents), newDate != date {
            date = newDate
        }
        print("Date is now... ", date)
    }

    func convertDateToIndices() {
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        if let yearIndex = components.year, let monthIndex = components.month, let dayIndex = components.day, let hourIndex = components.hour, let minuteIndex = components.minute, let secondIndex = components.second {
            print(components)
            selectedYearIndex = yearIndex - Self.minimumYear
            selectedMonthIndex = monthIndex - 1
            selectedDayIndex = dayIndex - 1
            selectedHourIndex = hourIndex
            selectedMinuteIndex = minuteIndex
            selectedSecondIndex = secondIndex
        }
    }
}

struct DateConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DateConfigurationView(date: .constant(Date()))
                .environmentObject(ClockData.shared)
            DateConfigurationView(date: .constant(Date()))
                .environmentObject(ClockData.shared)
                .previewDevice("Apple Watch Series 3 - 38mm")
            DateConfigurationView(date: .constant(Date()))
                .environmentObject(ClockData.shared)
                .previewDevice("Apple Watch Series 6 - 40mm")
            DateConfigurationView(date: .constant(Date()))
                .environmentObject(ClockData.shared)
                .previewDevice("Apple Watch Series 6 - 44mm")
        }
    }
}

/// Sizes of screens in pixels of available watches.
///
/// Source: https://stackoverflow.com/questions/56894240/device-specific-layout-with-swiftui-on-apple-watch-and-iphone
enum WatchSize {
    static let size44mm = CGSize(width: 368, height: 448)
    static let size42mm = CGSize(width: 312, height: 390)
    static let size40mm = CGSize(width: 324, height: 394)
    static let size38mm = CGSize(width: 272, height: 340)

    /// Convert size in pixels to size in points
    ///
    /// Size in points is half of size in pixels.
    /// - Parameter size: Size in pixels
    /// - Returns: Size in points
    static func sizeInPoints(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width / 2.0, height: size.height / 2.0 )
    }
}
