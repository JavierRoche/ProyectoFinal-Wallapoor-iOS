//
//  SearchFirestore.swift
//  Wallapobre
//
//  Created by APPLE on 14/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import Foundation
import FirebaseFirestore

class SearchFirestore: SearchFirestoreManager {
    /// Instancia para acceder al nodo principal de la DB de Firestore
    var db = Firestore.firestore().collection(Constants.searchesFirebase)
    
    func selectSearchs(onSuccess: @escaping ([Search]) -> Void, onNonexistent: @escaping () -> Void, onError: ErrorClosure?) {
        
        /// Realizamos la SELECT a Firebase.searchs
        self.db
            /// Cada Search se guarda por usuario logueado
            .whereField("searcher", isEqualTo: MainViewModel.user.sender.senderId)
            /// No necesitamos listener y usamos .getDocuments
            .getDocuments { (snapshot, error) in
                /// Raro que devuelva Firestore un error aqui
                if let error = error, let retError = onError {
                    DispatchQueue.main.async {
                        retError(error)
                    }
                }
                
                /// Existen busquedas de usuario
                if let snapshot = snapshot {
                    let searches: [Search] = snapshot.documents
                        .compactMap({ Search.mapper(document: $0) })
                    
                    DispatchQueue.main.async {
                        onSuccess(searches)
                    }
                }
        }
    }
    
    func insertSearch(search: Search, onSuccess: @escaping () -> Void, onError: ErrorClosure?) {
        /// Pasamos la Search al tipo QueryDocumentSnapshot
        let snapshot = Search.toSnapshot(search: search)
        
        /// Insertamos la Search en BD
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
}
