//
//  ContentView.swift
//  WeatherApp
//
//  Created by Charlie Levine on 3/2/21.
//

import SwiftUI

struct ContentView: View {
    let pairingCode = "Pairing Code \(AppDelegate.pairingCode ?? "")"
    var body: some View {
        VStack {
            Text("Screen Saver")
                .font(.title)
                .padding()
            Text(pairingCode)
            Text("Right click to view this message again")
                .font(.caption)
                .frame(height: 25)
                .padding(.horizontal)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
