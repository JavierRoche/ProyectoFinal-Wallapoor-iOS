//
//  ChatViewController+InputBar.swift
//  Wallapobre
//
//  Created by APPLE on 19/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView


// MARK: MessagesDisplay Delegate

extension ChatViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {
    func avatarSize(for: MessageType, at: IndexPath, in: MessagesCollectionView) -> CGSize {
        return .zero
    }
   
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView:    MessagesCollectionView) -> CGFloat {
        return 50
    }
}


// MARK: InputBar Delegate

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        /// No se puede unwrappear directamente a String sin el for a components
        for component in inputBar.inputTextView.components {
            if let text = component as? String {
                /// Guardamos el texto en el MessageKind
                let kind = MessageKind.text(text)
                
                /// Inicializamos el objeto del modelo si existe la Discussion
                guard let discussion = self.viewModel.discussion else { return }
                let message = Message.init(senderId: MainViewModel.user.sender.senderId, discussionId: discussion.discussionId, kind: kind, value: text)
                /// Insertamos el mensaje en Firestore. El observer hara la magia
                self.viewModel.insertMessage(message: message, onSuccess: {
                    /// El observer hace el trabajo de añadir el mensaje al modelo
                    self.viewModel.messages.append(message)
                    
                }) { error in
                    self.showAlert(title: Constants.error, message: error.localizedDescription)
                }
            }
        }
        
        inputBar.inputTextView.text = String()
        messagesCollectionView.scrollToBottom()
    }
}
