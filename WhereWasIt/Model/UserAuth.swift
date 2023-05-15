//
//  UserAuth.swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-05-12.
//

import Firebase
import Combine

class UserAuth: ObservableObject {
    @Published private(set) var user: User?
    @Published var isSignedIn: Bool = false
    @Published var userId: String = ""
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error signing in: \(error)")
            } else {
                print("Successfully signed in!")
                self.user = authResult?.user
                self.isSignedIn = true
                self.userId = authResult?.user.uid ?? ""
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isSignedIn = false
            self.user = nil
            self.userId = ""
        } catch {
            print("Error signing out: \(error)")
        }
    }
}
