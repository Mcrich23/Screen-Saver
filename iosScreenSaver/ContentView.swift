//
//  ContentView.swift
//  iosScreenSaver
//
//  Created by Morris Richman on 11/13/21.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct ContentView: View {
    let db = Firestore.firestore()
    @State private var code = UserDefaults.standard.string(forKey: "pairingCode") ?? ""
    func startScreenSaver() {
        print(code)
        db.collection("pairingCodes").document(code).addSnapshotListener { doc, error in
        if error == nil {
            if doc != nil && doc!.exists {
                if let bool = doc!.get("ScreenSaver") as? Bool {
                    print("doc exists")
                }
            }
        }
    }
        db.collection("pairingCodes").document(code).setData(["ScreenSaver" : true])
    }
    var body: some View {
        NavigationView {
            VStack {
                Text("Screen Saver")
                    .font(.title)
                HStack {
                    Text("Pairing Code: ")
                    TextField("Enter Your Pairing Code", text: $code, onCommit: {
                        UserDefaults.standard.set(code, forKey: "pairingCode")
                        print(code)
                    })
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                }
                .padding()
                Button {
                    startScreenSaver()
                } label: {
                    Text("Start Screen Saver")
                }
            }
            .padding()
            .onAppear {
                startScreenSaver()
        }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
