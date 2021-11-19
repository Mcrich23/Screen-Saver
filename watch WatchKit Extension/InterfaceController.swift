//
//  InterfaceController.swift
//  watch WatchKit Extension
//
//  Created by Morris Richman on 11/14/21.
//

import WatchKit
import Foundation
import WatchConnectivity
import Firebase


class InterfaceController: WKInterfaceController {
    var code = UserDefaults.standard.string(forKey: "pairingCode")
    let session = WCSession.default
    @IBOutlet weak var pairingCode: WKInterfaceTextField!
    let ref = Database.database().reference()
    @IBOutlet weak var error: WKInterfaceLabel!
    @IBOutlet weak var success: WKInterfaceLabel!
    
    func errorCode(error: String) {
        self.error.setText("Error: \(error)")
        self.error.setHidden(false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.error.setHidden(true)
        }
    }
    
    func startScreenSaver() {
        codeCommit(self)
        print("code.text = \(code)")
        if code == "" {
            errorCode(error: "No pairing code found, please enter one to continue")
        }else {
            ref.child("pairingCodes").child(code ?? "").getData { err, snapshot in
                if err == nil {
                    if snapshot.exists() {
                        print("doc exists")
                        self.ref.child("pairingCodes").child(self.code ?? "").setValue(["ScreenSaver" : true])
                    }else {
                        self.errorCode(error: "Pairing Code Does Not Exist")
                    }
                }else {
                    print("error = \(err)")
                    self.errorCode(error: "Pairing Code Document Does Not Exist")
                }
            }
        }
    }
    @IBAction func codeCommit(_ sender: Any) {
        UserDefaults.standard.set(code, forKey: "pairingCode")
    }
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        FirebaseApp.configure()
        session.delegate = self
        session.activate()
        code = UserDefaults.standard.string(forKey: "pairingCode")
        error.setAlpha(1)
        error.setHidden(true)
        success.setAlpha(1)
        success.setHidden(true)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

    @IBAction func start() {
        print("pairingCode = \(code ?? "")")
        if code == "" {
            startScreenSaver()
        }else {
            errorCode(error: "Error: No pairing code found, please enter a pairing code on your iPhone.")
        }
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
        pairingCode.setText("Pairing Code: \(value)")
    }
  }
}
