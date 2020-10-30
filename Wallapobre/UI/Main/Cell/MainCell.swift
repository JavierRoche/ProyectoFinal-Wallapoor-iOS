//
//  MainCell.swift
//  UICollectionViewCustomLayout
//
//  Created by Roberto Garrido on 10/05/2020.
//  Copyright © 2020 Roberto Garrido. All rights reserved.
//

import UIKit

class MainCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    var viewModel: MainCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            imageView.image = viewModel.image
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.cornerRadius = 8.0
        contentView.layer.masksToBounds = true
    }

}
