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

class LocationStore: ObservableObject {
    private let db = Firestore.firestore()
    private let locationCollection = "locations"

    @Published var locations = [Location]()

    init() {
        fetchLocations()
    }

    private func fetchLocations() {
        db.collection(locationCollection).addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error fetching locations: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents found.")
                return
            }
            
            self.locations = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: Location.self)
            }
        }
    }

    func addLocation(name: String, category: String, coordinate: CLLocationCoordinate2D, firstSeen: Date, lastSeen: Date) {
        let newLocation = Location(id: UUID().uuidString, name: name, category: category, coordinate: coordinate, firstSeen: firstSeen, lastSeen: lastSeen)

        do {
            try db.collection(locationCollection).document(newLocation.id).setData(from: newLocation)
        } catch {
            print("Error adding location: \(error)")
        }
    }

    func deleteLocation(location: Location) {
        db.collection(locationCollection).document(location.id).delete { error in
            if let error = error {
                print("Error deleting location: \(error)")
            } else {
                print("Location deleted successfully!")
            }
        }
    }
}
