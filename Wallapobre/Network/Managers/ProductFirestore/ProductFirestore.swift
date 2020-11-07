//
//  ProductFirestore.swift
//  Wallapobre
//
//  Created by APPLE on 06/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import Foundation
import FirebaseFirestore

class ProductFirestore: ProductFirestoreManager {
    /// Instancia para acceder al nodo principal de la DB de Firestore
    var db = Firestore.firestore().collection("products")
    
    
    // MARK: Public Functions
    
    public func insertProduct(product: Product, onSuccess: @escaping () -> Void, onError: ErrorClosure?) {
        /// Pasamos el producto al tipo QueryDocumentSnapshot
        let snapshot = Product.toSnapshot(product: product)
        
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
