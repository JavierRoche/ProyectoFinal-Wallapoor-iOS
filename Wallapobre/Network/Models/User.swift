//
//  User.swift
//  Wallapobre
//
//  Created by APPLE on 03/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import Foundation
import MessageKit

public class User {
    
    public var email: String
    public var password: String?
    public var sender: Sender
    
    init(id: String, email: String, password: String?){
        self.sender = Sender.init(id: id, displayName: email)
        self.email = email
        self.password = password
    }
}

