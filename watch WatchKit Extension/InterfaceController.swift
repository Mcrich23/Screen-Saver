//
//  InterfaceController.swift
//  watch WatchKit Extension
//
//  Created by Morris Richman on 11/14/21.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController {
    var code = UserDefaults.standard.string(forKey: "pairingCode")
    let session = WCSession.default
    
    @IBOutlet weak var error: WKInterfaceLabel!
    @IBOutlet weak var pairingCode: WKInterfaceLabel!
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        session.delegate = self
        session.activate()
        code = UserDefaults.standard.string(forKey: "pairingCode")
        error.setAlpha(0)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

    @IBAction func start() {
        print("pairingCode = \(pairingCode)")
//        if pairingCode == "" {
            session.sendMessage(["startScreenSaver" : true], replyHandler: nil, errorHandler: nil)
//        }else {
//            error.setAlpha(1)
//        }
    }
}
extension InterfaceController: WCSessionDelegate {
  
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
  }
  
  func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
    
    print("received data: \(message)")
    if let value = message["pairingCode"] as? String {//**7.1
        UserDefaults.standard.set(value, forKey: "pairingCode")
        code = value
    }
  }
}
