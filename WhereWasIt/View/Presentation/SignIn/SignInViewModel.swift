//
//  SignInViewModel.swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-05-16.
//

import Combine
import Foundation

final class SignInViewModel: ObservableObject {
    
    @Published var showSignUp: Bool = false
    @Published var browseTheMap: Bool = false 
    @Published var email: String = ""
    @Published var password: String = ""
    
    let authenticationManager: AuthenticationManager
    
    init(autheticationManager: AuthenticationManager) {
        self.authenticationManager = autheticationManager
    }
    
    func signIn() {
        authenticationManager.signIn(with: email, password: password)
    }
    
    func createUser(with email: String, password: String) {
        authenticationManager.signUp(with: email, password: password)
    }
    
    func presentSignUp() {
        showSignUp = true
    }
    
    func resetTextFields() {
        email = ""
        password = ""
    }
}
