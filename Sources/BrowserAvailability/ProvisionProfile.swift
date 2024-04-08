import Foundation
import Security

struct ProvisionProfile {
    let content: [String : Any]
    
    init?(url: URL) {
        var decoder: CMSDecoder?
        CMSDecoderCreate(&decoder)
        guard let decoder else {
            return nil
        }
        
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        
        let contentData = data.withUnsafeBytes { pointer in
            if CMSDecoderUpdateMessage(decoder, pointer.baseAddress!, data.count) != errSecUnknownFormat {
                if CMSDecoderFinalizeMessage(decoder) != errSecUnknownFormat {
                    var content: CFData?
                    if CMSDecoderCopyContent(decoder, &content) != errSecUnknownFormat {
                        return content as Data?
                    }
                }
            }
            return nil
        }
        
        guard let contentData else {
            return nil
        }
        
        if let plist = try? PropertyListSerialization.propertyList(from: contentData, format: nil) as? [String : Any] {
            content = plist
        } else {
            return nil
        }
    }
}
