//
//  SiincosChargeEncodingDecoding.swift
//  SiincosChargeDataModels
//
//  Created by Johannes Kinzig on 01.09.26.
//


import Foundation


public extension JSONEncoder {

    /// Encoder configured for the project-wide JSON conventions
    ///
    /// Dates are encoded as whole (integer) milliseconds since 1970, matching the format
    /// expected by third-party systems, e.g. cloud backends. Sub-millisecond precision is
    /// rounded away so values round-trip deterministically with
    /// ``JSONDecoder/customTelemetryCompatibleDecoder``.
    /// - Note: Use this instead of `JSONEncoder()` whenever encoding data models.
    static var customTelemetryCompatibleEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .custom { date, encoder in
            var container = encoder.singleValueContainer()
            try container.encode(date.timeIntervalSince1970InMilliseconds)
        }
        return encoder
    }
}

public extension JSONDecoder {

    /// Decoder configured for the project-wide JSON conventions
    ///
    /// Dates are decoded from whole (integer) milliseconds since 1970, the counterpart to
    /// ``JSONEncoder/customTelemetryCompatibleEncoder``.
    /// - Note: Use this instead of `JSONDecoder()` whenever decoding data models.
    static var customTelemetryCompatibleDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let milliseconds = try container.decode(Int64.self)
            return Date(millisecondsSince1970: milliseconds)
        }
        return decoder
    }
}


public extension Date {
    var timeIntervalSince1970InMilliseconds: Int64 {
        Int64((self.timeIntervalSince1970 * 1000).rounded())
    }

    init(millisecondsSince1970: Int64) {
        self.init(timeIntervalSince1970: Double(millisecondsSince1970) / 1000)
    }
}
