//
//  LocationManager.swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-05-16.
//

import Combine
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

final class LocationManager: ObservableObject {
    @Published private(set) var allAvailableLocations: [Location] = []
    @Published private(set) var publicLocations: [Location] = []
    @Published private(set) var userLocations: [Location] = []
    
    private let db = Firestore.firestore()
    private let user: User?
    
    private let userLocationCollection = "locations"
    private let publicLocationCollection = "publicLocations"
    private let userCollection = "users"
    
    init(
        user: User? = nil
    ) {
        self.user = user
        fetchPublicLocations()
        fetchUserLocations()
        startObservingLocations()
    }
    
    func addLocation(_ location: Location, for user: User) {        
        do {
            if location.isPrivate {
                let _ = try db.collection(userCollection).document(user.uid).collection(userLocationCollection).addDocument(from: location)
            } else {
                let _ = try db.collection(publicLocationCollection).addDocument(from: location)
            }
        } catch {
            print("There was an error while trying to save a location \(error.localizedDescription).")
        }
    }
    
    func updateLocation(_ location: Location) {
        
    }
    
    func deleteLocation(_ location: Location) {
        
    }
    
    private func fetchPublicLocations() {
        db.collection(publicLocationCollection).addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error fetching public locations: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            let locations = documents.compactMap { try? $0.data(as: Location.self) }
            self.publicLocations = locations
        }
    }
    
    private func fetchUserLocations() {
        guard let user = user else { return }
        
        db.collection(userCollection).document(user.uid).collection(userLocationCollection).addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error fetching private locations: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            let locations = documents.compactMap { try? $0.data(as: Location.self) }
            self.userLocations = locations
        }
    }
    
    private func startObservingLocations() {
        $publicLocations
            .combineLatest($userLocations)
            .map(+)
            .receive(on: RunLoop.main)
            .assign(to: &$allAvailableLocations)
    }
}
