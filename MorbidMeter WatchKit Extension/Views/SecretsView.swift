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
            Text("Secrets").font(.headline)
            Text("What if your whole life could be squeezed into a single year?  If so, what is the date and time right now?  Or you may be curious, how many months, weeks, days, hours, minutes, or seconds have you been alive?  MorbidMeter answers these questions.  Enter your birthday and estimated deathday.  No, MorbidMeter doesn't calculate the latter for you.  It's not that kind of app.  Just estimate. For example in the US the average lifespan is about 78 years.  Increase or decrease depending on your level of optimism and health.  Then pick a time scale.  For example, pick 'One Year' and see the current date and time of your life in that single year.  Or pick 'Seconds' and see how many seconds you have been alive.  You can reverse each scale to count backwards.  At its core, MorbidMeter converts familiar time intervals to other, less familiar time intervals.  It was originally conceived as a method of adding perpective to our lifespans, but you can also use it as a timer app to measure the passage of time, using unfamiliar time scales.\n\nNote that MorbidMeter complications update every 5 minutes.")

        }
    }
}

struct SecretsView_Previews: PreviewProvider {
    static var previews: some View {
        SecretsView()
    }
}
