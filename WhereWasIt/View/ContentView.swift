//
//  ContentView.swift .swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-05-09.
//

import MapKit
import SwiftUI
import MapKit

struct ContentView: View {
    @EnvironmentObject var locationStore: LocationStore
    @State private var newLocationName: String = ""
    @State private var newLocationCategory: String = ""
    
    @State private var centerOnUser: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                MapView(centerOnUser: $centerOnUser)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack {
                            Button(action: {
                                // Add your functionality for adding to Firebase here
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 25))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Circle())
                            }
                            
                            Button(action: {
                                centerOnUser = true
                            }) {
                                Image(systemName: "location.fill")
                                    .font(.system(size: 25))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.trailing)
                    }
                }
            }
            .navigationBarTitle("Where was it", displayMode: .inline)
        }
    }
}

