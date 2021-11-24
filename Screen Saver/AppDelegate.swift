//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Charlie Levine on 3/2/21.
//

import Cocoa
import SwiftUI
import Firebase

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusBar: StatusBarController?
    var window: NSWindow!
    var popover = NSPopover.init()
    static var pairingCode = UserDefaults.standard.string(forKey: "pairingCode")
    static var hasOpened = UserDefaults.standard.bool(forKey: "hasOpened")

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("hasOppened = \(AppDelegate.hasOpened)")
        NetworkMonitor.shared.startMonitoring()
        FirebaseApp.configure()
        setupFirebase()
        let contentView = ContentView()
        popover.contentSize = NSSize(width: 360, height: 360)
        popover.contentViewController = NSHostingController(rootView: contentView)
        statusBar = StatusBarController.init(popover)
        NSPasteboard.general.declareTypes([.string], owner: nil)
    }
    func setupFirebase() {
        let ref = Database.database().reference()
        func listen(code: String) {
            ref.child("pairingCodes").child(code).observe(.value) { snapshot in
                let value = snapshot.value as? NSDictionary
                if value!["ScreenSaver"] as! Bool {
                    print("Start Screen Saver")
                    ref.child("pairingCodes").child(code).setValue(["ScreenSaver" : false])
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
        if let code = UserDefaults.standard.string(forKey: "pairingCode") {
            AppDelegate.pairingCode = code
            ref.child("pairingCodes").child(code).setValue(["ScreenSaver" : false])
            listen(code: code)
        }else {
            let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            var code = ""
            for _ in 0..<6 {
                code.append(letters.randomElement()!)
            }
            UserDefaults.standard.set(code, forKey: "pairingCode")
            AppDelegate.pairingCode = code
            ref.child("pairingCodes").child(code).setValue(["ScreenSaver" : false])
            listen(code: code)
        }
    }
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
