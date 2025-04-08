import AppKit
import Testing
@testable import BrowserAvailability

// Browsers known to exists, capable of being system defaults
func urlsForIdentifiers(_ identifiers: String...) -> [URL] {
    return identifiers.compactMap { identifier in
        NSWorkspace.shared.urlForApplication(withBundleIdentifier: identifier)
    }
}

@Test("Decode provision profiles", arguments: ["Chrome", "Edge", "Firefox"])
func decodeProvisionProfiles(profileName: String) async throws {
    let provisionProfileURL = try #require(Bundle.module.url(forResource: profileName, withExtension: "provisionprofile"), "Chrome provision profile not found.")
    let encodedProvisionProfile = try Data(contentsOf: provisionProfileURL)
    #expect(throws: Never.self, "Could not deocde \(profileName).provisionprofile") {
        try decode(message: encodedProvisionProfile)
    }
}

@Test("", arguments: urlsForIdentifiers("com.apple.Safari",
                                        "com.google.Chrome",
                                        "com.microsoft.edgemac",
                                        "org.mozilla.firefox"))
func checkBrowserAvailability(url: URL) async throws {
    let availableBrowsers = NSWorkspace.shared.urlsForBrowsers()
    #expect(availableBrowsers.contains(url))
}

