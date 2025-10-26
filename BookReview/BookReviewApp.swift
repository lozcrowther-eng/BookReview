//
//  BookReviewApp.swift
//  BookReview
//
//  Created by Lawrence Crowther on 25/10/2025.
//

import SwiftUI

@main
struct BookReviewApp: App {
    init() {
        setupEligibilityPlistIfNeeded()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    /// Create a minimal eligibility plist inside the app sandbox at
    /// <AppHome>/private/var/db/eligibilityd/eligibility.plist if it doesn't exist.
    /// This avoids repeated "Failed to open ... eligibility.plist: No such file or directory" log messages
    /// coming from system daemons when running in the Simulator.
    private func setupEligibilityPlistIfNeeded() {
        let fileManager = FileManager.default
        // NSHomeDirectory() points to the current app container when running in the simulator or device.
        let appHome = URL(fileURLWithPath: NSHomeDirectory())
        let eligibilityDir = appHome.appendingPathComponent("private/var/db/eligibilityd")
        let plistURL = eligibilityDir.appendingPathComponent("eligibility.plist")

        do {
            if !fileManager.fileExists(atPath: eligibilityDir.path) {
                try fileManager.createDirectory(at: eligibilityDir, withIntermediateDirectories: true, attributes: [FileAttributeKey.posixPermissions: 0o755])
            }

            if !fileManager.fileExists(atPath: plistURL.path) {
                // Write a minimal plist that includes the GREYMATTER domain key to silence "missing from plist" logs.
                let initial: [String: Any] = [
                    "OS_ELIGIBILITY_DOMAIN_GREYMATTER": [:]
                ]
                let data = try PropertyListSerialization.data(fromPropertyList: initial, format: .xml, options: 0)
                try data.write(to: plistURL, options: .atomic)
                #if DEBUG
                print("Created placeholder eligibility plist at: \(plistURL.path)")
                #endif
            }
        } catch {
            #if DEBUG
            print("Failed to create eligibility plist: \(error)")
            #endif
        }
    }
}
