//
//  iosScreenSaverApp.swift
//  iosScreenSaver
//
//  Created by Morris Richman on 11/13/21.
//

import SwiftUI
import Firebase

@main
struct iosScreenSaverApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
