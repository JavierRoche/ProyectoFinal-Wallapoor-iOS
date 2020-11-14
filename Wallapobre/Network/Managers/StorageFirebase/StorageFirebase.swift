//
//  StorageFirebase.swift
//  Wallapobre
//
//  Created by APPLE on 06/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit
import FirebaseStorage

class StorageFirebase: StorageFirebaseManager {
    public func saveImageGetUrl(fileName: String, image: UIImage, onSuccess: @escaping (_ url: String) -> Void, onError: ErrorClosure?) {
        /// Inicializamos en el Storage de Firebase el archivo
        let ref = Storage.storage().reference().child(fileName)
        /// Pasamos la UIImage a Data de Firebase redimensionando al 25%
        if let imageData: Data = image.jpegData(compressionQuality: 0.15){
            
            /// Objeto de tipo StorageMetadata que contiene las caracteristicas del fichero
            let metadata: StorageMetadata = StorageMetadata()
            metadata.contentType = Constants.jpegDirectory
            //metadata.customMetadata = ["productid": "productid"]

            /// Intentamos guardar el fichero en Cloud Storage con la imagen en Data y el StorageMetadata
            ref.putData(imageData, metadata: metadata) { (metadata, error) in
                if let error = error, let retError = onError {
                    retError(error)
                }
                
                /// Sino el upload no genera error, intentamos recuperar la url de la imagen
                ref.downloadURL { (url, error) in
                    if let error = error, let retError = onError {
                        retError(error)
                    }
                    /// Obtenemos la url y la devolvemos
                    if let url = url {
                        onSuccess(url.absoluteString)
                    }
                }
            }
        }
    }
}
