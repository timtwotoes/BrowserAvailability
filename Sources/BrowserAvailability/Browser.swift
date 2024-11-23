import AppKit

public struct Browser: Identifiable {
    public let url: URL
    public let name: String
    public let localizedName: String
    public let identifier: String
    public let isSystemDefault: Bool
    public let iconImage: NSImage
    
    public var id: String {
        return isSystemDefault ? identifier + ".default" : identifier
    }
    
    public init(url: URL, name: String, localizedName: String, identifier: String, isSystemDefault: Bool, iconImage: NSImage) {
        self.url = url
        self.name = name
        self.localizedName = localizedName
        self.identifier = identifier
        self.isSystemDefault = isSystemDefault
        self.iconImage = iconImage
    }
    
    public func open(url: URL) {
        self.open(urls: [url])
    }
    
    public func open(urls: [URL]) {
        NSWorkspace.shared.open(urls, withApplicationAt: url, configuration: NSWorkspace.OpenConfiguration())
    }
}

extension Browser: Equatable, Hashable {
    public static func == (lhs: Browser, rhs: Browser) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.isSystemDefault == rhs.isSystemDefault
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        hasher.combine(isSystemDefault)
    }
}
