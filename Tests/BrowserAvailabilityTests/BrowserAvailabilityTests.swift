import XCTest
@testable import BrowserAvailability

final class BrowserAvailabilityTests: XCTestCase {
    func testRegisteredBrowsers() throws {
        
        let installedBrowsers = Set(NSWorkspace.shared.urlsForBrowsers())
        let manuallyCheckedBrowsers = setOfManuallyCheckedBrowsers()
        let intersection = manuallyCheckedBrowsers.intersection(installedBrowsers)
        XCTAssertEqual(intersection.count, manuallyCheckedBrowsers.count)
    }
    
    func setOfManuallyCheckedBrowsers() -> Set<URL> {
        var knownBrowsers = Set<URL>()

        knownBrowsers.insert(URL(filePath: "/Applications/Safari.app/"))
        
        if let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.microsoft.edgemac") {
            knownBrowsers.insert(url)
        }
        
        if let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.google.Chrome") {
            knownBrowsers.insert(url)
        }
        
        if let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "org.mozilla.firefox") {
            knownBrowsers.insert(url)
        }
        
        return knownBrowsers
    }
}
