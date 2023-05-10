//
//  Location.swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-05-09.
//

import Foundation
import CoreLocation

struct Location: Identifiable, Codable {
    let id: String
    let name: String
    let category: String
    let coordinate: CLLocationCoordinate2D

    init(id: String = UUID().uuidString, name: String, category: String, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.name = name
        self.category = category
        self.coordinate = coordinate
    }
}

extension Location {
    static func example() -> Location {
        return Location(name: "Example Place", category: "Restaurant", coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))
    }
}

extension CLLocationCoordinate2D: Codable {
    enum CodingKeys: CodingKey {
        case latitude
        case longitude
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
}
