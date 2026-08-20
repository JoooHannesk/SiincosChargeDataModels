//
//  SiincosChargeDataModels.swift
//  SiincosChargeDataModels
//
//  Created by Johannes Kinzig on 20.08.2026
//

import Foundation

/// Harmonized Charger States
///
/// Siincos Charge Edge supports the following harmonized charger states.
public enum ChargerState: String, Codable, CaseIterable {

    /// EV is charging
    case charging

    /// EV is not charging
    case notCharging

    /// Charger state is unknown
    case unknown

    /// Charger encountered an error
    case error
}

/// Harmonized EV States
///
/// Siincos Charge Edge supports the following harmonized EV states.
public enum EVState: String, Codable, CaseIterable {

    /// EV is plugged into charger
    case pluggedIn

    /// EV is not plugged into charger
    case unplugged

    /// EV state is unknown (not good, but we may need this state)
    case unknown

    /// Unclear, as it is either plugged or unplugged, but leave this case
    /// for some sort of communication error between charger and EV
    case error
}

/// Lock States
///
/// States representing a generic lock
public enum LockState: UInt {
    case locked = 0
    case unlocked = 1
    case unknown = 2

    /// Represent ``LockState`` as ``Status``.
    var asStatus: Status {
        switch self {
        case .locked: return .disabled
        case .unlocked: return .enabled
        case .unknown: return .unknown
        }
    }
}

/// Status
///
/// Represent a simple status: `.enabled` or `.disabled` and `.unknown`
/// if not supported by a device or functionality
public enum Status: UInt8, Codable, CaseIterable {
    case disabled = 0
    case enabled = 1
    case unknown = 2
}

/// Electric Current
///
/// Electric current in a 3-phase grid
public struct ElectricCurrent3PhaseGrid: Codable, Hashable {
    var currentL1: Measurement<UnitElectricCurrent>?
    var currentL2: Measurement<UnitElectricCurrent>?
    var currentL3: Measurement<UnitElectricCurrent>?

    /// Get Average Current
    ///
    /// Get average current for a 3-phase power grid based on the current on each phase.
    /// Ignore phases with 0.0 current, as this indicates that they are not in use.
    var currentAverage: Measurement<UnitElectricCurrent> {
        let valid: [Measurement<UnitElectricCurrent>] = [currentL1, currentL2, currentL3]
            .compactMap { $0 }
            .filter { $0.value != 0.0 }
        guard !valid.isEmpty else { return Measurement(value: 0.0, unit: .amperes) }
        let average = valid.map(\.value).reduce(0, +) / Double(valid.count)
        return Measurement(value: average, unit: .amperes)
    }
}

/// Electric Voltage
///
/// Electric voltage in a 3-Phase grid
/// - Note: Assuming potential difference between L and N, not between Lx and Ly
public struct ElectricVoltage3PhaseGrid: Codable, Hashable {
    var voltageL1: Measurement<UnitElectricPotentialDifference>?
    var voltageL2: Measurement<UnitElectricPotentialDifference>?
    var voltageL3: Measurement<UnitElectricPotentialDifference>?
}

/// Electric Power
///
/// Electric power in a 3-phase grid
public struct ElectricPower3PhaseGrid: Codable, Hashable {
    var powerL1: Measurement<UnitPower>?
    var powerL2: Measurement<UnitPower>?
    var powerL3: Measurement<UnitPower>?
    var powerTotal: Measurement<UnitPower>
}
