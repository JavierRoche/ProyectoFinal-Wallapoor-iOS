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
    var db = Firestore.firestore().collection("users")
    
    
    // MARK: Public Functions
    
    public func selectUser(user: User, onSuccess: @escaping (User) -> Void, onNonexistent: @escaping () -> Void, onError: ErrorClosure?) {
        /// Comprobamos la presencia del usuario en BD
        self.db
            .whereField("userid", isEqualTo: user.sender.id)
            .getDocuments { (snapshot, error) in
                /// Raro que devuelva Firestore un error aqui
                if let error = error, let retError = onError {
                    retError(error)
                }
                
                /// El usuario existia
                if let snapshot = snapshot {
                    /// Si no hay ningun user con ese id devolvemos inexistente
                    guard let document: QueryDocumentSnapshot = snapshot.documents.first else {
                        onNonexistent()
                        return
                    }
                    onSuccess(User.mapper(document: document))
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
                    retError(error)
                }
                onSuccess()
        }
    }
}
