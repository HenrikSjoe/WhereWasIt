//
//  MapView.swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-05-16.
//

import CoreLocation
import Firebase
import SwiftUI

struct MapView: View {
    
    @StateObject private var vm: MapViewModel
    @StateObject private var searchCompleter = SearchCompleterViewModel()
    @Environment(\.presentationMode) var presentationMode

    let geocoder = CLGeocoder()

    init(
        authManager: AuthenticationManager
    ) {
        _vm = StateObject(wrappedValue: MapViewModel(authManager: authManager))
    }
    
    var body: some View {
        MapViewRepresentable(
            centerOnUser: $vm.centerOnUser,
            locations: vm.locations,
            user: vm.user,
            onLongPress: { coordinate in vm.handleLocationLongPress(for: coordinate) }
        )
        .edgesIgnoringSafeArea(.all)
        .overlay(alignment: .bottomTrailing) { bottomTrailingOverlay }
        .sheet(isPresented: $vm.showingFilter) { FilterView(filters: $vm.filters, selectedCategory: $vm.selectedCategory) }
        .sheet(isPresented: $vm.showingDetail) { addLocationSheet }
        .navigationBarTitle("Where Was It", displayMode: .inline)
        .navigationBarItems(trailing: topMenu)
        .toolbarBackground(.thinMaterial, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
    
    private var topMenu: some View {
        MenuView(
            showingDetail: .constant(true),
            showingFilter: $vm.showingFilter,
            user: vm.user,
            onTapSignOut: vm.signOut
        )
        .padding([.bottom, .trailing], 16)
    }
    
    private var bottomTrailingOverlay: some View {
        VStack {
            if vm.user != nil {
                Button(action: {
                    vm.presentAddLocation()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                }
            }
            
            Button(action: {
                vm.centerUserLocation()
            }) {
                Image(systemName: "location.fill")
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            }
        }
        .padding(.trailing, 16)
    }
    
    private var addLocationSheet: some View {
        Form {
            Section(header: Text("Location Details")) {
                TextField("Name", text: $vm.newLocationName)
                Toggle(isOn: $vm.isPrivate) {
                    Text("Private Location")
                }
                Picker("Category", selection: $vm.newLocationCategory) {
                    ForEach(LocationCategory.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                if vm.newLocationCoordinate == nil {
                    VStack(alignment: .leading) {
                        TextField("Address", text: $vm.newLocationAddress)
                            .onChange(of: vm.newLocationAddress) { newValue in
                                searchCompleter.searchQuery = newValue
                            }
                        List(searchCompleter.searchResults, id: \.title) { result in
                            VStack(alignment: .leading) {
                                Text(result.title)
                                Text(result.subtitle)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                vm.newLocationAddress = result.title
                            }
                        }
                    }
                }
                DatePicker("First Seen", selection: $vm.firstSeen, displayedComponents: .date)
                DatePicker("Last Seen", selection: $vm.lastSeen, displayedComponents: .date)
            }
            Section {
                Button(action: {
                    if let coordinate = vm.newLocationCoordinate {
                        vm.addLocation(with: coordinate)
                    } else {
                        geocode(address: vm.newLocationAddress) { coordinate in
                            if let coordinate = coordinate {
                                vm.addLocation(with: coordinate)
                            }
                        }
                        
                    }
                    self.searchCompleter.searchResults.removeAll()
                    vm.showingDetail = false
                }) {
                    Text("Add Location")
                }
            }
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

struct NewMapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(authManager: AuthenticationManager())
    }
}
