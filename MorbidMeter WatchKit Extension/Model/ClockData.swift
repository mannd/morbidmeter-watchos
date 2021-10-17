//
//  ClockData.swift
//  MorbidMeter WatchKit Extension
//
//  Created by David Mann on 7/15/21.
//

import SwiftUI
import Combine
import ClockKit
import os

/// ClockData is the data source for the app, backed by a file in the sandboxed user document directory, i.e. essentially a singleton.
class ClockData: ObservableObject {
    let logger = Logger(subsystem: "org.epstudios.MorbidMeter.watchkitapp.watchkitextension.ClockData", category: "Model")

    static let shared = ClockData()
    static let test = ClockData(clock: Clock(birthday: Date().addingTimeInterval(-60.0 * 60.0),
                                             deathday: Date().addingTimeInterval(60.0 * 60.0),
                                             reverseTime: false))
    static let longLifeTest = ClockData(clock: Clock(birthday: Date().addingTimeInterval(-60.0 * 60.0 * 24 * 365 * 40),
                                                     deathday: Date().addingTimeInterval(60.0 * 60.0 * 24 * 365 * 40),
                                                     reverseTime: false))

    private var background = DispatchQueue(label: "Background Queue", qos: .userInitiated)

    @Published public var clock = Clock() {
        didSet {
            logger.debug("Clock was set.")

            // FIXME: Move reload complications to configuration disappear?
            // Update complications
//            reloadComplications()
            self.save()
        }
    }

    public func getMoment(date: Date = Date()) -> Moment {
        return clock.getMoment(date: date)
    }

    private var savedClock = Clock()

    // Load and save model to disk
    private init() {
        load()
    }

    private init(clock: Clock) {
        self.clock = clock
    }
    
    private func load() {
        logger.debug("Loading saved clock")
        background.async { [unowned self] in
            var clock: Clock

            do {
                let data = try Data(contentsOf: self.getDataURL())
                let decoder = PropertyListDecoder()
                clock = try decoder.decode(Clock.self, from: data)
            } catch CocoaError.fileReadNoSuchFile {
                self.logger.debug("data file not found: creating default clock")
                clock = Clock()
            } catch {
                fatalError("Unexpected error while loading clock: \(error.localizedDescription)")
            }

            DispatchQueue.main.async { [unowned self] in
                savedClock = clock
                self.clock = clock
            }
        }
    }

    private func save() {
        // Don't bother resaving clock if it hasn't changed.
        if clock == savedClock  {
            return
        }

        logger.debug("saving clock")

        let encoder = PropertyListEncoder()
        encoder.outputFormat = .binary

        let data: Data

        do {
            data = try encoder.encode(clock)
        } catch {
            logger.error("Could not encode clock: \(error.localizedDescription)")
            return
        }
        let saveAction = { [unowned self] in
            do {
                try data.write(to: self.getDataURL(), options: [.atomic])
                self.savedClock = clock
                self.logger.debug("clock successfully saved")
            } catch {
                self.logger.error("error writing to disk: \(error.localizedDescription)")
            }
        }

        if WKExtension.shared().applicationState == .background {
            logger.debug("saving synchronously")
            saveAction()
        } else {
            background.async { [unowned self] in
                self.logger.debug("saving asynchronously")
                saveAction()
            }
        }
    }

    private func getDataURL() throws -> URL {
        let fileManager = FileManager.default
        let documentDirectory = try fileManager.url(for: .documentDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: false)
        return documentDirectory.appendingPathComponent("MorbidMeterClock.plist")
    }

}
