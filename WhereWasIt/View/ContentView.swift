//
//  ContentView.swift .swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-05-09.
//

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
        @State private var firstSeen: Date = Date()
        @State private var lastSeen: Date = Date()
        @StateObject private var searchCompleter = SearchCompleterViewModel()
        
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
                                    VStack(alignment: .leading) {
                                        TextField("Address", text: $newLocationAddress)
                                        .onChange(of: newLocationAddress) { newValue in
                                            searchCompleter.searchQuery = newValue
                                        }
                                        List(searchCompleter.searchResults, id: \.title) { result in
                                            VStack(alignment: .leading) {
                                                Text(result.title)
                                                Text(result.subtitle)
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                            }
                                            .contentShape(Rectangle()) // This ensures the entire row is tappable, not just the text
                                            .onTapGesture {
                                                newLocationAddress = result.title
                                            }
                                        }


                                    }
                                }
                                DatePicker("First Seen", selection: $firstSeen, displayedComponents: .date)
                                                DatePicker("Last Seen", selection: $lastSeen, displayedComponents: .date)
                            } // End of first section
                            Section {
                                            Button(action: {
                                                if let coordinate = self.newLocationCoordinate {
                                                    locationStore.addLocation(name: self.newLocationName, category: self.newLocationCategory, coordinate: coordinate, firstSeen: self.firstSeen, lastSeen: self.lastSeen)
                                                    self.newLocationName = ""
                                                    self.newLocationCategory = "Restaurant"
                                                } else {
                                                    geocode(address: self.newLocationAddress) { coordinate in
                                                        if let coordinate = coordinate {
                                                            locationStore.addLocation(name: self.newLocationName, category: self.newLocationCategory, coordinate: coordinate, firstSeen: self.firstSeen, lastSeen: self.lastSeen)
                                                            self.newLocationName = ""
                                                            self.newLocationCategory = "Restaurant"
                                                        }
                                                    }
                                                }
                                                self.newLocationAddress = ""
                                                self.searchCompleter.searchResults.removeAll() // Clear search results
                                                self.showingDetail = false
                                            }) {
                                                Text("Add Location")
                                            }

                            } // End of second section
                        } // End of Form
                        .navigationBarTitle("New Location", displayMode: .inline)
                        .navigationBarItems(trailing: Button("Done") {
                            self.showingDetail = false
                            self.newLocationAddress = ""
                            self.searchCompleter.searchResults.removeAll()

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


                                    

                                    //struct ContentView_Previews: PreviewProvider {
                                    //    static var previews: some View {
                                    //        ContentView()
                                    //    }
                                    //}

