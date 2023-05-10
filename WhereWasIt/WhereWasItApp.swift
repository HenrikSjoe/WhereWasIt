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
    @StateObject private var locationStore = LocationStore()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationStore)
        }
    }
}


