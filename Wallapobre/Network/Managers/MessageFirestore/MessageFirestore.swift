//
//  MessageFirestore.swift
//  Wallapobre
//
//  Created by APPLE on 11/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import Foundation
import FirebaseFirestore

class MessageFirestore: MessageFirestoreManager {
    /// Instancia para acceder al nodo principal de la DB de Firestore
    var db = Firestore.firestore().collection(Constants.messagesFirebase)
    
    
    func selectMessages(discussion: Discussion, onSuccess: @escaping ([Message]) -> Void, onError: ErrorClosure?) {
        
        /// Realizamos la SELECT a Firebase.messages
        self.db
            /// Filtramos los mensajes de esta Discussion
            .whereField("discussionid", isEqualTo: discussion.discussionId)
            /// Ordenamos los mensajes mas actuales primero
            .order(by: "sentdate", descending: false)
            /// Ponemos un listener para que podamos actualizar la lista
            .addSnapshotListener { (snapshot, error) in
                /// Raro que devuelva Firestore un error aqui
                if let err = error, let retError = onError {
                    DispatchQueue.main.async {
                        retError(err)
                    }
                }
                
                /// Existen mensajes
                if let snapshot = snapshot {
                    let messages: [Message] = snapshot.documents
                        .compactMap({ Message.mapper(document: $0) })
                    
                    DispatchQueue.main.async {
                        onSuccess(messages)
                    }
                }
        }
    }
    
    func insertMessage(message: Message, onSuccess: @escaping () -> Void, onError: ErrorClosure?) {
        /// Pasamos la Discussion al tipo QueryDocumentSnapshot
        let snapshot = Message.toSnapshot(message: message)
        
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
