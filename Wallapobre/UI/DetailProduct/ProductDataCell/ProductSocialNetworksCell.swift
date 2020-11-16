//
//  ProductSocialNetworksCell.swift
//  Wallapobre
//
//  Created by APPLE on 09/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

protocol ProductSocialNetworksCellDelegate: class {
    func taponface()
}

class ProductSocialNetworksCell: UITableViewCell {
    lazy var stackView: UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.backgroundColor = UIColor.green
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var facebookImageView: UIImageView = {
        let image: UIImageView = UIImageView()
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shareOnFacebook)))
        image.layer.cornerRadius = 8.0
        image.image = UIImage(named: "facebook_icon")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var twitterImageView: UIImageView = {
        let image: UIImageView = UIImageView()
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shareOnTwitter)))
        image.layer.cornerRadius = 8.0
        image.image = UIImage(named: "twitter_icon")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var whatsappImageView: UIImageView = {
        let image: UIImageView = UIImageView()
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shareOnWhatsApp)))
        image.layer.cornerRadius = 8.0
        image.image = UIImage(named: "whatsapp_icon")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    weak var delegate: ProductSocialNetworksCellDelegate?
    
    
    //MARK: Life Cycle
    
    public func configureCell() {
        self.setViewsHierarchy()
        self.setConstraints()
        /// El interespaciado de los stack hay que definirlo una vez el objeto creado
        stackView.setCustomSpacing(40, after: facebookImageView)
        stackView.setCustomSpacing(40, after: twitterImageView)
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //contentView.layer.cornerRadius = 8.0
        //contentView.layer.masksToBounds = true
    }

    
    // MARK: User Interactions
    
    @objc private func shareOnFacebook() {
        //delegate?.taponface()
        /// Abrimos la aplicacion para el propio usuario
       if UIApplication.shared.canOpenURL(URL.init(string: "fb://profile/yourUSERNAME")!) {
            UIApplication.shared.open(URL.init(string: "fb://profile/yourUSERNAME")!)
            
        } else {
            UIApplication.shared.open(URL(string: "https://www.facebook.com/yourUSERNAME")!)
        }
    }
    
    @objc private func shareOnTwitter() {
        /// Abrimos la aplicacion para el propio usuario
        if UIApplication.shared.canOpenURL(URL(string: "twitter://user?screen_name=yourUSERNAME")!) {
            UIApplication.shared.open(URL(string: "twitter://user?screen_name=yourUSERNAME")!)
            
        } else {
            UIApplication.shared.open(URL(string: "https://twitter.com/yourUSERNAME")!)
        }
    }
    
    @objc private func shareOnWhatsApp() {
        /// Abrimos la aplicacion para el propio usuario
        if UIApplication.shared.canOpenURL(URL(string: "whatsapp://")!) {
            UIApplication.shared.open(URL(string: "whatsapp://")!)
            
        } else {
            UIApplication.shared.open(URL(string: "https://www.whatsapp.com/yourUSERNAME")!)
        }
        /*let urlWhats = "://"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = NSURL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                    UIApplication.shared.open(whatsappURL as URL)
                } else {
                    print("Error")
                }
            }
        }*/
    }
    
    
    // MARK: Private Functions
        
    fileprivate func setViewsHierarchy() {
        self.addSubview(stackView)
        
        stackView.addArrangedSubview(facebookImageView)
        stackView.addArrangedSubview(twitterImageView)
        stackView.addArrangedSubview(whatsappImageView)
    }
    
    
    
    fileprivate func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32.0),
            stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -32.0),
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            facebookImageView.widthAnchor.constraint(equalToConstant: 32.0),
            facebookImageView.heightAnchor.constraint(equalToConstant: 32.0)
        ])
        
        NSLayoutConstraint.activate([
            twitterImageView.widthAnchor.constraint(equalToConstant: 32.0),
            twitterImageView.heightAnchor.constraint(equalToConstant: 32.0)
        ])
        
        NSLayoutConstraint.activate([
            whatsappImageView.widthAnchor.constraint(equalToConstant: 32.0),
            whatsappImageView.heightAnchor.constraint(equalToConstant: 32.0)
        ])
    }
}


