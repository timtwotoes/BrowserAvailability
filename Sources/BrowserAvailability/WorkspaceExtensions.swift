import AppKit
import UniformTypeIdentifiers
import Security

extension NSWorkspace {
    /// Returns a list of URLs to browsers, capable of being set as the default browser.
    ///
    /// The first url returned, is the current default browser.
    ///
    /// - Returns: URLs to applications.
    public func urlsForBrowsers() -> [URL] {
        return urlsForApplications(toOpen: URL(string: "https:")!).compactMap { (url: URL) -> URL? in
            // Safari in the application folder has no provision profile and
            // receives special attention. It's a shell for the actual application.
            if url.lastPathComponent.lowercased() == "safari.app" {
                return url
            }
            
            let provisionProfileURL = url.appending(component: "Contents/embedded.provisionprofile", directoryHint: .notDirectory)
            
            guard let data = try? Data(contentsOf: provisionProfileURL) else {
                return nil
            }
            
            guard let decodedProfile = try? decode(message: data) else {
                return nil
            }
            
            guard let profile = try? PropertyListSerialization.propertyList(from: decodedProfile, format: nil) as? [String : Any] else {
                return nil
            }
            
            if let entitlements = profile["Entitlements"] as? [String : Any] {
                for key in entitlements.keys {
                    if key.hasPrefix("com.apple.developer.web-browser") {
                        return url
                    }
                }
            }
            
            return nil
        }
    }    
}
