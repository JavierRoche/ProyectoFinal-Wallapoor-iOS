//
//  SearchFirestoreManager.swift
//  Wallapobre
//
//  Created by APPLE on 14/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import Foundation

protocol SearchFirestoreManager {
    func selectSearchs(search: Search, onSuccess: @escaping ([Search]) -> Void, onNonexistent: @escaping () -> Void, onError: ErrorClosure?)
    func insertSearch(search: Search, onSuccess: @escaping () -> Void, onError: ErrorClosure?)
}
