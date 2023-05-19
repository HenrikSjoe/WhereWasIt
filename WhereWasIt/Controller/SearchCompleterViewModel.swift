//
//  SearchCompleterViewModel.swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-05-11.
//

import MapKit
import Combine

class SearchCompleterViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    
    @Published var searchQuery = ""
    @Published var searchResults: [MKLocalSearchCompletion] = []
    
    private var cancellable: AnyCancellable?
    private var searchCompleter: MKLocalSearchCompleter!
    
    override init() {
        super.init()
        self.searchCompleter = MKLocalSearchCompleter()
        self.searchCompleter.delegate = self
        self.cancellable = $searchQuery.assign(to: \.queryFragment, on: searchCompleter)
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
    }
}
