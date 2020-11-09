//
//  DetailProductViewController.swift
//  Wallapobre
//
//  Created by APPLE on 09/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

class DetailProductViewController: UIViewController {
    lazy var backgroundView: UIView = {
        let view: UIView = UIView(frame: self.view.bounds)
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle16Regular
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = "TITLE"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
