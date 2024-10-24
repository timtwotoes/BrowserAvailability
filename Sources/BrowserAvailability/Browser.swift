import AppKit

public struct Browser: Identifiable, Hashable {
    public let id: Int
    public let url: URL
    public let name: String
    public let localizedName: String
    public let identifier: String
    public let isSystemDefault: Bool
    public let iconURL: URL
    
    public init(id: Int, url: URL, name: String, localizedName: String, identifier: String, isSystemDefault: Bool, iconURL: URL) {
        self.id = id
        self.url = url
        self.name = name
        self.localizedName = localizedName
        self.identifier = identifier
        self.isSystemDefault = isSystemDefault
        self.iconURL = iconURL
    }
    
    public func open(url: URL) {
        self.open(urls: [url])
    }
    
    public func open(urls: [URL]) {
        NSWorkspace.shared.open(urls, withApplicationAt: url, configuration: NSWorkspace.OpenConfiguration())
    }
}

extension Browser: Equatable {
    public static func == (lhs: Browser, rhs: Browser) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
