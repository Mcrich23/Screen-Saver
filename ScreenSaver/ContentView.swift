//
//  ContentView.swift
//  ScreenSaver
//
//  Created by Morris Richman on 11/17/21.
//

import SwiftUI

struct ContentView: View {
    let pairingCode = "Pairing Code \(ScreenSaverApp.pairingCode ?? "")"
    var body: some View {
        VStack {
            Text("Screen Saver")
                .font(.title)
                .padding()
            Text(pairingCode)
        }
        .frame(width: 200, height: 100, alignment: .center)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
