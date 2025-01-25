//
//  SennaApp.swift
//  Senna
//
//  Created by Jason Zhu on 1/22/25.
//

import SwiftUI
import FirebaseCore

@main
struct SennaApp: App {
    @StateObject private var authManager = AuthenticationManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
        }
    }
}
