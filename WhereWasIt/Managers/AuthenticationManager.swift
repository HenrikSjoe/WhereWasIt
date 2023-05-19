//
//  AuthenticationManager.swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-05-16.
//

import Combine
import Firebase
import Foundation

final class AuthenticationManager: ObservableObject {
    @Published private(set) var user: User?
    @Published private(set) var isAuthenticated: Bool = false
    
    init() {
        retriveCurrentUser()
        startObservingUser()
    }
    
    func signIn(with email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard error == nil else {
                print("Error fetching user. Error: \(String(describing: error?.localizedDescription))")
                return
            }
            
            self?.user = authResult?.user
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch {
            print("Error signing out: \(error)")
        }
    }
    
    func signUp(with email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard error == nil else {
                print("Error creating user.")
                return
            }
            
            self?.user = authResult?.user
        }
    }
    
    private func retriveCurrentUser() {
        user = Auth.auth().currentUser
    }
    
    private func startObservingUser() {
        $user
            .map { $0 != nil }
            .receive(on: RunLoop.main)
            .assign(to: &$isAuthenticated)
    }
}
