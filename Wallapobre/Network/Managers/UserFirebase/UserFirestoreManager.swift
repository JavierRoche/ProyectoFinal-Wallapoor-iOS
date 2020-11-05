//
//  UserFirestoreManager.swift
//  Wallapobre
//
//  Created by APPLE on 04/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import Foundation

public protocol UserFirestoreManager {
    func userCheck(user: User, onSuccess: @escaping (User) -> Void, onNonexistent: @escaping () -> Void, onError: ErrorClosure?)
}
