//
//  MapViewModel.swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-05-16.
//

import CoreLocation
import Firebase
import Foundation

final class MapViewModel: ObservableObject {
    
    @Published private(set) var locations: [Location] = []
    @Published var filters: LocationFilters = LocationFilters()
    @Published var newLocationCoordinate: CLLocationCoordinate2D? = nil
    @Published var selectedCategory: LocationCategory = .all

    @Published var showingDetail: Bool = false
    @Published var centerOnUser: Bool = false
    @Published var showingFilter: Bool = false
    
    @Published var newLocationName: String = ""
    @Published var isPrivate: Bool = false
    @Published var newLocationCategory: LocationCategory = .restaurant
    @Published var newLocationAddress: String = ""
    @Published var firstSeen: Date = Date()
    @Published var lastSeen: Date = Date()


    let user: User?
    private let locationsManager: LocationManager
    private let authManager: AuthenticationManager
    
    init(
        authManager: AuthenticationManager
    ) {
        self.user = authManager.user
        self.locationsManager = LocationManager(user: user)
        self.authManager = authManager
        startObservingLocations()
    }
    
    func handleLocationLongPress(for coordinate: CLLocationCoordinate2D) {
        newLocationCoordinate = coordinate
        showingDetail = true
    }
    
    func presentAddLocation() {
        showingDetail = true
    }
    
    func resetLocation() {
        newLocationCoordinate = nil
        showingDetail = false
    }
    
    func centerUserLocation() {
        centerOnUser = true
    }
    
    func signOut() {
        authManager.signOut()
    }
    
    func presentFilters() {
        filters.applyFilter = true
        showingFilter = true
    }
    
    func addLocation(with coordinate: CLLocationCoordinate2D) {
        guard let user = user else { return }
        
        let location = Location(
            name: newLocationName,
            category: newLocationCategory.rawValue,
            coordinate: coordinate,
            firstSeen: firstSeen,
            lastSeen: lastSeen,
            isPrivate: isPrivate,
            userId: user.uid
        )
        
        locationsManager.addLocation(location, for: user)
        resetSubmissionSheet()
    }
    
    func resetSubmissionSheet() {
        newLocationName = ""
        newLocationCategory = .restaurant
        newLocationAddress = ""
        isPrivate = false
        firstSeen = Date()
        lastSeen = Date()
        newLocationCoordinate = nil
    }
    
    private func startObservingLocations() {
        locationsManager.$allAvailableLocations
            .combineLatest($selectedCategory, $filters)
            .map(filterLocations)
            .receive(on: RunLoop.main)
            .assign(to: &$locations)
    }
    
    private func filterLocations(locations: [Location], selectedCategory: LocationCategory, filters: LocationFilters) -> [Location] {
        guard filters.applyFilter else {
            return locations
        }
        
        var filteredLocations = locations
        
        if selectedCategory != .all {
            filteredLocations = filteredLocations.filter { $0.category == selectedCategory.rawValue }
        }
        
        if filters.applyDateFilter {
            filteredLocations = filteredLocations.filter { $0.firstSeen >= filters.startDate && $0.lastSeen <= filters.endDate }
        }
        
        if filters.applyPrivacyFilter {
            filteredLocations = filteredLocations.filter { $0.isPrivate == filters.isPrivate }
        }
        
        if !filters.name.isEmpty {
            filteredLocations = filteredLocations.filter { $0.name.lowercased().contains(filters.name.lowercased()) }
        }
        
        return filteredLocations
    }
}
