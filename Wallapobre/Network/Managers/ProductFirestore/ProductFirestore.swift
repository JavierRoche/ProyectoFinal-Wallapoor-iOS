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
            /// Filtramos los productos que no esten vendidos
            .whereField("state", isEqualTo: 0)
            /// Ordenamos los productos mas actuales primero
            .order(by: "sentdate", descending: false)
            /// Ponemos un listener para que podamos actualizar la lista
            .addSnapshotListener { (snapshot, error) in
                /// Raro que devuelva Firestore un error aqui
                if let error = error, let retError = onError {
                    DispatchQueue.main.async {
                        retError(error)
                    }
                }
                
                if let snapshot = snapshot {
                    /// Recorremos los documents de Firestore mapeandolos a una lista de Product
                    let products: [Product] = snapshot.documents
                        .compactMap({ Product.mapper(document: $0) })
                    DispatchQueue.main.async {
                        onSuccess(products)
                    }
                }
        }
    }
    
    public func selectProductBySeller(userId: String, onSuccess: @escaping ([Product]) -> Void, onError: ErrorClosure?) {
        /// Realizamos la SELECT a Firebase.products
        self.db
            /// Filtramos los productos de este usuario
            .whereField("seller", isEqualTo: userId)
            /// Ordenamos los productos mas actuales primero
            .order(by: "sentdate", descending: false)
            /// No necesitamos listener y usamos .getDocuments
            .getDocuments { (snapshot, error) in
                /// Raro que devuelva Firestore un error aqui
                if let error = error, let retError = onError {
                    DispatchQueue.main.async {
                        retError(error)
                    }
                }
                
                if let snapshot = snapshot {
                    /// Recorremos los documents de Firestore mapeandolos a una lista de Product
                    let products: [Product] = snapshot.documents
                        .compactMap({ Product.mapper(document: $0) })
                    DispatchQueue.main.async {
                        onSuccess(products)
                    }
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
                    DispatchQueue.main.async {
                        retError(error)
                    }
                }
                DispatchQueue.main.async {
                    onSuccess()
                }
        }
    }
    
    public func modifyProduct(product: Product, onSuccess: @escaping () -> Void, onError: ErrorClosure?) {
        /// Primero intentamos recuperar el producto de BD
        self.db
            .whereField("productid", isEqualTo: product.productId)
            .getDocuments { (snapshot, error) in
                /// Raro que devuelva Firestore un error aqui
                if let error = error, let retError = onError {
                    DispatchQueue.main.async {
                        retError(error)
                    }
                }
                
                /// Pasamos el producto modificado al tipo QueryDocumentSnapshot
                let updatedSnapshot = Product.toSnapshot(product: product)
                
                /// El producto existe
                if let snapshot = snapshot {
                    /// Si no se puede recuperar del snapshot devolvemos inexistente
                    guard let document: QueryDocumentSnapshot = snapshot.documents.first else { return }
                    
                    /// Realizamos el Update con el snapshot actualizado
                    document.reference.updateData(updatedSnapshot) { error in
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
    
    public func deleteProduct(product: Product, onSuccess: @escaping () -> Void, onError: ErrorClosure?) {
        /// Primero intentamos recuperar el producto de BD
        self.db
            .whereField("productid", isEqualTo: product.productId)
            .getDocuments { (snapshot, error) in
                /// Raro que devuelva Firestore un error aqui
                if let error = error, let retError = onError {
                    DispatchQueue.main.async {
                        retError(error)
                    }
                }
                
                /// El producto existe
                if let snapshot = snapshot {
                    /// Si no se puede recuperar del snapshot devolvemos inexistente
                    guard let document: QueryDocumentSnapshot = snapshot.documents.first else { return }
                    
                    /// Realizamos el Update con el snapshot actualizado
                    document.reference.delete { error in
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
