//
//  SignUpView.swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-05-16.
//

import SwiftUI

struct SignUpView: View {
    @State var email: String
    @State var password: String
    
    let onTapAction: (_ email: String, _ password: String) -> Void
    
    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.largeTitle)
            List {
                Section {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)

                    SecureField("Password", text: $password)
                }
                
                Button(action: { onTapAction(email, password) }) {
                    Text("Sign Up")
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(email: "email", password: "password", onTapAction: { email, password in })
    }
}
