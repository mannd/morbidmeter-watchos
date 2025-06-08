//
//  ClockData.swift
//  ClockCore
//
//  Created by David Mann on 5/22/25.
//

import Combine
import ClockKit
import os
import WidgetKit

/// ClockData is the data source for the app, backed by a file in the sandboxed user document directory, i.e. essentially a singleton.
public class ClockData: ObservableObject {
    let logger = Logger(subsystem: "org.epstudios.morbidmeter", category: "Clock")

    public weak var environmentDelegate: ClockEnvironmentDelegate?

    public static let shared = ClockData()
    public static let test = ClockData(clock: Clock(birthday: Date().addingTimeInterval(-60.0 * 60.0),
                                             deathday: Date().addingTimeInterval(60.0 * 60.0),
                                             reverseTime: false))
    public static let longLifeTest = ClockData(clock: Clock(birthday: Date().addingTimeInterval(-60.0 * 60.0 * 24 * 365 * 40),
                                                     deathday: Date().addingTimeInterval(60.0 * 60.0 * 24 * 365 * 40),
                                                     reverseTime: false))

    private var background = DispatchQueue(label: "Background Queue", qos: .userInitiated)

    @Published public var clock = Clock() {
        didSet {
            logger.info("Clock was set.")
//            self.save()
        }
    }

    public func getMoment(date: Date = Date()) -> Moment {
        return clock.getMoment(date: date)
    }

    public func loadSynchronouslyIfNeeded() {
        logger.debug("loadSyncronouslyIfNeeded called.")
//        if clock == savedClock {
//            return  // Already loaded
//        }

        do {
            let data = try Data(contentsOf: self.getDataURL())
            let decoder = PropertyListDecoder()
            let loadedClock = try decoder.decode(Clock.self, from: data)

            DispatchQueue.main.sync {
//                self.savedClock = loadedClock
                self.clock = loadedClock
            }
        } catch {
            logger.error("Failed to synchronously load clock: \(error.localizedDescription)")
            // Fall back to default
            let fallback = Clock()
//            self.savedClock = fallback
            self.clock = fallback
        }
    }


//    private var savedClock = Clock()

    // Load and save model to disk
    private init() {
        load()
    }

    private init(clock: Clock) {
        self.clock = clock
    }

    public func load() {
        logger.info("Loading saved clock")
        background.async { [unowned self] in
            var clock: Clock

            do {
                let data = try Data(contentsOf: self.getDataURL())
                let decoder = PropertyListDecoder()
                clock = try decoder.decode(Clock.self, from: data)
            } catch CocoaError.fileReadNoSuchFile {
                self.logger.info("data file not found: creating default clock")
                clock = Clock()
            } catch {
                fatalError("Unexpected error while loading clock: \(error.localizedDescription)")
            }

            DispatchQueue.main.async { [unowned self] in
                self.clock = clock
            }
        }
    }

    public func loadSynchronously() {
        do {
            let data = try Data(contentsOf: self.getDataURL())
            let decoder = PropertyListDecoder()
            let clock = try decoder.decode(Clock.self, from: data)
            self.clock = clock
        } catch {
            logger.error("Failed to load clock synchronously: \(error.localizedDescription)")
        }
    }


    public func save() {
        // Don't bother resaving clock if it hasn't changed.
//        if clock == savedClock  {
//            return
//        }

        logger.info("saving clock")

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
                //self.savedClock = clock
                self.logger.info("clock successfully saved")
            } catch {
                self.logger.error("error writing to disk: \(error.localizedDescription)")
            }
        }

        if environmentDelegate?.shouldSaveSynchronously() == true {
            logger.info("saving synchronously")
            saveAction()
        } else {
            background.async { [unowned self] in
                self.logger.info("saving asynchronously")
                saveAction()
            }
        }
    }

    private func getDataURL() throws -> URL {
        let fileManager = FileManager.default
        guard let containerURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.org.epstudios.morbidmeter") else {
            throw CocoaError(.fileNoSuchFile)  // Or some other appropriate error
        }
        return containerURL.appendingPathComponent("MorbidMeterClock.plist")
    }
}
