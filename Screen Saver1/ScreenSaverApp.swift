//
//  Screen_Saver1App.swift
//  Screen Saver1
//
//  Created by Morris Richman on 11/17/21.
//

import SwiftUI
import Firebase
import Cocoa

@main
struct ScreenSaverApp: App {
    
    var statusBar: StatusBarController?
    var popover = NSPopover.init()
    static var pairingCode = UserDefaults.standard.string(forKey: "pairingCode")
    init() {
        FirebaseApp.configure()
        setupFirebase()
        let contentView = ContentView()
        popover.contentSize = NSSize(width: 360, height: 360)
        popover.contentViewController = NSHostingController(rootView: contentView)
        statusBar = StatusBarController.init(popover)
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
            ScreenSaverApp.pairingCode = code
            ref.child("pairingCodes").child(code).setValue(["ScreenSaver" : false])
            listen(code: code)
        }else {
            let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            var code = ""
            for _ in 0..<6 {
                code.append(letters.randomElement()!)
            }
            UserDefaults.standard.set(code, forKey: "pairingCode")
            ScreenSaverApp.pairingCode = code
            ref.child("pairingCodes").child(code).setValue(["ScreenSaver" : false])
            listen(code: code)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
