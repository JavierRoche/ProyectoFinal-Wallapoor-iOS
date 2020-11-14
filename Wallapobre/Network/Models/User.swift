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
    public var sender: Sender
    public var email: String
    public var password: String?
    public var username: String?
    public var latitude: Double?
    public var longitude: Double?
    
    
    // MARK: Inits
    
    public init(id: String, email: String, password: String?){
        self.sender = Sender.init(id: id, displayName: email)
        self.email = email
        self.password = password
    }
    
    convenience init(id: String, email: String, username: String, latitude: Double, longitude: Double) {
        self.init(id: id, email: email, password: String())
        
        self.username = username
        self.latitude = latitude
        self.longitude = longitude
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
        
        /// Creamos y devolvemos el objeto User
        return User.init(id: userId, email: email, username: username, latitude: latitude, longitude: longitude)
    }
    
    
    class func toSnapshot(user: User) -> [String: Any] {
        /// Creamos el objeto QueryDocumentSnapshot de Firestore y lo devolvemos
        var snapshot = [String: Any]()
        
        snapshot["userid"] = user.sender.senderId
        snapshot["email"] = user.email
        snapshot["username"] = user.username
        snapshot["latitude"] = user.latitude
        snapshot["longitude"] = user.longitude
        
        return snapshot
    }
}

