//
//  LocationFilters.swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-05-15.
//

import SwiftUI

/*struct LocationFilters {
    var category: String = ""
    var applyCategoryFilter: Bool = false
    var startDate: Date = Date.distantPast
    var endDate: Date = Date.distantFuture
    var applyDateFilter: Bool = false
    var isPrivate: Bool = false
    var applyPrivacyFilter: Bool = false
    var name: String = ""
    var applyFilter: Bool = false
}
*/

struct LocationFilters {
    var category: String = "All"
    var applyCategoryFilter: Bool { category != "All" }
    
    var startDate: Date = Date.distantPast
    var endDate: Date = Date.distantFuture
    var applyDateFilter: Bool { startDate != Date.distantPast || endDate != Date.distantFuture }
    
    var isPrivate: Bool = false
    var applyPrivacyFilter: Bool { isPrivate != false }
    
    var name: String = ""
    var applyNameFilter: Bool { !name.isEmpty }
    
    var applyFilter: Bool = false
}

