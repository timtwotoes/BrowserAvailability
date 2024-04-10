# Browser Availability

Detect available browsers on macOS and which is the default.

## Usage

Example showing how to get all browser URLs.

```swift
import BrowserAvailability

let urls = NSWorkspace.shared.urlsForBrowsers()
```

Example showing how to get all browser bundles.

```swift
import BrowserAvailability

let bundles = NSWorkspace.shared.bundlesForBrowsers()
```

The first url in the array, is the url to the currently registered default browser on the system.

## Requirements

macOS 13 (Ventura)

## Resources
[Requirements for an application to become a default browser](https://developer.apple.com/documentation/xcode/preparing-your-app-to-be-the-default-browser)

Apple's requirements to become a default browser.

[Cryptographically sign and encrypt S/MIME messages](https://developer.apple.com/documentation/security/cryptographic_message_syntax_services)

Apple's documentation for encoding and decoding CMS. Application entitlements is encrypted using CMS.

[Repository using Apple's CMS decoder](https://github.com/jamf/PPPC-Utility/blob/master/External/SwiftyCMSDecoder.swift)

An example using CMS decoder in swift.

[Debugging entitlements on macOS](https://developer.apple.com/documentation/bundleresources/entitlements/diagnosing_issues_with_entitlements)

Describes how to decode entitlements using commandline tools on macOS.

[Uniform Type Identifiers - a reintroduction](https://developer.apple.com/videos/play/tech-talks/10696) - [Transcript](/Resources/tech-talks-10696.txt)

A tech talk (video) that describes how Uniform Type Identifiers work on Apple platforms. Included a transcript for posterity.

[Uniform Type Identifiers documentation](https://developer.apple.com/documentation/uniformtypeidentifiers)

Apple's documentation for uniform type identifiers.

[Unsafe Swift](https://developer.apple.com/videos/play/wwdc2020/10648)

Working with Swift and C API's.

[Safely manage pointers in Swift](https://developer.apple.com/videos/play/wwdc2020/10167)

How to work with managed pointers in Swift.
