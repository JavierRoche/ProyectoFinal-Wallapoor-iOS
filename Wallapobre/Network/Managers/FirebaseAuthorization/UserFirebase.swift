//
//  UserFirebase.swift
//  Wallapobre
//
//  Created by APPLE on 03/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import Foundation
import FirebaseAuth

/// Esta clase solo trabaja con la parte de autentificacion
public class UserFirebase: UserManager {
    
    /// Metodo para el registro
    public func register(user: User, onSuccess: @escaping (User) -> Void, onError: ErrorClosure?) {
        
        Auth.auth().createUser(withEmail: user.email, password: user.password!) { (user, error) in
            /// Nos aseguramos de que ha llegado un error y la clausura de error existe
            if let err = error, let retError = onError {
                /// Devolvemos la clausura de error con el error
                retError(err)
            }
            /// Nos aseguramos de que ha llegado el usuario al no llegar error
            if let u = user {
                /// Devolvemos un usuario inicializado con los datos recibidos
                onSuccess(User.init(id: u.user.uid, email: u.user.email!, password: nil))
            }
            
        }
        
    }
    
    /// Metodo para el login
    public func login(user: User, onSuccess: @escaping (User) -> Void, onError: ErrorClosure?) {
        
        Auth.auth().signIn(withEmail: user.email, password: user.password!) { (user, error) in
            /// Nos aseguramos de que ha llegado un error y la clausura de error existe
            if let err = error, let retError = onError {
                /// Devolvemos la clausura de error con el error
                retError(err)
            }
            /// Nos aseguramos de que ha llegado el usuario al no llegar error
            if let u = user {
                onSuccess(User.init(id: u.user.uid, email: u.user.email!, password: nil))
            }
            
        }
        
    }
    
    // MARK: Importante
    /*
     En la funcion ...
        onSuccess: @escaping (User) -> Void
     ... es un parametro funcion.
     Las funciones tienen un nombre: onSuccess
     tienen un retorno: @escaping (User)
     y el tipo de la funcion: Void
     
     Lo que se hace es que cuando acaba la funcion principal recoverPassword, digamos que se
     llama a la siguiente funcion, en este caso closure de vuelta onSuccess o bien onError
     */
    
    /// Metodo para recuperar la pass a un email
    public func recoverPassword(user: User, onSuccess: @escaping (User) -> Void, onError: ErrorClosure?) {
        /// Enviamos el recover pass al email del user
        Auth.auth().sendPasswordReset(withEmail: user.email) { (error) in
            /// Nos aseguramos de que ha llegado un error y la clausura de error existe
            if let err = error, let retError = onError {
                /// Devolvemos la clausura de error con el error
                retError(err)
            }
            /// Devolvemos el mismo usuario que nos han mandado
            onSuccess(user)
            
        }
        
    }
    
    /// Metodo para comprobar si un usuario esta logueado
    public func isLogged(onSuccess: @escaping (User?) -> Void, onError: ErrorClosure?) {
        
        if let user = Auth.auth().currentUser {
            let user = User.init(id: user.uid, email: user.email!, password: nil)
            onSuccess(user)
        }
        /// Sino esta logueado devolvemos un nil en la closure success
        onSuccess(nil)
        
    }
    
    /// Metodo para desloguear
    public func logout(onSuccess: @escaping () -> Void, onError: ErrorClosure?) {
        
        do {
            try Auth.auth().signOut()
            onSuccess()
        } catch let error as NSError {
            print(error.localizedDescription)
            /// Nos aseguramos de que la clausura de error existe y devolvemos el error recuperado
            if let retError = onError {
                retError(error)
            }
        }
        
    }
    
    
}

