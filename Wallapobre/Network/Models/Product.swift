//
//  Product.swift
//  Wallapobre
//
//  Created by APPLE on 31/10/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import Foundation
import MessageKit

class Product {
    public var productId: String
    public var seller: String
    public var state: ProductState
    public var title: String
    public var category: String
    public var description: String
    public var price: Int
    public var sentDate: Date
    public var photos: [String]
    
    
    // MARK: Inits
    
    public init(productId: String,
                seller: String,
                state: ProductState,
                title: String,
                category: String,
                description: String,
                price: Int,
                sentDate: Date,
                photos: [String]){
        self.productId = productId
        self.seller = seller
        self.state = state
        self.title = title
        self.category = category
        self.description = description
        self.price = price
        self.sentDate = sentDate
        self.photos = photos
    }
    
    convenience init(seller: String,
                     title: String,
                     category: String,
                     description: String,
                     price: Int,
                     photos: [String]){
        self.init(productId: UUID().uuidString,
                  seller: seller,
                  state: ProductState.selling,
                  title: title,
                  category: category,
                  description: description,
                  price: price,
                  sentDate: Date(),
                  photos: photos)
    }
    
    
    // MARK: Static Class Functions
    
    class func toSnapshot(product: Product) -> [String: Any] {
        /// Creamos el objeto QueryDocumentSnapshot de Firestore y lo devolvemos
        var snapshot = [String: Any]()
        
        snapshot["productid"] = product.productId
        snapshot["seller"] = product.seller
        snapshot["state"] = product.state.hashValue
        snapshot["title"] = product.title
        snapshot["category"] = product.category
        snapshot["description"] = product.description
        snapshot["price"] = product.price
        snapshot["sentdate"] = product.sentDate
        snapshot["photo1"] = product.photos[0]
        
        switch product.photos.count {
        case 1:
            snapshot["photo2"] = ""
            snapshot["photo3"] = ""
            snapshot["photo4"] = ""
        case 2:
            snapshot["photo2"] = product.photos[1]
            snapshot["photo3"] = ""
            snapshot["photo4"] = ""
            
        case 3:
            snapshot["photo2"] = product.photos[1]
            snapshot["photo3"] = product.photos[2]
            snapshot["photo4"] = ""
            
        case 4:
            snapshot["photo2"] = product.photos[1]
            snapshot["photo3"] = product.photos[2]
            snapshot["photo4"] = product.photos[3]
            
        default:
            break
        }
        
        return snapshot
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
