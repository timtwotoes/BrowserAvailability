import Foundation
import Security

/// Decode data encoded with CryptographicMessageSyntax wholesale
func decode(message: Data) throws (CryptographicMessageSyntaxError) -> Data? {
    // Core Foundation types is managed by Swift Runtime
    var decoder: CMSDecoder?
    var errorCode: OSStatus = errSecSuccess
    
    errorCode = CMSDecoderCreate(&decoder)
    
    guard errorCode == errSecSuccess else {
        throw CryptographicMessageSyntaxError(code: errorCode)
    }
    
    // Read complete message into decoder
    let error = message.withUnsafeBytes { data in
        let errorCode = CMSDecoderUpdateMessage(decoder!, data.baseAddress!, message.count)
            
        guard errorCode == errSecSuccess else {
            return Optional(CryptographicMessageSyntaxError(code: errorCode))
        }
        return nil
    }
    
    if let error {
        throw error
    }
    
    // Decode message
    errorCode = CMSDecoderFinalizeMessage(decoder!)
    
    guard errorCode == errSecSuccess else {
        throw CryptographicMessageSyntaxError(code: errorCode)
    }
    
    // Extract decoded data from decoder
    var content: CFData?
    
    errorCode = CMSDecoderCopyContent(decoder!, &content)
    
    guard errorCode == errSecSuccess else {
        throw CryptographicMessageSyntaxError(code: errorCode)
    }
    
    // No error means data was decoded
    return content! as Data
}

/// Wraps security error and returns a human readable error message.
struct CryptographicMessageSyntaxError: Error {
    private let message: String
    
    init(code: Int32) {
        
        guard let errorMessage = SecCopyErrorMessageString(code, nil) as? String else {
            fatalError("Could not translate security error code \(code) to a human readable description.")
        }
        message = errorMessage
    }
    
    /// Human readable security error description.
    var description: String {
        return message
    }
}
