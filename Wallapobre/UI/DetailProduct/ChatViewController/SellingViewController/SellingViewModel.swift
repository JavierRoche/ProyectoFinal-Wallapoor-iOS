//
//  SellingViewModel.swift
//  Wallapobre
//
//  Created by APPLE on 19/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

protocol SellingViewModelDelegate: class {
    func viewModelsCreated()
}

class SellingViewModel {
    /// Array para los users descargados
    private var users: [User] = [User]()
    /// Delegado para comunicar la creacion del modelo
    weak var delegate: SellingViewModelDelegate?
    
    
    // MARK: Public Functions
    
    func viewWasLoaded() {
        Managers.managerUserFirestore = UserFirestore()
        Managers.managerUserFirestore!.selectUsers(onSuccess: { users in
            /// Quitamos el user que se corresponda con el user logueado
            self.users = users.compactMap { user in
                if user.sender.senderId != MainViewModel.user.sender.senderId {
                    return user
                }
                return nil
            }
            self.delegate?.viewModelsCreated()
            
        }) { error in
            /// Ha habido error raro
            print(error.localizedDescription)
        }
    }
    
    func numberOfUsers(in section: Int) -> Int {
        return users.count
    }

    func getUser(at indexPath: IndexPath) -> User {
        return users[indexPath.row]
    }
}
