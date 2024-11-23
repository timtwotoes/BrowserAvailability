import AppKit
import UniformTypeIdentifiers
import Security

extension NSWorkspace {
    private func iconURL(from bundle: Bundle) -> URL? {
        guard let iconFilename = bundle.infoDictionary?["CFBundleIconFile"] as? String else {
            return nil
        }
        
        return bundle.url(forResource: iconFilename, withExtension: "icns")
    }
    
    /// Returns a list of all registered browsers along with metadata about the application.
    ///
    /// If appendDefault is true, the default browser will be appended with the default flag set to false.
    /// This allows the user to select the default browser specifically, but not as the default browser.
    ///
    /// - note:The first browser returned is also the systems current default browser.
    ///
    /// - Parameter appendDefault: Appends the default browser as a non-default browser to list
    /// - Returns: List of browsers
    public func allRegisteredBrowsers(appendDefault: Bool = false) -> [Browser] {
        let browserURLs = NSWorkspace.shared.urlsForBrowsers()
        var allBrowsers = [Browser]()

        for (index, url) in browserURLs.enumerated() {
            let isDefault = index == 0
            let resourceKeys: Set<URLResourceKey> = [.nameKey, .localizedNameKey, .effectiveIconKey]

            guard let bundle = Bundle(url: url), let bundleIdentifier = bundle.bundleIdentifier else {
                continue
            }
            
            if let resourceValues = try? url.resourceValues(forKeys: resourceKeys) {
                guard let name = resourceValues.name else {
                    continue
                }
                guard let localizedName = resourceValues.localizedName else {
                    continue
                }
                
                // localizedName from url properties respects user preferences. If the finder shows file extensions
                // it will be reflected in localiizedName. We only want the name itself.
                let formattedName: String
                if localizedName.hasSuffix(".app") {
                    formattedName = String(localizedName[..<localizedName.lastIndex(of: ".")!])
                } else {
                    formattedName = localizedName
                }
                
                guard let iconImage = resourceValues.effectiveIcon as? NSImage else {
                    continue
                }
                
                let browser = Browser(url: url, name: name, localizedName: formattedName, identifier: bundleIdentifier, isSystemDefault: isDefault, iconImage: iconImage)
                allBrowsers.append(browser)
                
                if appendDefault && isDefault {
                    allBrowsers.append(Browser(url: url, name: name, localizedName: formattedName, identifier: bundleIdentifier, isSystemDefault: false, iconImage: iconImage))
                }
            }
        }
                
        return allBrowsers
    }
    
    /// Returns a list of all registered browsers capable of being set as a default browser on the system.
    ///
    /// The first browser url returned is also the systems current default browser.
    ///
    /// - Returns: URLs to application bundles
    public func urlsForBrowsers() -> [URL] {
        return urlsForApplications(toOpen: URL(string: "https:")!).compactMap { (url: URL) -> URL? in
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
