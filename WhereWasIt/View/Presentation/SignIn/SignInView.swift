//
//  SignInView.swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-05-16.
//

import SwiftUI

struct SignInView: View {
    @StateObject private var vm: SignInViewModel
    
    init(
        authManager: AuthenticationManager
    ) {
        _vm = StateObject(wrappedValue: SignInViewModel(autheticationManager: authManager))
    }
    
    var body: some View {
        VStack {
            Text("Sign In")
                .font(.largeTitle)
            List {
                Section {
                    TextField("Email", text: $vm.email)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Password", text: $vm.password)
                }
                
                Group {
                    Button(action: vm.signIn) {
                        Text("Sign In")
                    }
                    .buttonStyle(CapsuleButtonStyle(colorStyle: .custom(textColor: .white, backgroundColor: .blue)))
                    
                    Button(action: vm.presentSignUp) {
                        Text("Sign Up")
                    }
                    .buttonStyle(CapsuleButtonStyle(colorStyle: .custom(textColor: .white, backgroundColor: .blue.opacity(0.4))))
                }
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 8, leading: 0, bottom: 8, trailing: 0))
                .listRowSeparator(.hidden)
                
            }
            .listStyle(InsetGroupedListStyle())
            .scrollContentBackground(.hidden)
            
            Spacer()
            
            Button(action: { vm.browseTheMap = true }) {
                Text("I just want to browse the map")
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .buttonStyle(CapsuleButtonStyle(colorStyle: .custom(textColor: .white, backgroundColor: .black)))
        }
        .background(LinearGradient(colors: [Color.gray.opacity(0.5), .white], startPoint: .top, endPoint: .bottom))
        .sheet(isPresented: $vm.showSignUp) {
            SignUpView(email: vm.email, password: vm.password) { email, password in
                vm.createUser(with: email, password: password)
            }
        }
        .onAppear(perform: vm.resetTextFields)
        .navigate(using: $vm.browseTheMap, destination: { AnyView(MapView(authManager: vm.authenticationManager)) })
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(authManager: AuthenticationManager())
    }
}
