//
//  MessageFirestoreManager.swift
//  Wallapobre
//
//  Created by APPLE on 11/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import Foundation

protocol MessageFirestoreManager {
    func selectMessages(discussion: Discussion, onSuccess: @escaping ([Message]) -> Void, onError: ErrorClosure?)
    func insertMessage(message: Message, onSuccess: @escaping () -> Void, onError: ErrorClosure?)
}
