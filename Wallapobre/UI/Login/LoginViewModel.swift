//
//  LoginViewModel.swift
//  Wallapobre
//
//  Created by APPLE on 04/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

protocol LoginViewModelDelegate: class {
    func mainViewModelsCreated()
}

class LoginViewModel {
    weak var delegate: LoginViewModelDelegate?
    /// Objeto que maneja el modelo
    var user: User?
    
    
    // MARK: Public Functions
    
    func askForLocationPermissions() {
        Managers.managerUserLocation!.handleAuthorizationStatus()
        Managers.managerUserLocation!.requestLocation()
    }
    
    func checkUserLogged(onSuccess: @escaping (User?) -> Void, onError: ErrorClosure?) {
        /// Chequea usuario logueado en UserAuthoritation
        Managers.managerUserAuthoritation!.isLogged(onSuccess: { user in
            onSuccess(user)
            
        }) { error in
            if let retError = onError {
                retError(error)
            }
        }
    }
    
    func getUserLogged(user: User, onSuccess: @escaping (User) -> Void, onError: ErrorClosure?) {
        Managers.managerUserFirestore!.selectUser(userId: user.sender.senderId, onSuccess: { [weak self] firestoreUser in
            if let user = firestoreUser {
                /// El usuario existe en Firestore BD
                self?.user = user
                onSuccess(user)
                
            } else {
                /// El usuario no existe en Firestore BD. Completamos datos e insertamos
                self?.user = user
                self?.user?.latitude = Managers.managerUserLocation!.currentLocation!.coordinate.latitude
                self?.user?.longitude = Managers.managerUserLocation!.currentLocation!.coordinate.longitude
                self?.insertUser(user: self!.user!)
            }
            
        }) { error in
            /// Ha habido error raro
            if let retError = onError {
                retError(error)
            }
        }
    }
    
    func logUser(user: User, onSuccess: @escaping (User) -> Void, onError: ErrorClosure?) {
        /// Obtenemos el manager del interactor y hacemos el login
        Managers.managerUserAuthoritation!.login(user: user, onSuccess: { user in
            onSuccess(user)
            
        }) { error in
            if let retError = onError {
                retError(error)
            }
        }
    }
    
    func registerUser(user: User, onSuccess: @escaping (User) -> Void, onError: ErrorClosure?) {
        Managers.managerUserAuthoritation!.register(user: user, onSuccess: { user in
            onSuccess(user)
            
        }) { error in
            if let retError = onError {
                retError(error)
            }
        }
    }
    
    func recoverUser(user: User, onSuccess: @escaping () -> Void, onError: ErrorClosure?) {
        Managers.managerUserAuthoritation!.recoverPassword(user: user, onSuccess: { user in
            onSuccess()
            
        }) { error in
            if let retError = onError {
                retError(error)
            }
        }
    }
    
    func saveUserLogged(user: User) {
        Managers.managerUserLocation?.saveUserLogged(user: user)
    }
    
    
    // MARK: Private Functions
    
    fileprivate func insertUser(user: User) {
        Managers.managerUserFirestore!.insertUser(user: user, onSuccess: {
            print("[] User insertado")
        }) { error in
            print("[]\(error.localizedDescription)")
        }
    }
}
