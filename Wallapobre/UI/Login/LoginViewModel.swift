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
    var logoutMessage: Bool
    
    
    // MARK: Inits
    
    init(fromLogout: Bool){
        self.logoutMessage = fromLogout
    }
    
    
    // MARK: Public Functions
    
    func askForLocationPermissions() -> String? {
        if Managers.managerUserLocation!.neverRequested() {
            Managers.managerUserLocation!.handleAuthorizationStatus()
        }
        if Managers.managerUserLocation!.userAuthorized() {
            Managers.managerUserLocation!.requestLocation()
        } else { return String() }
        
        return nil
    }
    
    func logUser(user: User, onSuccess: @escaping (User) -> Void, onError: ErrorClosure?) {
        /// Obtenemos el manager del interactor y hacemos el login
        Managers.managerUserAuthoritation!.login(user: user, onSuccess: { user in
            DispatchQueue.main.async {
                onSuccess(user)
            }
            
        }) { error in
            if let retError = onError {
                DispatchQueue.main.async {
                    retError(error)
                }
            }
        }
    }
    
    func registerUser(user: User, onSuccess: @escaping (User) -> Void, onError: ErrorClosure?) {
        Managers.managerUserAuthoritation!.register(user: user, onSuccess: { user in
            DispatchQueue.main.async {
                onSuccess(user)
            }
            
        }) { error in
            if let retError = onError {
                DispatchQueue.main.async {
                    retError(error)
                }
            }
        }
    }
    
    func getUserLogged(user: User, onSuccess: @escaping (User) -> Void, onError: ErrorClosure?) {
        Managers.managerUserFirestore!.selectUser(userId: user.sender.senderId, onSuccess: { [weak self] firestoreUser in
            if let user = firestoreUser {
                /// Devolvemos el usuario existe en Firestore BD
                DispatchQueue.main.async {
                    onSuccess(user)
                }
                
            } else {
                /// El usuario no existe en Firestore BD. Completamos datos e insertamos
                user.latitude = Managers.managerUserLocation!.currentLocation!.coordinate.latitude
                user.longitude = Managers.managerUserLocation!.currentLocation!.coordinate.longitude
                self?.insertUser(user: user)
                
                /// Devolvemos el usuario recien creado
                DispatchQueue.main.async {
                    onSuccess(user)
                }
            }
            
        }) { error in
            /// Ha habido error raro
            if let retError = onError {
                DispatchQueue.main.async {
                    retError(error)
                }
            }
        }
    }
    
    func recoverUser(user: User, onSuccess: @escaping () -> Void, onError: ErrorClosure?) {
        Managers.managerUserAuthoritation!.recoverPassword(user: user, onSuccess: { user in
            DispatchQueue.main.async {
                onSuccess()
            }
            
        }) { error in
            if let retError = onError {
                DispatchQueue.main.async {
                    retError(error)
                }
            }
        }
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
