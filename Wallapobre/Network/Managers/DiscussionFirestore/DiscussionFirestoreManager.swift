//
//  DiscussionFirestoreManager.swift
//  Wallapobre
//
//  Created by APPLE on 11/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import Foundation

protocol DiscussionFirestoreManager {
    func selectDiscussion(discussion: Discussion, onSuccess: @escaping (Discussion) -> Void, onNonexistent: @escaping () -> Void, onError: ErrorClosure?)
    func insertDiscussion(discussion: Discussion, onSuccess: @escaping () -> Void, onError: ErrorClosure?)
}
