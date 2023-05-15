//
//  MenuView.swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-05-15.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var userAuth: UserAuth
    @Binding var showingDetail: Bool
    @Binding var showingFilter: Bool
    
    var body: some View {
        HStack {
            Spacer()
            if userAuth.isSignedIn {
                Menu {
                    Button("About", action: {
                        
                    })
                    Button("Feedback/Support", action: {
                        
                    })
                    Button("Filter Locations", action: {
                        showingFilter = true
                    })
                    Button("Add Location", action: {
                        self.showingDetail = true
                    })
                    Button("Sign Out", action: {
                        userAuth.signOut()
                    })
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .imageScale(.large)
                }
            } else {
                Menu {
                    Button("About", action: {
                        
                    })
                    Button("Filter Locations", action: {
                        showingFilter = true
                    })
                    Button("Sign In", action: {
                        
                    })
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .imageScale(.large)
                }
            }
        }
    }
}
