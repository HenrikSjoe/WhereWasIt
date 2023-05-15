//
//  WhereWasItApp.swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-04-18.
//



/*import SwiftUI
import Firebase

FirebaseApp.configure()

@main
struct WhereWasItApp: App {
    @StateObject private var userAuth = UserAuth()
    @StateObject private var locationStore = LocationStore(userAuth: userAuth) // Pass the same instance of UserAuth

    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(locationStore)
                .environmentObject(userAuth)
        }
    }
}
 */



import SwiftUI
import Firebase

@main
struct WhereWasItApp: App {
    @StateObject private var userAuth = UserAuth()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        let locationStore = LocationStore(userAuth: userAuth) // Create locationStore here
        WindowGroup {
            LoginView()
                .environmentObject(locationStore)
                .environmentObject(userAuth)
        }
    }
}

