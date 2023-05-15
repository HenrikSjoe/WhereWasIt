//
//  LocationStore.swift .swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-05-09.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreLocation
import Combine

class LocationStore: ObservableObject {
    @Published var userAuth: UserAuth
    var mapView: MapView?
    private let db = Firestore.firestore()
    private let locationCollection = "locations"
    private let publicLocationCollection = "publicLocations"
    private let userCollection = "users"
    @Published var publicLocations: [Location] = []
    @Published var privateLocations: [Location] = []
    @Published var locations: [Location] = []
    @Published var filteredLocations: [Location] = []
    @Published var filters: LocationFilters = LocationFilters() {
            didSet {
                self.filteredLocations = filterLocations(filters: self.filters)
            }
        }
    
    
    let categories: [String] = ["Restaurant", "Bar", "Nightclub", "Store", "Other"]
    private var cancellables: Set<AnyCancellable> = []
    
    init(userAuth: UserAuth) {
        self.userAuth = userAuth
        self.userAuth.$user.sink { [weak self] user in
            self?.fetchLocations()
        }.store(in: &cancellables)
    }
    
    
    
    private func fetchLocations() {
        db.collection(publicLocationCollection).addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error fetching public locations: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            self.publicLocations = documents.compactMap { try? $0.data(as: Location.self) }
            self.updateLocations()
        }
        
        if let user = userAuth.user {
            db.collection(userCollection).document(user.uid).collection(locationCollection).addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching private locations: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                self.privateLocations = documents.compactMap { try? $0.data(as: Location.self) }
                self.updateLocations()
            }
        }
    }
    
    private func updateLocations() {
        self.locations = publicLocations + privateLocations
    }
    
    
    func addLocation(name: String, category: String, coordinate: CLLocationCoordinate2D, firstSeen: Date, lastSeen: Date, isPrivate: Bool) {
        guard let userId = userAuth.user?.uid else { return }
        let newLocation = Location(name: name, category: category, coordinate: coordinate, firstSeen: firstSeen, lastSeen: lastSeen, isPrivate: isPrivate, userId: userId)
        
        do {
            if isPrivate {
                let _ = try db.collection(userCollection).document(userId).collection(locationCollection).addDocument(from: newLocation)
            } else {
                let _ = try db.collection(publicLocationCollection).addDocument(from: newLocation)
            }
            fetchLocations()
        } catch {
            print("There was an error while trying to save a location \(error.localizedDescription).")
        }
    }
    
    func filterLocations(filters: LocationFilters) -> [Location] {
        if !filters.applyFilter {
            return locations
        }
        
        var filteredLocations = locations
        
        if filters.applyCategoryFilter && !filters.category.isEmpty {
            filteredLocations = filteredLocations.filter { $0.category == filters.category }
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
