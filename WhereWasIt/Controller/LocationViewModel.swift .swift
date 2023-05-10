//
//  LocationViewModel.swift .swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-05-09.
//

import SwiftUI
import MapKit
import Combine

class LocationViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var searchResults: [Location] = []

    private var searchCancellable: AnyCancellable?

    init() {
        searchCancellable = $searchQuery
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink(receiveValue: { query in
                self.searchLocations(query: query)
            })
    }

    private func searchLocations(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            self.searchResults = response.mapItems.map { mapItem in
                Location(name: mapItem.name ?? "", category: mapItem.pointOfInterestCategory?.rawValue ?? "", coordinate: mapItem.placemark.coordinate)
            }
        }
    }
}
