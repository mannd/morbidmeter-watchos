//
//  ContentView.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 6/8/21.
//

import SwiftUI

// See https://horrormade.com/2016/03/14/131-free-horror-fonts-you-can-use-anywhere/ for source of MM type fonts.

struct ContentView: View {
    var body: some View {
        VStack {
            NavigationLink(destination: ConfigurationView()) {
                Text("MorbidMeter")
                    .font(Font.custom("BlackChancery", size: 20))
            }
            HStack {
                Button(action:  { showConfiguration()}, label: {
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

    func printFonts() {
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
    }

    func showConfiguration() {

    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
