//
//  SiincosChargeDataModels.swift
//  SiincosChargeDataModels
//
//  Created by Johannes Kinzig on 20.08.2026
//

import Foundation

/// Charging Session Status
///
/// These cases describe the charging session status:
/// - running: a charging session is running, the ev charger is unlocked and the ev is ready to request power
/// - finished: a charging session is finished, mainly used in charging session receipts
/// - paused: a charging session is paused (by the charging session owner) and waits for being resumed
/// - scheduled: a charging session is scheduled for the future and is waiting to start (when scheduled datetime is reached)
public enum ChargingSessionStatus: String, Codable, CaseIterable, Sendable {
    case running
    case finished
    case paused
    case scheduled
}

/// Harmonized Charger States
///
/// Siincos Charge Edge supports the following harmonized charger states.
public enum ChargerState: String, Codable, CaseIterable, Sendable {

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
public enum EVState: String, Codable, CaseIterable, Sendable {

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
public enum LockState: UInt, Sendable {
    case locked = 0
    case unlocked = 1
    case unknown = 2

    /// Represent ``LockState`` as ``Status``.
    public var asStatus: Status {
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
public enum Status: UInt8, Codable, CaseIterable, Sendable {
    case disabled = 0
    case enabled = 1
    case unknown = 2
}

/// Electric Current
///
/// Electric current in a 3-phase grid
public struct ElectricCurrent3PhaseGrid: Codable, Hashable, Sendable {
    public var currentL1: Measurement<UnitElectricCurrent>?
    public var currentL2: Measurement<UnitElectricCurrent>?
    public var currentL3: Measurement<UnitElectricCurrent>?

    public init(currentL1: Measurement<UnitElectricCurrent>? = nil, currentL2: Measurement<UnitElectricCurrent>? = nil, currentL3: Measurement<UnitElectricCurrent>? = nil) {
        self.currentL1 = currentL1
        self.currentL2 = currentL2
        self.currentL3 = currentL3
    }

    /// Get Average Current
    ///
    /// Get average current for a 3-phase power grid based on the current on each phase.
    /// Ignore phases with 0.0 current, as this indicates that they are not in use.
    public var currentAverage: Measurement<UnitElectricCurrent> {
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
public struct ElectricVoltage3PhaseGrid: Codable, Hashable, Sendable {
    public var voltageL1: Measurement<UnitElectricPotentialDifference>?
    public var voltageL2: Measurement<UnitElectricPotentialDifference>?
    public var voltageL3: Measurement<UnitElectricPotentialDifference>?

    public init(voltageL1: Measurement<UnitElectricPotentialDifference>? = nil, voltageL2: Measurement<UnitElectricPotentialDifference>? = nil, voltageL3: Measurement<UnitElectricPotentialDifference>? = nil) {
        self.voltageL1 = voltageL1
        self.voltageL2 = voltageL2
        self.voltageL3 = voltageL3
    }
}

/// Electric Power
///
/// Electric power in a 3-phase grid
public struct ElectricPower3PhaseGrid: Codable, Hashable, Sendable {
    public var powerL1: Measurement<UnitPower>?
    public var powerL2: Measurement<UnitPower>?
    public var powerL3: Measurement<UnitPower>?
    public var powerTotal: Measurement<UnitPower>

    public init(powerL1: Measurement<UnitPower>? = nil, powerL2: Measurement<UnitPower>? = nil, powerL3: Measurement<UnitPower>? = nil, powerTotal: Measurement<UnitPower>) {
        self.powerL1 = powerL1
        self.powerL2 = powerL2
        self.powerL3 = powerL3
        self.powerTotal = powerTotal
    }
}
