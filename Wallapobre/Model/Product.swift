//
//  Product.swift
//  Wallapobre
//
//  Created by APPLE on 31/10/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import Foundation
import MessageKit

public class Product {
    
    public var sender: SenderType
    public var productId: String
    public var title: String
    public var category: String
    public var description: String
    public var price: Int
    public var sentDate: Date
    public var photos: [String]
    
    public init(sender: Sender, productId: String, title: String, category: String,
                description: String, price: Int, sentDate: Date, photos: [String]){
        self.sender = sender
        self.productId = productId
        self.title = title
        self.category = category
        self.description = description
        self.price = price
        self.sentDate = sentDate
        self.photos = photos
    }
    
    convenience init(sender: Sender, title: String, category: String, description: String, price: Int, photos: [String]){
        self.init(sender: sender, productId: UUID().uuidString, title: title, category: category,
                  description: description, price: price, sentDate: Date(), photos: photos)
    }
    
}


/*extension Product {
    /// Funcion de clase estatica, que mapea un snapshot a un Product
    public class func mapper(json: QueryDocumentSnapshot) -> Product? {
        let messageId = json["messageId"] as? String ?? ""
        
        let senderId = json["senderId"] as? String ?? ""
        let displayName = json["displayName"] as? String ?? ""
        let sender = Sender.init(id: senderId, displayName: displayName)
        
        let dateString = json["sendDate"] as? String ?? ""
        let sendDate = Date.fromStringToDate(input: dateString, format: "yyyy-MM-dd HH:mm:ss")
        
        let type = json["type"] as? String ?? ""
        let messageData: MessageKind
        
        let value = json["value"] as? String ?? ""
        
        switch type {
        case "text":
            messageData = MessageKind.text(value)
        case "image":
            let placeholder = UIImage.init(named: "diehard")
            let mediaItem = ImageMediaItem.init(image: placeholder!)
            messageData = MessageKind.photo(mediaItem)
        default:
            messageData = MessageKind.text(value)
        }
        
        let message = Message.init(sender: sender, messageId: messageId, sentDate: sendDate, kind: messageData, type: type, value: value)
        
        return message
    }
}
*/
