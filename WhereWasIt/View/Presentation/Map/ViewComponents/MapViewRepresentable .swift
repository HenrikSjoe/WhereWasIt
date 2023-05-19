//
//  MapViewRepresentable.swift .swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-05-09.
//

import Firebase
import SwiftUI
import MapKit
import CoreLocation

struct MapViewRepresentable: UIViewRepresentable {
    @Binding var centerOnUser: Bool
    
    @State private var userLocation: CLLocation?
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    @State private var annotations: [LocationAnnotation] = []
    
    let locations: [Location]
    let user: User?
    var onLongPress: ((CLLocationCoordinate2D) -> Void)? = nil
    
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
        let annotations = locations.map(LocationAnnotation.init)
        mapView.addAnnotations(annotations)
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
    
    
    class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        var parent: MapViewRepresentable
        let locationManager = CLLocationManager()
        
        init(_ parent: MapViewRepresentable
        ) {
            self.parent = parent
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
            if parent.user == nil {
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


