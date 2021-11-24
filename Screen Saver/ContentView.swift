//
//  ContentView.swift
//  WeatherApp
//
//  Created by Charlie Levine on 3/2/21.
//

import SwiftUI

struct ContentView: View {
    let pairingCode = "Pairing Code: \(AppDelegate.pairingCode ?? "")"
    @State var connection = NetworkMonitor.shared.isConnected
    @State var copied = false
    func checkConnection() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            print("refresh")
            connection = NetworkMonitor.shared.isConnected
            checkConnection()
        }
    }
    func copyCode() {
        print("copy")
        NSPasteboard.general.setString(AppDelegate.pairingCode ?? "", forType: .string)
        copied = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            copied = false
        }
    }
    var body: some View {
        VStack {
            Text("Screen Saver")
                .font(.title)
                .padding()
            HStack {
                Text(pairingCode)
                    .onTapGesture {
                        copyCode()
                    }
                Button {
                    copyCode()
                } label: {
                    if copied {
                        Image(systemName: "checkmark")
                    }else {
                        Image(systemName: "doc.on.clipboard")
                    }
                }
            }
            .frame(height: 25)
            HStack {
                Text("Network Status:")
                if connection {
                    Text("Online")
                        .foregroundColor(.green)
                }else {
                    Text("Offline")
                        .foregroundColor(.red)
                }
            }
            Button {
                NSApp.terminate(self)
            } label: {
                HStack{
                    Image(systemName: "x.circle")
                    Text("Quit Screen Saver")
                }
            }
            Text("Right click to start your screen saver")
                .font(.caption)
                .frame(height: 25)
                .padding(.horizontal)
        }
        .onAppear {
            checkConnection()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
