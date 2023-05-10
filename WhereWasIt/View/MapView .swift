//
//  MapView.swift .swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-05-09.
//

import SwiftUI
import MapKit
import CoreLocation

import SwiftUI
import MapKit
import CoreLocation

struct MapView: UIViewRepresentable {
    @EnvironmentObject var locationStore: LocationStore
    @Binding var centerOnUser: Bool

    @State private var userLocation: CLLocation?
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        if centerOnUser, let userLocation = userLocation {
            context.coordinator.centerMapOnUser(mapView, userLocation: userLocation)
        }
        updateAnnotations(from: mapView)
    }


    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    final class LocationAnnotation: NSObject, MKAnnotation {
        let title: String?
        let subtitle: String?
        let coordinate: CLLocationCoordinate2D

        init(location: Location) {
            self.title = location.name
            self.subtitle = location.category
            self.coordinate = location.coordinate
        }
    }


    private func updateAnnotations(from mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations)
        let annotations = locationStore.locations.map(LocationAnnotation.init)
        mapView.addAnnotations(annotations)
    }

    class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
            var parent: MapView
            let locationManager = CLLocationManager()

            init(_ parent: MapView) {
                self.parent = parent
                super.init()
                locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
            }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            parent.userLocation = location
            /*if !parent.regionHasBeenSet {
                let coordinate = location.coordinate
                parent.region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                parent.regionHasBeenSet = true
            }*/
        }
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
                    parent.region = mapView.region
                }

                func centerMapOnUser(_ mapView: MKMapView, userLocation: CLLocation) {
                    let coordinate = userLocation.coordinate
                    let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                    mapView.setRegion(region, animated: true)
                    DispatchQueue.main.async { [self] in
                        parent.centerOnUser = false
                    }
                }

    }
}
