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
    
    func getUserLogged(user: User, onSuccess: @escaping (User) -> Void, onError: ErrorClosure?) {
        Managers.managerUserFirestore!.selectUser(user: user, onSuccess: { [weak self] user in
            /// El usuario existe en Firestore BD
            self?.user = user
            onSuccess(self?.user! ?? User.init(id: "", email: "", password: ""))
            
        }, onNonexistent: {
            /// El usuario no existe en Firestore BD. Completamos datos e insertamos
            self.user = user
            self.user?.latitude = Managers.managerUserLocation!.currentLocation!.coordinate.latitude
            self.user?.longitude = Managers.managerUserLocation!.currentLocation!.coordinate.longitude
            self.insertUser(user: self.user!)
            
            onSuccess(self.user!)
            
        }) { error in
            /// Ha habido error raro
            if let retError = onError {
                retError(error)
            }
        }
    }
    
    fileprivate func insertUser(user: User) {
        Managers.managerUserFirestore!.insertUser(user: user, onSuccess: {
            print("[] User insertado")
        }) { error in
            print("[]\(error.localizedDescription)")
        }
    }
}
