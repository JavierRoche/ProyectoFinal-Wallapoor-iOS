//
//  User.swift
//  Wallapobre
//
//  Created by APPLE on 03/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import MessageKit
import FirebaseFirestore

class User {
    var sender: Sender
    var email: String
    var password: String?
    var username: String
    var latitude: Double
    var longitude: Double
    var avatar: String
    var shopping: Int
    var sales: Int
    
    
    // MARK: Inits
    
    public init(id: String, email: String, password: String?){
        self.sender = Sender.init(id: id, displayName: email)
        self.email = email
        self.password = password
        self.username = String()
        self.latitude = 0
        self.longitude = 0
        self.avatar = String()
        self.shopping = 0
        self.sales = 0
    }
    
    convenience init(id: String, email: String, username: String, latitude: Double, longitude: Double, avatar: String, shopping: Int, sales: Int) {
        self.init(id: id, email: email, password: String())
        
        self.username = username
        self.latitude = latitude
        self.longitude = longitude
        self.avatar = avatar
        self.shopping = shopping
        self.sales = sales
    }
    
    
    // MARK: Static Class Functions
    
    class func mapper(document: QueryDocumentSnapshot) -> User {
        let json: [String : Any] = document.data()
        /// Extraemos los valores; como puede venir vacio indicamos un valor por defecto
        let userId = json["userid"] as? String ?? String()
        let email = json["email"] as? String ?? String()
        let username = json["username"] as? String ?? String()
        let latitude = json["latitude"] as? Double ?? 0.0
        let longitude = json["longitude"] as? Double ?? 0.0
        let avatar = json["avatar"] as? String ?? String()
        let shopping = json["shopping"] as? Int ?? Int()
        let sales = json["sales"] as? Int ?? Int()
        
        /// Creamos y devolvemos el objeto User
        return User.init(id: userId, email: email, username: username, latitude: latitude, longitude: longitude, avatar: avatar, shopping: shopping, sales: sales)
    }
    
    
    class func toSnapshot(user: User) -> [String: Any] {
        /// Creamos el objeto QueryDocumentSnapshot de Firestore y lo devolvemos
        var snapshot = [String: Any]()
        
        snapshot["userid"] = user.sender.senderId
        snapshot["email"] = user.email
        snapshot["username"] = user.username
        snapshot["latitude"] = user.latitude
        snapshot["longitude"] = user.longitude
        snapshot["avatar"] = user.avatar
        snapshot["shopping"] = user.shopping
        snapshot["sales"] = user.sales
        
        return snapshot
    }
}

