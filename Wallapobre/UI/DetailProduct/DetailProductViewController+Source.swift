//
//  DetailProductViewController+Source.swift
//  Wallapobre
//
//  Created by APPLE on 10/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit
import ImageSlideshow


// MARK: UITableView Delegate

extension DetailProductViewController: UITableViewDelegate {
    /// Funcion delegada para la seleccion de una celda de la tabla
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// Deseleccionamos la celda
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: UITableView Data Source

extension DetailProductViewController: UITableViewDataSource {
    /// Funcion delegada del numero de celda de la tabla
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _ = self.viewModel.seller else { return 0 }
        return 6
    }
    
    /// Funcion delegada de llenado de la tabla
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            /// Celda con la informacion del producto
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductImagesCell.self), for: indexPath) as? ProductImagesCell else { fatalError() }
            cell.delegate = self
            cell.configureCell(viewModel: self.viewModel)
            return cell
         
        case 1:
            /// Celda con la informacion del producto
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductDataCell.self), for: indexPath) as? ProductDataCell else { fatalError() }
            cell.configureCell(viewModel: self.viewModel)
            return cell
            
        case 2:
            /// Celda con la informacion de ultima edicion y viewers
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductDataEditionCell.self), for: indexPath) as? ProductDataEditionCell else { fatalError() }
            cell.configureCell(viewModel: self.viewModel)
            return cell

        case 3:
            /// Celda con la localizacion y el mapa
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductMapCell.self), for: indexPath) as? ProductMapCell else { fatalError() }
            cell.configureCell(viewModel: self.viewModel)
            return cell

        case 4:
            /// Celda con la informacion del vendedor
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductSellerCell.self), for: indexPath) as? ProductSellerCell else { fatalError() }
            cell.configureCell(viewModel: self.viewModel)
            return cell
        
        case 5:
            /// Celda con las opciones de compartir en redes
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductSocialNetworksCell.self), for: indexPath) as? ProductSocialNetworksCell else { fatalError() }
            //cell.delegate = self
            cell.configureCell()
            return cell

        default:
            break
        }
        
        return UITableViewCell()
    }
}
