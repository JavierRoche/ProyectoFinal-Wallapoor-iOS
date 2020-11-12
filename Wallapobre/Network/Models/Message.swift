//
//  Message.swift
//  Wallapobre
//
//  Created by APPLE on 11/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import Foundation
import MessageKit
import FirebaseFirestore

public class Message: MessageType {
    
    public var sender: SenderType
    public var discussionId: String
    public var messageId: String
    public var sentDate: Date
    public var kind: MessageKind
    public var value: String
    
    public init(senderId: String, discussionId: String, messageId: String, sentDate: Date, kind: MessageKind, value: String){
        self.sender = Sender.init(id: senderId, displayName: discussionId)
        self.discussionId = discussionId
        self.messageId = messageId
        self.sentDate = sentDate
        self.kind = kind
        self.value = value
    }
    
    convenience init(senderId: String, discussionId: String, kind: MessageKind, value: String){
        self.init(senderId: senderId,
                  discussionId: discussionId,
                  messageId: UUID().uuidString,
                  sentDate: Date(),
                  kind: kind,
                  value: value)
    }
    
    
    // MARK: Static Class Functions
    
    class func mapper(document: QueryDocumentSnapshot) -> Message {
        let json: [String : Any] = document.data()
        /// Extraemos los valores; como puede venir vacio indicamos un valor por defecto
        let senderId = json["senderid"] as? String ?? ""
        let discussionId = json["discussionid"] as? String ?? ""
        let messageId = json["messageid"] as? String ?? ""
        let sentDate = json["sentdate"] as? Date ?? Date()
        let value = json["value"] as? String ?? ""
        
        /// Creamos y devolvemos el objeto Product
        return Message.init(senderId: senderId, discussionId: discussionId, messageId: messageId, sentDate: sentDate, kind: MessageKind.text(value), value: value)
    }
    
    class func toSnapshot(message: Message) -> [String: Any] {
        /// Creamos el objeto QueryDocumentSnapshot de Firestore y lo devolvemos
        var snapshot = [String: Any]()
        
        snapshot["senderid"] = message.sender.senderId
        snapshot["discussionid"] = message.discussionId
        snapshot["messageid"] = message.messageId
        snapshot["sentdate"] = message.sentDate
        snapshot["value"] = message.value
        
        return snapshot
    }
}
