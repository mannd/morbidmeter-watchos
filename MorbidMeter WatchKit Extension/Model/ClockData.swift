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

class ClockData: ObservableObject {
    let logger = Logger(subsystem: "org.epstudios.MorbidMeter.watchkitapp.watchkitextension.ClockData", category: "Model")

    static let shared = ClockData()

    private var background = DispatchQueue(label: "Background Queue", qos: .userInitiated)

    @Published public var clock = Clock() {
        didSet {
            logger.debug("Clock was set.")

            // Update complications
            let server = CLKComplicationServer.sharedInstance()
            for complication in server.activeComplications ?? [] {
                // FIXME: Temporarily inhibited
//                server.reloadTimeline(for: complication)
            }
            // potentially save data, if not using user defaults
            self.save()
        }
    }

    public func getClockTime(date: Date = Date()) -> ClockTime {
        return clock.getClockTime(date: date)
    }

    private var savedClock = Clock()

    // Load and save model to disk
    private init() {
        load()
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
