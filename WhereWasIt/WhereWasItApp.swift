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
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

