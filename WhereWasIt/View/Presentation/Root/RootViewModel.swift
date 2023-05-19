//
//  RootViewModel.swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-05-16.
//

import Combine
import Foundation

final class RootViewModel: ObservableObject {
    @Published var shouldDisplayLogin: Bool = false
    
    let authenticationManager = AuthenticationManager()
    
    init() {
        startObservingLoginState()
    }
    
    private func startObservingLoginState() {
        authenticationManager.$isAuthenticated
            .receive(on: RunLoop.main)
            .assign(to: &$shouldDisplayLogin)
    }
}
