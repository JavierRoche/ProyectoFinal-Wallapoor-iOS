//
//  Manager.swift
//  Wallapobre
//
//  Created by APPLE on 04/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import Foundation

class Managers {
    /// Manager de autentificacion de usuario
    static var managerUserAuthoritation: UserAuthoritation?
    /// Manager de tabla de Usuarios en Firestore
    static var managerUserFirestore: UserFirestore?
    /// Manager de gestion con MapKit
    static var managerUserLocation: UserLocation?
    /// Manager de manejo de documentos en Cloud Firestore
    static var managerStorageFirebase: StorageFirebase?
    /// Manager de tabla de Productos en Firestore
    static var managerProductFirestore: ProductFirestore?
    /// Manager de tabla de Discussion (chat) en Firestore
    static var managerDiscussionFirestore: DiscussionFirestore?
    /// Manager de tabla de Messages (chat) en Firestore
    static var managerMessageFirestore: MessageFirestore?
    /// Manager de tabla de Busquedas en Firestore
    static var managerSearchFirestore: SearchFirestore?
}
