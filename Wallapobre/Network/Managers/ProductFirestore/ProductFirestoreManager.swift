//
//  ProductFirestoreManager.swift
//  Wallapobre
//
//  Created by APPLE on 06/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import Foundation

protocol ProductFirestoreManager {
    func selectProducts(onSuccess: @escaping ([Product]) -> Void, onError: ErrorClosure?)
    func insertProduct(product: Product, onSuccess: @escaping () -> Void, onError: ErrorClosure?)
}
