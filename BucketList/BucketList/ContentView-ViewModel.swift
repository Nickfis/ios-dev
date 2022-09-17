//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Niklas Fischer on 1/9/22.
//

import Foundation
import LocalAuthentication
import MapKit

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0),span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        
        @Published var locations = [Location]()
        @Published var selectedPlace: Location?
        
        @Published var isUnlocked = false
        
        func addLocation() {
            // create a new location
            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
            
            locations.append(newLocation)
        }
        
        func update(location: Location) {
            guard let selectedPlace = selectedPlace else {return }
            // pass in location that was chosen and see whether it can be
            // found in our locations array
            if let index = locations.firstIndex(of: selectedPlace) {
                // if so, update the location with the new location from the editview
                locations[index] = location
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                    success, authenticationError in
                    if success {
                        Task { @MainActor in
                                self.isUnlocked = true
                        }
                    } else {
                        // error
                    }
                }
            } else {
                // no biometrics
            }
        }
    }
}
