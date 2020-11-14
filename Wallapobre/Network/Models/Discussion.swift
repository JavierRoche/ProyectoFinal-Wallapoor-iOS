//
//  Discussion.swift
//  Wallapobre
//
//  Created by APPLE on 11/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import Foundation
import FirebaseFirestore

public class Discussion {
    var discussionId: String
    var productId: String
    var seller: String
    var buyer: String
    
    init(discussionId: String, productId: String, seller: String, buyer: String){
        self.discussionId = discussionId
        self.productId = productId
        self.seller = seller
        self.buyer = buyer
    }
    
    convenience init(productId: String, seller: String, buyer: String){
        self.init(discussionId: UUID().uuidString, productId: productId, seller: seller, buyer: buyer)
    }
    
    
    // MARK: Static Class Functions
    
    class func mapper(document: QueryDocumentSnapshot) -> Discussion {
        let json: [String : Any] = document.data()
        /// Extraemos los valores; como puede venir vacio indicamos un valor por defecto
        let discussionId = json["discussionid"] as? String ?? String()
        let productId = json["productid"] as? String ?? String()
        let seller = json["seller"] as? String ?? String()
        let buyer = json["buyer"] as? String ?? String()
        
        /// Creamos y devolvemos el objeto Discussion
        return Discussion.init(discussionId: discussionId, productId: productId, seller: seller, buyer: buyer)
    }
    
    class func toSnapshot(discussion: Discussion) -> [String: Any] {
        /// Creamos el objeto QueryDocumentSnapshot de Firestore y lo devolvemos
        var snapshot = [String: Any]()
        
        snapshot["discussionid"] = discussion.discussionId
        snapshot["productid"] = discussion.productId
        snapshot["seller"] = discussion.seller
        snapshot["buyer"] = discussion.buyer
        
        return snapshot
    }
}
