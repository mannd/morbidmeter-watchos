//
//  ContentView.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/8/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {

            Text("MorbidMeter")

            HStack {
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image("skull_button_2").resizable().aspectRatio(contentMode: .fit)

                })
                .buttonStyle(BorderedButtonStyle(tint: .black))
                Text("One Year")
            }
            Text("Aug 25, 10:15:20 PM")
            ProgressView(value: 0.7)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
