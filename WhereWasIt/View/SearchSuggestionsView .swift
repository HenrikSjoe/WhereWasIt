//
//  SearchSuggestionsView.swift .swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-05-09.
//

import SwiftUI

struct SearchSuggestionsView: View {
    @EnvironmentObject var locationStore: LocationStore
    var didSelectSuggestion: (Location) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(locationStore.locations) { location in
                Button(action: {
                    self.didSelectSuggestion(location)
                }) {
                    VStack(alignment: .leading) {
                        Text(location.name)
                            .font(.headline)
                        Text(location.category)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                Divider()
            }
        }
    }
}
