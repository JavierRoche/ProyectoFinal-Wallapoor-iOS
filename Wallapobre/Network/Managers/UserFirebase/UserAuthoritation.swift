//
//  UserFirebase.swift
//  Wallapobre
//
//  Created by APPLE on 03/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

public class UserAuthoritation: UserAuthorizationManager {
    
    /// Metodo para el login que recibe un usuario y devuelve un usuario o un error
    public func login(user: User, onSuccess: @escaping (User) -> Void, onError: ErrorClosure?) {
        /// Metodo que accede a Firebase a loguear con email y password
        Auth.auth().signIn(withEmail: user.email, password: user.password!) { (user, error) in
            /// Nos aseguramos de que ha llegado un error y la clausura de error existe
            if let error = error, let retError = onError {
                /// Devolvemos la clausura de error con el error
                retError(error)
            }
            /// Comprobamos que el sistema ha devuelto el usuario registrado y lo devolvemos
            if let user = user {
                onSuccess(User.init(id: user.user.uid, email: user.user.email!, password: nil))
            }
        }
    }
    
    /// Metodo para el registro que recibe un usuario y devuelve un usuario o un error
    public func register(user: User, onSuccess: @escaping (User) -> Void, onError: ErrorClosure?) {
        /// Metodo que accede a Firebase a comprobar el registro con email y password
        Auth.auth().createUser(withEmail: user.email, password: user.password!) { (user, error) in
            /// Si existe la causura de error y ha llegado uno devolvemos la clausura con el error
            if let error = error, let retError = onError {
                retError(error)
            }
            /// Comprobamos que el sistema ha devuelto el usuario registrado y lo devolvemos
            if let user = user {
                onSuccess(User.init(id: user.user.uid, email: user.user.email!, password: nil))
            }
        }
    }
    
    /// Metodo para recuperar la pass de un email
    public func recoverPassword(user: User, onSuccess: @escaping (User) -> Void, onError: ErrorClosure?) {
        /// Enviamos el recover pass al email del user a Firebase
        Auth.auth().sendPasswordReset(withEmail: user.email) { (error) in
            /// Nos aseguramos de que ha llegado un error y la clausura de error existe
            if let error = error, let retError = onError {
                /// Devolvemos la clausura de error con el error
                retError(error)
            }
            /// El sistema devuelve el usuario recuperado, pero se manda un email para el reset
            onSuccess(user)
        }
    }
    
    /// Metodo que comprueba si un usuario esta logueado
    public func isLogged(onSuccess: @escaping (User?) -> Void, onError: ErrorClosure?) {
        /// Metodo que accede a Firebase a comprobar el usuario actual
        if let user = Auth.auth().currentUser {
            let user = User.init(id: user.uid, email: user.email!, password: nil)
            onSuccess(user)
        }
        /// Sino esta logueado devolvemos un nil en la closure success
        onSuccess(nil)
    }
    
    /// Metodo para desloguear el usuario de Firebase
    public func logout(onSuccess: @escaping () -> Void, onError: ErrorClosure?) {
        /// Es un metodo que puede lanzar una excepcion
        do {
            try Auth.auth().signOut()
            onSuccess()
            
        } catch let error as NSError {
            /// Nos aseguramos de que la clausura de error existe y devolvemos el error recuperado
            if let retError = onError {
                retError(error)
            }
        }
    }
}

