import Testing
import Foundation
@testable import SiincosChargeDataModels

@Suite("Date Extension")
struct DateExtensionTests {

    @Test func timeIntervalSince1970InMilliseconds() {
        let date = Date(timeIntervalSince1970: 1_000_000.5)
        #expect(date.timeIntervalSince1970InMilliseconds == 1_000_000_500)
    }

    @Test func initMillisecondsSince1970() {
        let date = Date(millisecondsSince1970: 1_000_000_500)
        #expect(date.timeIntervalSince1970 == 1_000_000.5)
    }

    @Test func roundTrip() {
        let original = Date(timeIntervalSince1970: 1_700_000_000.123)
        let roundTripped = Date(millisecondsSince1970: original.timeIntervalSince1970InMilliseconds)
        #expect(abs(roundTripped.timeIntervalSince1970 - original.timeIntervalSince1970) < 0.001)
    }
}
