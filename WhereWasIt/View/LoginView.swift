//
//  LoginView.swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-05-11.
//

import SwiftUI
import FirebaseAuth

struct NavigationHandler: ViewModifier {
    @Binding var value: Bool
    let destination: () -> AnyView
    
    func body(content: Content) -> some View {
        Group {
            if value {
                destination()
            } else {
                content
            }
        }
    }
}

extension View {
    func navigate(using state: Binding<Bool>, destination: @escaping () -> AnyView) -> some View {
        self.modifier(NavigationHandler(value: state, destination: destination))
    }
}

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var showSignUp: Bool = false
    @State private var browseTheMap: Bool = false
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var locationStore: LocationStore
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Sign In")
                    .font(.largeTitle)
                List {
                    Section {
                        TextField("Email", text: $email)
                        SecureField("Password", text: $password)
                    }
                    Button(action: signIn) {
                        Text("Sign In")
                    }
                    .sheet(isPresented: $showSignUp) {
                        SignUpView().environmentObject(userAuth)
                    }
                    Button(action: { self.browseTheMap = true }) {
                        Text("I just want to browse the map")
                    }
                    .fullScreenCover(isPresented: $browseTheMap, content: {
                        ContentView().environmentObject(userAuth).environmentObject(locationStore)
                    })
                    
                    Button(action: { self.showSignUp = true }) {
                        Text("Sign Up")
                    }
                }
                .listStyle(InsetGroupedListStyle())
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            .navigate(using: $userAuth.isSignedIn, destination: {
                AnyView(ContentView().environmentObject(userAuth).environmentObject(locationStore))
            })
        }
    }
    
    private func signIn() {
        userAuth.signIn(email: email, password: password)
    }
}

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @EnvironmentObject var userAuth: UserAuth
    
    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.largeTitle)
            List {
                Section {
                    TextField("Email", text: $email)
                    SecureField("Password", text: $password)
                }
                Button(action: signUp) {
                    Text("Sign Up")
                }
            }
            .listStyle(InsetGroupedListStyle())
            Text(errorMessage)
                .foregroundColor(.red)
        }
    }
    
    private func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error signing up: \(error)")
                errorMessage = error.localizedDescription
            } else {
                print("Successfully signed up!")
                errorMessage = ""
                userAuth.isSignedIn = true
                userAuth.userId = authResult?.user.uid ?? ""
            }
        }
    }
    
    
}
