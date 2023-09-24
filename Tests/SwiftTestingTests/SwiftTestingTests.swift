import XCTest
import Testing
@testable import SwiftTesting

struct SwiftTestingTests2 {
    @Test
    func isHoge() {
        #expect(2 == 2)
    }
}
