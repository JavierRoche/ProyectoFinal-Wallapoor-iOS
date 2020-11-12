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
    var db = Firestore.firestore().collection("messages")
    
    
    func selectMessages(discussion: Discussion, onSuccess: @escaping ([Message]) -> Void, onError: ErrorClosure?) {
        
        /// Comprobamos la existencia de mensajes de la discussion en BD
        self.db
            .whereField("discussionid", isEqualTo: discussion.discussionId)
            .order(by: "sentdate", descending: false)
            .addSnapshotListener { (snapshot, error) in
                /// Raro que devuelva Firestore un error aqui
                if let err = error, let retError = onError {
                    retError(err)
                }
                
                
                if let snapshot = snapshot {
                    let messageList: [Message] = snapshot.documents
                        .compactMap({ Message.mapper(document: $0) })
                    
                    onSuccess(messageList)
                }
                
            }
        
        /// Comprobamos la existencia de mensajes de la discussion en BD
        /*self.db
            .whereField("discussionid", isEqualTo: discussion.discussionId)
            .getDocuments { (snapshot, error) in
                /// Raro que devuelva Firestore un error aqui
                if let error = error, let retError = onError {
                    retError(error)
                }
                
                /// Existen mensajes
                if let snapshot = snapshot {
                    /// Recorremos los documents de Firestore mapeandolos a una lista de Product
                    //var messageList: [Message] = [Message]()
                    /*for document in snapshot.documents {
                        let message: Message = Message.mapper(document: document)
                        messageList.append(message)
                    }*/
                    let messageList: [Message] = snapshot.documents
                    .compactMap({ Message.mapper(document: $0) })
                    onSuccess(messageList)
                }
        }*/
                
    }
    
    func insertMessage(message: Message, onSuccess: @escaping () -> Void, onError: ErrorClosure?) {
        /// Pasamos la Discussion al tipo QueryDocumentSnapshot
        let snapshot = Message.toSnapshot(message: message)
        
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
