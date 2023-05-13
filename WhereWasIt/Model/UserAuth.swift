//
//  UserAuth.swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-05-12.
//

import Firebase
import Combine

/* class UserAuth: ObservableObject {
    @Published var user: User?
    @Published var isSignedIn = false
    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // User is signed in
                self.user = user
            } else {
                // User is signed out
                self.user = nil
            }
        }
    }

    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
*/
class UserAuth: ObservableObject {
    private(set) var user: User?
    @Published var isSignedIn: Bool = false

    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error signing in: \(error)")
            } else {
                print("Successfully signed in!")
                self.user = authResult?.user
                self.isSignedIn = true
            }
        }
    }
}

