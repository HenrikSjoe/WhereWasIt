//
//  WhereWasItApp.swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-04-18.
//

import SwiftUI
import Firebase

@main
struct WhereWasItApp: App {
    @StateObject private var userAuth = UserAuth()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        let locationStore = LocationStore(userAuth: userAuth)
        WindowGroup {
            LoginView()
                .environmentObject(locationStore)
                .environmentObject(userAuth)
        }
    }
}

