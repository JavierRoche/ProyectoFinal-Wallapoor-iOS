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
    func showAlert(forInput: Bool = false, onlyAccept: Bool = true,
                   title: String? = nil, message: String? = nil, actionTitle: String? = Constants.accept,
                   cancelTitle: String? = Constants.cancel, inputPlaceholder: String? = nil,
                   inputKeyboardType: UIKeyboardType = UIKeyboardType.alphabet,
                   cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                   actionHandler: ((_ text: String?) -> Void)? = nil) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        /// Si es para solicitar un texto al user
        if forInput {
            alert.addTextField { (textField:UITextField) in
                textField.placeholder = inputPlaceholder
                textField.keyboardType = inputKeyboardType
            }
            
            alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { action in
                guard let textField =  alert.textFields?.first else {
                    actionHandler?(nil)
                    return
                }
                actionHandler?(textField.text)
            }))
            alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: nil))
        
        } else {
            
            /// Si es para aceptar o cancelar
            if !onlyAccept {
                alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { action in
                    actionHandler?(nil)
                }))
                alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: nil))
                
            } else {
                /// Solo informativo
                alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { action in
                    actionHandler?(nil)
                }))
            }
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}


// MARK: UIImage Personal Utilities

extension UIImage {
    /// Funcion que scala una imagen a un maximo de pixels sin alterar el aspect radio
    func scaleToWidth(scale: CGFloat) -> UIImage {
        let oldWidth = self.size.width
        let scaleFactor = scale / oldWidth

        let newHeight = self.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor;

        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        _ = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}


// MARK: UISwitch Personal Utilities

extension UISwitch {
    /// Funcion que scala un UISwitch al tamaño que queramos
    func set(width: CGFloat, height: CGFloat) {
        let standardHeight: CGFloat = 31
        let standardWidth: CGFloat = 51
        let heightRatio = height / standardHeight
        let widthRatio = width / standardWidth
        self.transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
    }
}


// MARK: UISwitch Personal Utilities

extension Date {
    /// Funcion que transforma una String a un formato dado de Date
    static func fromStringToDate(input: String, format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if let date = dateFormatter.date(from: input) {
            return date
        }
        return Date()
    }

    /// Funcion que transforma un Date una String legible
    static func fromDateToString(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let retString = dateFormatter.string(from: date)
        return retString
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




