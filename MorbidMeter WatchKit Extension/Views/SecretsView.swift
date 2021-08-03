//
//  SecretsView.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 8/1/21.
//

import SwiftUI

struct SecretsView: View {
    let cr = "\n"

    var body: some View {
        ScrollView {
            Text("So, you have reached the secret core of MorbidMeter.  Congratulations!\n\nWhat is MorbidMeter?  What is it for?\n\nGood questions.\n\nAt its core, MorbidMeter converts time intervals to other time intervals.  Or it displays time intervals in different, perhaps more unsettling, time units.\n\nFor example, what if you squeezed your whole life span into a single year, or a single month, or day, or even an hour?  What date and time are you along that single year's time track right now?\n\nOr are you curious how many days, or hours, or even seconds you have lived so far?  Just set your birthday as the start date, your estimated demise day as the end date, and try out the different time scales available.\n\nYou don't need to be so morbid though.  Use MorbidMeter as a timer app, setting start and stop times, only instead of using plain old vanilla time, pick a different time scale to measure the passage of time.\n\nNote that watch complications only update every five minutes.")
        }
    }
}

struct SecretsView_Previews: PreviewProvider {
    static var previews: some View {
        SecretsView()
    }
}
