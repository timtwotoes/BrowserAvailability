import AppKit
import UniformTypeIdentifiers
import Security

extension NSWorkspace {
    
    /// Returns a list of all registered browsers capable of being set as a default browser on the system.
    ///
    /// The first browser url returned is also the systems current default browser.
    ///
    /// - Returns: URLs to application bundles
    public func urlsForBrowsers() -> [URL] {
        return urlsForApplications(toOpen: URL(string: "https:")!).compactMap { (url: URL) -> URL? in
            // Apple's own browser, does not follow their own guidelines, for becoming a default web browser.
            // A shadow application, not located in the Applications folder, pops up. Also Safari does not
            // contain a provision profile. Therefore it gets special attention.
            if url.lastPathComponent.lowercased() == "safari.app" {
                if FileManager.default.fileExists(atPath: "/Applications/Safari.app/") {
                    return URL(filePath: "/Applications/Safari.app/", directoryHint: .isDirectory)
                } else {
                    return NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.apple.Safari")
                }
            }
            
            guard let bundle = Bundle(url: url), let provisionProfileURL = bundle.provisionProfileURL else {
                return nil
            }

            guard let profile = ProvisionProfile(url: provisionProfileURL) else {
                return nil
            }
            
            if let entitlements = profile.content["Entitlements"] as? Dictionary<String, Any> {
                for key in entitlements.keys {
                    if key.hasPrefix("com.apple.developer.web-browser") {
                        return url
                    }
                }
            }
            
            return nil
        }
    }
    
    /// Returns a list of all registered browsers capable of being set as a default browser on the system.
    ///
    /// The first browser bundle returned is also the systems current default browser.
    ///
    /// - Returns: Application bundles
    public func bundlesForBrowsers() -> [Bundle] {
        return urlsForBrowsers().compactMap { url in
            return Bundle(url: url)
        }
    }
}
