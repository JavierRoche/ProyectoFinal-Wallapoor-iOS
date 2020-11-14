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
    var db = Firestore.firestore().collection(Constants.productsFirebase)
    
    
    // MARK: Public Functions
    
    public func selectProducts(onSuccess: @escaping ([Product]) -> Void, onError: ErrorClosure?) {
        /// Realizamos la SELECT a Firebase.products
        self.db
            /// Ordenamos los productos mas actuales primero
            .order(by: "sentdate", descending: false)
            /// Ponemos un listener para que podamos actualizar la lista
            .addSnapshotListener { (snapshot, error) in
                /// Raro que devuelva Firestore un error aqui
                if let error = error, let retError = onError {
                    retError(error)
                }
                
                
                if let snapshot = snapshot {
                    /// Recorremos los documents de Firestore mapeandolos a una lista de Product
                    let productList: [Product] = snapshot.documents
                        .compactMap({ Product.mapper(document: $0) })
                    onSuccess(productList)
                }
        }
    }
        
        
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
