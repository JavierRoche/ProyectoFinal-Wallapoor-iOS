//
//  UserFirestore.swift
//  Wallapobre
//
//  Created by APPLE on 04/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import Foundation
import FirebaseFirestore


class UserFirestore: UserFirestoreManager {
    /// Instancia para acceder al nodo principal de la DB de Firestore
    var db = Firestore.firestore().collection(Constants.usersFirebase)
    
    
    // MARK: Public Functions
    
    public func selectUser(userId: String, onSuccess: @escaping (User?) -> Void, onError: ErrorClosure?) {
        /// Comprobamos la presencia del usuario en BD
        self.db
            .whereField("userid", isEqualTo: userId)
            .getDocuments { (snapshot, error) in
                /// Raro que devuelva Firestore un error aqui
                if let error = error, let retError = onError {
                    DispatchQueue.main.async {
                        retError(error)
                    }
                }
                
                /// El usuario existia
                if let snapshot = snapshot {
                    /// Si no hay ningun user con ese id devolvemos inexistente
                    guard let document: QueryDocumentSnapshot = snapshot.documents.first else {
                        DispatchQueue.main.async {
                            onSuccess(nil)
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        onSuccess(User.mapper(document: document))
                    }
                }
        }
    }
    
    public func insertUser(user: User, onSuccess: @escaping () -> Void, onError: ErrorClosure?) {
        /// Pasamos el usuario al tipo QueryDocumentSnapshot
        let snapshot = User.toSnapshot(user: user)
        
        /// Insertamos el usuario en BD
        self.db
            .addDocument(data: snapshot) { (error) in
                if let error = error, let retError = onError {
                    DispatchQueue.main.async {
                        retError(error)
                    }
                }
                DispatchQueue.main.async {
                    onSuccess()
                }
        }
    }
    
    public func updateUser(user: User, onSuccess: @escaping () -> Void, onError: ErrorClosure?) {
        /// Actualizamos el usuario en BD
        self.db
            .whereField("userid", isEqualTo: user.sender.senderId)
            .getDocuments { (snapshot, error) in
            /// Raro que devuelva Firestore un error aqui
            if let error = error, let retError = onError {
                DispatchQueue.main.async {
                    retError(error)
                }
            }
            
            /// El usuario existe
            if let snapshot = snapshot {
                /// Si no hay ningun user con ese id devolvemos inexistente
                guard let document: QueryDocumentSnapshot = snapshot.documents.first else { return }
                
                document.reference.updateData(["avatar": user.avatar ?? String()]) { error in
                    if let error = error, let retError = onError {
                        DispatchQueue.main.async {
                            retError(error)
                        }
                    }
                    DispatchQueue.main.async {
                        onSuccess()
                    }   
                }
            }
        }
    }
}
