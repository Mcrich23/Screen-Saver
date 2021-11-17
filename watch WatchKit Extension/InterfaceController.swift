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
//    let db = Firestore.firestore()
    @IBOutlet weak var error: WKInterfaceLabel!
    
    func errorCode(error: String) {
        self.error.setText("Error: \(error)")
        self.error.setAlpha(1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.error.setAlpha(0)
        }
    }
    
    func startScreenSaver() {
        codeCommit(self)
        print("code.text = \(code)")
        if code == "" {
            errorCode(error: "No pairing code found, please enter one to continue")
        }else {
//            db.collection("pairingCodes").document(code ?? "").addSnapshotListener { doc, error in
//            if error == nil {
//                if doc != nil && doc!.exists {
//                    if (doc!.get("ScreenSaver") as? Bool) != nil {
//                        print("doc exists")
//                        self.db.collection("pairingCodes").document(self.code ?? "").setData(["ScreenSaver" : true])
//                    }else {
//                        self.errorCode(error: "Pairing Code Does Not Exist")
//                    }
//                }else {
//                    self.errorCode(error: "Pairing Code Does Not Exist")
//                }
//            }else {
//                self.errorCode(error: "Document Collection Does Not Exist")
//            }
//        }
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
        error.setAlpha(0)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

    @IBAction func start() {
        print("pairingCode = \(code ?? "")")
        if code == "" {
            startScreenSaver()
        }else {
            self.error.setText("Error: No pairing code found, please enter a pairing code on your iPhone.")
            error.setAlpha(1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.error.setAlpha(0)
            }
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
