import Foundation
import Testing
@testable import BrowserAvailability

@Test func readChromeProvisionProfile() async throws {
    let provisionProfileURL = try #require(Bundle.module.url(forResource: "Chrome", withExtension: "provisionprofile"), "Chrome provision profile not found.")
    let encodedProvisionProfile = try Data(contentsOf: provisionProfileURL)
    let decodedProvisionProfile = try #require(try decode(message: encodedProvisionProfile), "Chrome provision profile contains no data.")
    let propertyList = try #require(PropertyListSerialization.propertyList(from: decodedProvisionProfile, format: nil) as? [String : Any], "Could not serialize property list from decoded provision profile.")
    let entitlements = try #require(propertyList["Entitlements"] as? [String : Any], "Provision profile has no entitlements.")
    #expect(entitlements.keys.contains { $0.hasPrefix("com.apple.developer.web-browser") }, "Could not find browser entitlement in provision profile.")
}

