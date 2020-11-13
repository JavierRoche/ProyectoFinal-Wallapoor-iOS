//
//  Extensions.swift
//  Wallapobre
//
//  Created by APPLE on 01/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit
import MessageKit

// MARK: UIViewController Personal Utilities
extension UIViewController {
    /// Mensajes de alerta informativos
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}


struct ImageMediaItem: MediaItem {

    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize

    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }

}


enum Category: Int {
    case motor = 0
    case textile
    case homes
    case informatic
    case sports
    case services
    
    var name: String {
        switch self {
        case .motor:
            return "Motor y Accesorios"
        case .textile:
            return "Textil"
        case .homes:
            return "Hogar"
        case .informatic:
            return "Informática y Electrónica"
        case .sports:
            return "Deporte y Ocio"
        case .services:
            return "Servicios"
        }
    }
}

enum ProductState: Int {
    case selling = 0
    case sold = 1
}

public typealias ErrorClosure = (Error) -> Void
