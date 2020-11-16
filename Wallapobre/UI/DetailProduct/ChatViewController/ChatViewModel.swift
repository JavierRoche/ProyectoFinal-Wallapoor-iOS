//
//  ChatViewModel.swift
//  Wallapobre
//
//  Created by APPLE on 11/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import Foundation
import MessageKit

class ChatViewModel {
    var product: Product!
    var discussion: Discussion!
    var messages: [MessageType] = []


    // MARK: Inits

    init(product: Product){
        self.product = product
        self.discussion = Discussion.init(discussionId: String(), productId: String(), seller: String(), buyer: String())
    }
    
    
    // MARK: Public Functions
    
    func initDiscussionChat(onSuccess: @escaping () -> Void, onError: ErrorClosure?) {
        /// Buscamos una Discussion por Producto - Vendedor - Usuario (logged)
        let discussion: Discussion = Discussion.init(discussionId: String(), productId: self.product.productId, seller: self.product.seller, buyer: MainViewModel.user.sender.senderId)
        Managers.managerDiscussionFirestore!.selectDiscussion(discussion: discussion, onSuccess: { discussion in
            self.discussion = discussion
            
            /// Buscamos los mensajes de la Discussion recuperada
            Managers.managerMessageFirestore!.selectMessages(discussion: discussion, onSuccess: { messages in
                self.messages = messages
                onSuccess()
                
            }) { error in
                if let retError = onError {
                    retError(error)
                }
            }
            
        }, onNonexistent: {
            /// Creamos una Discussion nueva
            let discussion: Discussion = Discussion.init(productId: self.product.productId, seller: self.product.seller, buyer: MainViewModel.user.sender.senderId)
            Managers.managerDiscussionFirestore!.insertDiscussion(discussion: discussion, onSuccess: {
                /// Se ha creado una nueva Discussion
                self.discussion = discussion
                
                /// Buscamos los mensajes de la Discussion creada. NO habra ninguno pero hay que activar el Listener
                Managers.managerMessageFirestore!.selectMessages(discussion: discussion, onSuccess: { messages in
                    self.messages = messages
                    onSuccess()
                    
                }) { error in
                    if let retError = onError {
                        retError(error)
                    }
                }
                
            }) { error in
                if let retError = onError {
                    retError(error)
                }
            }
            
        }) { error in
            if let retError = onError {
                retError(error)
            }
        }
    }
    
    func insertMessage(message: Message, onSuccess: @escaping () -> Void, onError: ErrorClosure?) {
        Managers.managerMessageFirestore!.insertMessage(message: message, onSuccess: {
            /// Mensaje insertado en Firestore
            onSuccess()
            
        }) { error in
            if let retError = onError {
                retError(error)
            }
        }
    }
}

