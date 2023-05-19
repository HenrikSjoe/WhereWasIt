//
//  MenuView.swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-05-15.
//

import Firebase
import SwiftUI

struct MenuView: View {
    @Binding var showingDetail: Bool
    @Binding var showingFilter: Bool
    
    let user: User?
    let onTapSignOut: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            Menu {
                Button("About", action: {
                    
                })
                Button("Filter Locations", action: {
                    showingFilter = true
                })
                Button("Feedback/Support", action: {
                    
                })
                
                if user != nil {
                    Button("Add Location", action: {
                        self.showingDetail = true
                    })
                    Button("Sign Out", action: {
                        onTapSignOut()
                    })
                } else {
                    Button("Sign In", action: {()
                    })
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .imageScale(.large)
            }
        }
    }
}
