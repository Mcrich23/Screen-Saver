//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Charlie Levine on 3/2/21.
//

import Cocoa
import SwiftUI
import Firebase
import FirebaseFirestore

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusBar: StatusBarController?
    var popover = NSPopover.init()
    static var pairingCode = UserDefaults.standard.string(forKey: "pairingCode")

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        FirebaseApp.configure()
        setupFirebase()
        let contentView = ContentView()
        popover.contentSize = NSSize(width: 360, height: 360)
        popover.contentViewController = NSHostingController(rootView: contentView)
        statusBar = StatusBarController.init(popover)
    }
    func setupFirebase() {
        let db = Firestore.firestore()
        func listen(code: String) {
            db.collection("pairingCodes").document(code).addSnapshotListener { doc, error in
                if error == nil {
                    if doc != nil && doc!.exists {
                        if let bool = doc!.get("ScreenSaver") as? Bool {
                            if bool {
                                db.collection("pairingCodes").document(code).setData(["ScreenSaver" : false])
                                let url = NSURL(fileURLWithPath: "/System/Library/CoreServices/ScreenSaverEngine.app", isDirectory: true) as URL
                                let path = "/bin"
                                let configuration = NSWorkspace.OpenConfiguration()
                                configuration.arguments = [path]
                                NSWorkspace.shared.openApplication(at: url,
                                                                   configuration: configuration,
                                                                   completionHandler: nil)
                            }
                        }
                    }
                }
            }
        }
        if let code = UserDefaults.standard.string(forKey: "pairingCode") {
            AppDelegate.pairingCode = code
            db.collection("pairingCodes").document(code).setData(["ScreenSaver" : false])
            listen(code: code)
        }else {
            let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            var code = ""
            for _ in 0..<6 {
                code.append(letters.randomElement()!)
            }
            UserDefaults.standard.set(code, forKey: "pairingCode")
            AppDelegate.pairingCode = code
            db.collection("pairingCodes").document(code).setData(["ScreenSaver" : false])
            listen(code: code)
        }
    }
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
