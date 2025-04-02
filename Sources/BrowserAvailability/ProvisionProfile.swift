import Foundation
import Security

struct ProvisionProfile {
    let content: [String : Any]
    
    init?(url: URL) {
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        
        guard let contentData = try? decode(message: data) else {
            return nil
        }
        
        guard let plist = try? PropertyListSerialization.propertyList(from: contentData, format: nil) as? [String : Any] else {
            return nil
        }
        
        content = plist
    }
}
