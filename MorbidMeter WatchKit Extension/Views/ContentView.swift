//
//  ContentView.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/8/21.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase

    let data = ClockData.shared

    var body: some View {
        MorbidMeterView()
            .environmentObject(data)
   }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
                .previewDevice("Apple Watch Series 3 - 38mm")
            ContentView()
                .previewDevice("Apple Watch Series 6 - 40mm")
            ContentView()
                .previewDevice("Apple Watch Series 6 - 44mm")
        }
    }
}
