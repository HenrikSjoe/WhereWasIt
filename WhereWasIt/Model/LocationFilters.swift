//
//  LocationFilters.swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-05-15.
//

import SwiftUI

struct LocationFilters {
    var startDate: Date = Date()
    var endDate: Date = Date()
    var applyDateFilter: Bool { startDate < endDate }
    
    var isPrivate: Bool = false
    var applyPrivacyFilter: Bool { isPrivate != false }
    
    var name: String = ""
    var applyNameFilter: Bool { !name.isEmpty }
    
    var applyFilter: Bool = false
}

enum LocationCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case restaurant = "Restaurant"
    case bar = "Bar"
    case nightClub = "Nightclub"
    case store = "Store"
    case other = "Other"
    
    var id: String { self.rawValue }
}
