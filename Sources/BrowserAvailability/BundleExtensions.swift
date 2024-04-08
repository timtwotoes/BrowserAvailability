import Foundation

extension Bundle {
    var provisionProfileURL: URL? {
        let fileSystem = FileManager.default
        let contentsURL = bundleURL.appending(path: "Contents", directoryHint: .isDirectory)
        return try? fileSystem.contentsOfDirectory(at: contentsURL, includingPropertiesForKeys: nil).first(where: { url in
            return url.pathExtension == "provisionprofile"
        })
    }
}
