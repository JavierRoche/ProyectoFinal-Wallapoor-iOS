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
    /// Usuario logueado que ha entrado en la App
    private lazy var userLogged = User.init(id: "", email: "", password: "")
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
            //locationManager.requestLocation()
            break
            
        /// Configurar desde opciones
        case .restricted, .denied:
            fatalError("Configure Wallapoor authorization from options")
            break
            
        /// Ya tenemos los permisos
        case .authorizedAlways, .authorizedWhenInUse:
            //locationManager.requestLocation()
            break
            
        @unknown default:
            fatalError("Wallapoop needs to get the locations to work")
        }
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func saveUserLogged(user: User) {
        self.userLogged = user
    }
    
    func getUserLogged() -> User {
        return self.userLogged
    }
}


// MARK: CLLocationManager Delegate

extension UserLocation: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /// Cada vez que el dispositivo detecta una nueva localizacion el delegado ejecuta este metodo
        print("[]\(locations)")
        currentLocation = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("[]\(error)")
    }
}
