//
//  RootView.swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-05-16.
//

import SwiftUI

struct RootView: View {
    @StateObject var vm = RootViewModel()
    
    var body: some View {
        NavigationView {
            SignInView(authManager: vm.authenticationManager)
                .navigate(using: $vm.shouldDisplayLogin, destination: {
                    AnyView(MapView(authManager: vm.authenticationManager))
                })
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
