import XCTest
@testable import BrowserAvailability

final class BrowserAvailabilityTests: XCTestCase {
    func testRegisteredBrowsers() throws {
        let bundles = NSWorkspace.shared.urlsForBrowsers()
        
        XCTAssertEqual(4, bundles.count)
    }
}
