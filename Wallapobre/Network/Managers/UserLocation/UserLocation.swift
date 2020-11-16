//
//  UserLocationManager.swift
//  Wallapobre
//
//  Created by APPLE on 04/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit
import CoreLocation

class UserLocation: NSObject {
    /// Definimos el cerebro de CoreLocation
    lazy var locationManager: CLLocationManager = {
        let manager: CLLocationManager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    /// Con esta propiedad tenemos siempre la localizacion del usuario
    var currentLocation: CLLocation?
    
    
    // MARK: Public Functions
    
    func handleAuthorizationStatus() {
        /// Mediante el LocationManager extraer el estado
        let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        switch status {
        /// Mediante el LocationManager solicitamos los permisos
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
            
        /// Configurar desde opciones
        case .restricted, .denied:
            //fatalError(Constants.fatalErrorAuth)
            break
            
        /// Ya tenemos los permisos
        case .authorizedAlways, .authorizedWhenInUse:
            break
            
        @unknown default:
            //fatalError(Constants.fatalErrorNeedLoc)
            break
        }
    }
    
    func neverRequested() -> Bool {
        return CLLocationManager.authorizationStatus() == .notDetermined
    }
    
    func userAuthorized() -> Bool {
        return CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
}


// MARK: CLLocationManager Delegate

extension UserLocation: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /// Cada vez que el dispositivo detecta una nueva localizacion el delegado ejecuta este metodo
        currentLocation = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("[]\(error)")
    }
}
