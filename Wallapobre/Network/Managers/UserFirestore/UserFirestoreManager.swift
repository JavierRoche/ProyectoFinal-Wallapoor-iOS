//
//  UserFirestoreManager.swift
//  Wallapobre
//
//  Created by APPLE on 04/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import Foundation

protocol UserFirestoreManager {
    func selectUsers(onSuccess: @escaping ([User]) -> Void, onError: ErrorClosure?)
    func selectUser(userId: String, onSuccess: @escaping (User?) -> Void, onError: ErrorClosure?)
    func insertUser(user: User, onSuccess: @escaping () -> Void, onError: ErrorClosure?)
    func updateUser(user: User, onSuccess: @escaping () -> Void, onError: ErrorClosure?)
}
