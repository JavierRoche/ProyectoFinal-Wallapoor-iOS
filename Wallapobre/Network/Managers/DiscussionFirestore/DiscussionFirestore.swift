//
//  DiscussionFirestore.swift
//  Wallapobre
//
//  Created by APPLE on 11/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import Foundation
import FirebaseFirestore

class DiscussionFirestore: DiscussionFirestoreManager {
    /// Instancia para acceder al nodo principal de la DB de Firestore
    var db = Firestore.firestore().collection(Constants.discussionsFirebase)
    
    func selectDiscussion(discussion: Discussion, onSuccess: @escaping (Discussion) -> Void, onNonexistent: @escaping () -> Void, onError: ErrorClosure?) {
        
        /// Realizamos la SELECT a Firebase.discussions
        self.db
            /// Cada Discussion se guarda por Product - Seller - Buyer
            .whereField("productid", isEqualTo: discussion.productId)
            .whereField("seller", isEqualTo: discussion.seller)
            .whereField("buyer", isEqualTo: discussion.buyer)
            /// No necesitamos listener y usamos .getDocuments
            .getDocuments { (snapshot, error) in
                /// Raro que devuelva Firestore un error aqui
                if let error = error, let retError = onError {
                    DispatchQueue.main.async {
                        retError(error)
                    }
                }
                
                /// La discussion existe
                if let snapshot = snapshot {
                    /// Si no se puede recuperar por lo que sea
                    guard let document: QueryDocumentSnapshot = snapshot.documents.first else {
                        DispatchQueue.main.async {
                            onNonexistent()
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        onSuccess(Discussion.mapper(document: document))
                    }
                }
        }
    }
    
    func insertDiscussion(discussion: Discussion, onSuccess: @escaping () -> Void, onError: ErrorClosure?) {
        /// Pasamos la Discussion al tipo QueryDocumentSnapshot
        let snapshot = Discussion.toSnapshot(discussion: discussion)
        
        /// Insertamos la Discussion en BD
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
