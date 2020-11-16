//
//  ChatViewController.swift
//  Wallapobre
//
//  Created by APPLE on 11/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController {
    /// Objeto con el que acceder al manager de Productos
    var viewModel: ChatViewModel!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        guard let _ = viewModel else { return }
        
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        //self.setStyle()
        self.fetchMessages()
        
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: Constants.arrowIcon), style: .plain, target: self, action: #selector(backButtonTapped))
        leftBarButtonItem.tintColor = .black
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    
    // MARK: User Interactors
    
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}


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
            DispatchQueue.main.async { [weak self] in
                self?.showAlert(title: Constants.Error, message: error.localizedDescription)
            }
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


// MARK: MessagesDisplay Delegate

extension ChatViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {  // Probar a quitar la de layout
    
   func avatarSize(for: MessageType, at: IndexPath, in: MessagesCollectionView) -> CGSize {
       return .zero
   }
   
   func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
       return 50
   }
   
   func defaultStyle() {
       let newMessageInputBar = MessageInputBar()
       newMessageInputBar.sendButton.tintColor = UIColor.black
       newMessageInputBar.delegate = self
       messageInputBar = newMessageInputBar
       reloadInputViews()
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
                    
                }) { error in
                    DispatchQueue.main.async { [weak self] in
                        self?.showAlert(title: Constants.Error, message: error.localizedDescription)
                    }
                }
            }
        }
        
        inputBar.inputTextView.text = String()
        messagesCollectionView.scrollToBottom()
    }
}
