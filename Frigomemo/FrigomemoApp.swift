//
//  FrigomemoApp.swift
//  Frigomemo
//
//  Created by Yihan Wang on 11/8/23.
//

import SwiftUI
import FirebaseCore

@main
struct FrigomemoApp: App {
    @StateObject private var authManager = AuthenticationManager()
    @StateObject private var store = FoodItemStore()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if authManager.isAuthenticated {
                ContentView(store: store, authManager: authManager)
                    .onAppear {
                        store.startListening()
                    }
                    .onDisappear {
                        store.stopListening()
                    }
            } else {
                LoginView(authManager: authManager)
                    .onAppear {
                        store.stopListening()
                    }
            }
        }
    }
}
