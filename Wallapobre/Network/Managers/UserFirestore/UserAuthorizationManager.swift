//
//  UserManager.swift
//  Wallapobre
//
//  Created by APPLE on 03/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import Foundation

protocol UserAuthorizationManager {
    func register(user: User, onSuccess: @escaping (User) -> Void, onError: ErrorClosure?)
    func login(user: User, onSuccess: @escaping (User) -> Void, onError: ErrorClosure?)
    func recoverPassword(user: User, onSuccess: @escaping (User) -> Void, onError: ErrorClosure?)
    func isLogged(onSuccess: @escaping (User?) -> Void, onError: ErrorClosure?)
    func logout(onSuccess: @escaping () -> Void, onError: ErrorClosure?)
}
