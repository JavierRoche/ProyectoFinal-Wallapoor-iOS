//
//  ChatViewController+Source.swift
//  Wallapobre
//
//  Created by APPLE on 19/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import Foundation
import MessageKit


// MARK: Messages DataSource

extension ChatViewController: MessagesDataSource {
    func fetchMessages() {
        /// Iniciamos el manager de Discussion
        Managers.managerDiscussionFirestore = DiscussionFirestore()
        Managers.managerMessageFirestore = MessageFirestore()
        
        viewModel.initDiscussionChat(onSuccess: {
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToBottom()
            
        }) { error in
            self.showAlert(title: Constants.error, message: error.localizedDescription)
        }
    }
    
    /// Identificador para el usuario que envia el mensaje
    func currentSender() -> SenderType {
        return MainViewModel.user.sender
    }
    
    /// Evento delegado que devuelve el mensaje de cada item
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return self.viewModel.messages[indexPath.section]
    }
    
    /// Evento delegado que devuelve el numero de mensajes
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return self.viewModel.messages.count
    }
}
