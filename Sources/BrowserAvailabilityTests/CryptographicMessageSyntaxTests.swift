import Foundation
import Testing
@testable import BrowserAvailability

@Test("Decode provision profiles", arguments: ["Chrome", "Edge", "Firefox"])
func decodeProvisionProfiles(profileName: String) async throws {
    let provisionProfileURL = try #require(Bundle.module.url(forResource: profileName, withExtension: "provisionprofile"), "Chrome provision profile not found.")
    let encodedProvisionProfile = try Data(contentsOf: provisionProfileURL)
    #expect(throws: Never.self, "Could not deocde \(profileName).provisionprofile") {
        try decode(message: encodedProvisionProfile)
    }
}
