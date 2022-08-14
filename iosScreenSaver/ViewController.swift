//
//  ViewController.swift
//  iosScreenSaver
//
//  Created by Morris Richman on 11/14/21.
//

import UIKit
import Firebase
import WatchConnectivity

class ViewController: UIViewController, UITextFieldDelegate {

    let ref = Database.database().reference()
    var session: WCSession?
    @IBOutlet weak var code: UITextField!
    func startScreenSaver() {
        codeCommit(code)
        print("code.text = \(code.text ?? "nil")")
        if code.text == "" {
            errorAlert(error: "No Pairing Code")
        }else {
            ref.child("pairingCodes").child(code.text ?? "").getData { err, snapshot in
                if err == nil {
                    if snapshot.exists() {
                        print("doc exists")
                        self.ref.child("pairingCodes").child(self.code.text ?? "").setValue(["ScreenSaver" : true])
                        let alert = UIAlertController(title: "Success!", message: "Starting your mac's screen saver now. Please make sure Screen Saver Reciever is open and your mac is connected to the internet.", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            print("Dismissed \"starting\" alert")
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }else {
                        self.errorAlert(error: "Pairing Code Does Not Exist")
                    }
                }else {
                    print("error = \(err)")
                    self.errorAlert(error: "Pairing Code Document Does Not Exist")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        code.text = UserDefaults.standard.string(forKey: "pairingCode")
        configureWatchKitSesstion()
        self.code.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func start(_ sender: Any) {
        startScreenSaver()
    }
    
    @IBAction func getSSReciever(_ sender: Any) {
        guard let url = URL(string: "https://mcrich23.com/screen-saver") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func codeCommit(_ sender: Any) {
        print("commit code")
        if let validSession = self.session, validSession.isReachable {//5.1
            let data: [String: Any] = ["pairingCode": "\(code.text ?? "")" as String] // Create your Dictionay as per uses
          validSession.sendMessage(data, replyHandler: nil, errorHandler: nil)
        }
        UserDefaults.standard.set(code.text, forKey: "pairingCode")
    }
    
    func errorAlert(error: String) {
        print("error = \(error)")
        var text = ""
        if error == "" {
            text = "Something went wrong, please double check your pairing code and internet connection"
        }else {
            text = "Something went wrong, please double check your pairing code and internet connection\n\n\(error)"
        }
        let dialogMenu = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .default) { alert in
            print("alert dismissed")
        }
        
        dialogMenu.addAction(ok)
        self.present(dialogMenu, animated: true, completion: nil)
    }

}

// WCSession delegate functions
extension ViewController: WCSessionDelegate {
    
    func configureWatchKitSesstion() {
      
      if WCSession.isSupported() {//4.1
        session = WCSession.default//4.2
        session?.delegate = self//4.3
        session?.activate()//4.4
      }
    }
  
  func sessionDidBecomeInactive(_ session: WCSession) {
  }
  
  func sessionDidDeactivate(_ session: WCSession) {
  }
  
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
  }
  
  func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
    print("received message: \(message)")
    DispatchQueue.main.async { //6
      if let value = message["startScreenSaver"] as? Bool {
          self.startScreenSaver()
      }
        if let value = message["pairingCode"] as? String {//**7.1
            print("code = \(value)")
            UserDefaults.standard.set(value, forKey: "pairingCode")
            self.code.text = value
        }
    }
  }
}
