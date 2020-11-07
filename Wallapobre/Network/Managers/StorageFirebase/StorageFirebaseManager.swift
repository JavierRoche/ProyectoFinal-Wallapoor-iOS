//
//  StorageFirebaseManager.swift
//  Wallapobre
//
//  Created by APPLE on 06/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

protocol StorageFirebaseManager {
    func saveImageGetUrl(fileName: String, image: UIImage, onSuccess: @escaping (_ url: String) -> Void, onError: ErrorClosure?)
}
