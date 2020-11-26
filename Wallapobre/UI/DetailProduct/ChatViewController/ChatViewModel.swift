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
    var discussion: Discussion?
    var messages: [MessageType] = []
    var product: Product!


    // MARK: Inits

    convenience init(product: Product) {
        self.init()
        
        self.product = product
    }
    
    convenience init(discussion: Discussion, product: Product) {
        self.init()
        
        self.discussion = discussion
        self.product = product
    }
    
    
    // MARK: Public Functions
    
    func initDiscussionChat(onSuccess: @escaping () -> Void, onError: ErrorClosure?) {
        /// Comprobamos si se ha inicializado el modelo con una Discussion existente
        if self.discussion == nil {
            /// Buscamos una Discussion por Producto - Vendedor - Usuario (logged)
            self.discussion = Discussion.init(discussionId: String(), productId: self.product.productId, seller: self.product.seller, buyer: MainViewModel.user.sender.senderId)
        }
        
        Managers.managerDiscussionFirestore!.selectDiscussion(discussion: self.discussion!, onSuccess: { discussion in
            self.discussion = discussion
            
            /// Buscamos los mensajes de la Discussion recuperada
            Managers.managerMessageFirestore!.selectMessages(discussion: discussion, onSuccess: { messages in
                self.messages = messages
                DispatchQueue.main.async {
                    onSuccess()
                }
                
            }) { error in
                if let retError = onError {
                    DispatchQueue.main.async {
                        retError(error)
                    }
                }
            }
            
        }, onNonexistent: {
            /// Creamos una Discussion nueva
            let discussion: Discussion = Discussion.init(productId: self.product.productId, seller: self.product.seller, buyer: MainViewModel.user.sender.senderId)
            Managers.managerDiscussionFirestore!.insertDiscussion(discussion: discussion, onSuccess: {
                /// Se ha creado una nueva Discussion
                self.discussion = discussion
                
                /// Buscamos los mensajes de la Discussion creada. NO habra ninguno pero hay que activar el Listener
                Managers.managerMessageFirestore!.selectMessages(discussion: discussion, onSuccess: { [weak self] messages in
                    self?.messages = messages
                    DispatchQueue.main.async {
                        onSuccess()
                    }
                    
                }) { error in
                    if let retError = onError {
                        DispatchQueue.main.async {
                            retError(error)
                        }
                    }
                }
                
            }) { error in
                if let retError = onError {
                    DispatchQueue.main.async {
                        retError(error)
                    }
                }
            }
            
        }) { error in
            if let retError = onError {
                DispatchQueue.main.async {
                    retError(error)
                }
            }
        }
    }
    
    func insertMessage(message: Message, onSuccess: @escaping () -> Void, onError: ErrorClosure?) {
        Managers.managerMessageFirestore!.insertMessage(message: message, onSuccess: {
            /// Mensaje insertado en Firestore
            DispatchQueue.main.async {
                onSuccess()
            }
            
        }) { error in
            if let retError = onError {
                DispatchQueue.main.async {
                    retError(error)
                }
            }
        }
    }
    
    func modifyProduct(product: Product, onSuccess: @escaping () -> Void, onError: ErrorClosure?) {
        /// Iniciamos el manager e insertamos el producto
        Managers.managerProductFirestore!.modifyProduct(product: product, onSuccess: {
            DispatchQueue.main.async {
                onSuccess()
            }
            
        }) { error in
            if let retError = onError {
                DispatchQueue.main.async {
                    retError(error)
                }
            }
        }
    }
    
    func updateUser(user: User, onSuccess: @escaping () -> Void, onError: ErrorClosure?) {
        /// Primero subimos la foto
        Managers.managerUserFirestore!.updateUser(user: user, onSuccess: {
            onSuccess()
                
        }) { error in
            if let retError = onError {
                DispatchQueue.main.async {
                    retError(error)
                }
            }
        }
    }
}

