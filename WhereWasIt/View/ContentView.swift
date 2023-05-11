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
    @State private var newLocationCategory: String = "Restaurant"
    @State private var newLocationAddress: String = ""
    @State private var showingDetail = false
    @State private var centerOnUser: Bool = false
    @State private var newLocationCoordinate: CLLocationCoordinate2D? = nil
    
    let categories = ["Restaurant", "Bar", "Nightclub", "Store", "Other"]
    
    let geocoder = CLGeocoder()
    
    var body: some View {
        NavigationView {
            ZStack {
                MapView(centerOnUser: $centerOnUser, onLongPress: { coordinate in
                    self.newLocationCoordinate = coordinate
                    self.showingDetail = true
                })
                .edgesIgnoringSafeArea(.all)
                .sheet(isPresented: $showingDetail) {
                    NavigationView {
                        Form {
                            Section(header: Text("Location Details")) {
                                TextField("Name", text: $newLocationName)
                                Picker("Category", selection: $newLocationCategory) {
                                    ForEach(categories, id: \.self) {
                                        Text($0)
                                    }
                                }
                                if newLocationCoordinate == nil {
                                    TextField("Address", text: $newLocationAddress)
                                }
                            }
                            
                            Section {
                                Button(action: {
                                    if let coordinate = self.newLocationCoordinate {
                                        locationStore.addLocation(name: self.newLocationName, category: self.newLocationCategory, coordinate: coordinate)
                                        self.newLocationName = ""
                                        self.newLocationCategory = "Restaurant"
                                    } else {
                                        geocode(address: self.newLocationAddress) { coordinate in
                                            if let coordinate = coordinate {
                                                locationStore.addLocation(name: self.newLocationName, category: self.newLocationCategory, coordinate: coordinate)
                                                self.newLocationName = ""
                                                self.newLocationCategory = "Restaurant"
                                            }
                                        }
                                    }
                                    self.showingDetail = false
                                }) {
                                    Text("Add Location")
                                }
                            }
                        }
                        .navigationBarTitle("New Location", displayMode: .inline)
                        .navigationBarItems(trailing: Button("Done") {
                            self.showingDetail = false
                        })
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack {
                            Button(action: {
                                self.newLocationCoordinate = nil
                                self.showingDetail = true
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
    
    func geocode(address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        geocoder.geocodeAddressString(address) { placemarks, error in
            guard let placemark = placemarks?.first, let location = placemark.location else {
                print("No location found for this address.")
                completion(nil)
                return
            }
            completion(location.coordinate)
        }
    }
}

