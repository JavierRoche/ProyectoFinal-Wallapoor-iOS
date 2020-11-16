//
//  LoginViewController+Animation.swift
//  Wallapobre
//
//  Created by APPLE on 03/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

// MARK: CAAnimationDelegate Delegate

extension LoginViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if onRegisterInterface == false {
            onRegisterInterface = true
            
            /// Visibilidad de los botones
            loginButton.isHidden = true
            hideButton.isHidden = false
            /// Mostramos los datos para el registro
            usernameLabel.isHidden = false
            usernameTextField.isHidden = false
            
            /// Guardamos los nuevos puntos porque (no se por que) se descolocan tras la animacion
            registerPosition = CGPoint(x: registerPosition.x, y: registerPosition.y + 90)
            loginPosition = CGPoint(x: loginPosition.x, y: loginPosition.y + 90)
            /// Movemos la view tras la animacion para trasladar los Gestures
            registerButton.layer.position = registerPosition
            registerButton.frame.origin = registerPosition
            
        } else {
            onRegisterInterface = false
            
            /// Guardamos los nuevos puntos porque (no se por que) se descolocan tras la animacion
            registerPosition = CGPoint(x: registerPosition.x, y: registerPosition.y + -90)
            loginPosition = CGPoint(x: loginPosition.x, y: loginPosition.y + -90)
            /// Movemos la view tras la animacion para trasladar los Gestures
            registerButton.layer.position = registerPosition
            registerButton.frame.origin = registerPosition
        }
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        if onRegisterInterface == true {
            /// Visibilidad de los botones
            loginButton.isHidden = false
            hideButton.isHidden = true
            /// Ocultamos los datos para el registro
            usernameLabel.isHidden = true
            usernameTextField.isHidden = true
        }
    }
}
