//
//  ClockEnvironmentDelegate.swift
//  MorbidMeter
//
//  Created by David Mann on 5/22/25.
//


public protocol ClockEnvironmentDelegate: AnyObject {
    func shouldSaveSynchronously() -> Bool
}
