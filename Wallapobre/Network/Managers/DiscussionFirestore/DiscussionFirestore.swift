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
    var db = Firestore.firestore().collection("discussions")
    
    func selectDiscussion(discussion: Discussion, onSuccess: @escaping (Discussion) -> Void, onNonexistent: @escaping () -> Void, onError: ErrorClosure?) {
        /// Comprobamos la existencia de la discussion en BD
        self.db
            .whereField("productid", isEqualTo: discussion.productId)
            .whereField("seller", isEqualTo: discussion.seller)
            .whereField("buyer", isEqualTo: discussion.buyer)
            .getDocuments { (snapshot, error) in
            /// Raro que devuelva Firestore un error aqui
            if let error = error, let retError = onError {
                retError(error)
            }
            
            /// La discussion existe
            if let snapshot = snapshot {
                /// Si no se puede recuperar por lo que sea
                guard let document: QueryDocumentSnapshot = snapshot.documents.first else {
                    onNonexistent()
                    return
                }
                onSuccess(Discussion.mapper(document: document))
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
                    retError(error)
                }
                onSuccess()
        }
    }
}
