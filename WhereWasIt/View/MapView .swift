//
//  MapView.swift .swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-05-09.
//


import SwiftUI
import MapKit
import CoreLocation

struct MapView: UIViewRepresentable {
    @EnvironmentObject var locationStore: LocationStore
    @EnvironmentObject var userAuth: UserAuth
    @Binding var centerOnUser: Bool
    @Binding var filters: LocationFilters
    var onLongPress: ((CLLocationCoordinate2D) -> Void)? = nil
    
    @State private var userLocation: CLLocation?
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    @State private var annotations: [LocationAnnotation] = []
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress))
        mapView.addGestureRecognizer(longPressRecognizer)
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        if centerOnUser, let userLocation = userLocation {
            context.coordinator.centerMapOnUser(mapView, userLocation: userLocation)
        }
        updateAnnotations(from: mapView)
    }
    
    private func updateAnnotations(from mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations)
        let locations = filters.applyFilter ? locationStore.filterLocations(filters: filters) : locationStore.locations
        print("Locations after applying filter: \(locations)")
        let annotations = locations.map(LocationAnnotation.init)
        mapView.addAnnotations(annotations)
    }
    
    
    
    
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, locationStore: locationStore)
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
    
    
    class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        var parent: MapView
        var locationStore: LocationStore
        let locationManager = CLLocationManager()
        
        init(_ parent: MapView, locationStore: LocationStore) {
            self.parent = parent
            self.locationStore = locationStore
            super.init()
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            parent.userLocation = location
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let locationAnnotation = annotation as? LocationAnnotation else { return nil }
            
            let identifier = "Location"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
            
            switch locationAnnotation.subtitle {
            case "Restaurant":
                (annotationView as? MKMarkerAnnotationView)?.glyphImage = UIImage(systemName: "fork.knife")
            case "Bar":
                (annotationView as? MKMarkerAnnotationView)?.glyphImage = UIImage(systemName: "wineglass.fill")
            case "Nightclub":
                (annotationView as? MKMarkerAnnotationView)?.glyphImage = UIImage(systemName: "music.note.list")
            case "Store":
                (annotationView as? MKMarkerAnnotationView)?.glyphImage = UIImage(systemName: "bag.fill")
            default:
                (annotationView as? MKMarkerAnnotationView)?.glyphImage = UIImage(systemName: "questionmark.circle")
            }
            
            return annotationView
        }
        
        func centerMapOnUser(_ mapView: MKMapView, userLocation: CLLocation) {
            let coordinate = userLocation.coordinate
            let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
            DispatchQueue.main.async { [self] in
                parent.centerOnUser = false
            }
        }
        
        @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
            if !parent.userAuth.isSignedIn {
                return
            }
            
            guard gestureRecognizer.state == .began else { return }
            let touchPoint = gestureRecognizer.location(in: gestureRecognizer.view)
            let coordinate = (gestureRecognizer.view as? MKMapView)?.convert(touchPoint, toCoordinateFrom: gestureRecognizer.view)
            if let coordinate = coordinate {
                parent.onLongPress?(coordinate)
            }
        }
        
    }
}


