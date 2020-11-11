//
//  ProductMapCell.swift
//  Wallapobre
//
//  Created by APPLE on 09/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit
import MapKit

class ProductMapCell: UITableViewCell {
    lazy var iconImage: UIImageView = {
        let image: UIImageView = UIImageView()
        image.image = UIImage(systemName: "location.circle")
        image.tintColor = UIColor.black
        //image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var locationLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle16Regular
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = "LocationLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var mapView: MKMapView = {
        let map: MKMapView = MKMapView()
        map.delegate = self
        map.showsTraffic = false
        map.setCameraZoomRange(MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 10000), animated: true)
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    
    //MARK: Life Cycle
    
    public func configureCell(seller: User) {
        self.setViewsHierarchy()
        self.setConstraints()
        self.setAddress(seller: seller)
        self.setMapLocation(seller: seller)
    }


    /*override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.cornerRadius = 8.0
        contentView.layer.masksToBounds = true
    }*/

    
    // MARK: Private Functions
        
    fileprivate func setViewsHierarchy() {
        self.addSubview(iconImage)
        self.addSubview(locationLabel)
        self.addSubview(mapView)
    }
    
    fileprivate func setConstraints() {
        NSLayoutConstraint.activate([
            iconImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 34.0),
            iconImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            iconImage.widthAnchor.constraint(equalToConstant: 16.0),
            iconImage.heightAnchor.constraint(equalToConstant: 16.0)
        ])
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 32.0),
            locationLabel.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: 8.0),
            locationLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 16.0),
            mapView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -32.0),
            mapView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            mapView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),
            mapView.heightAnchor.constraint(equalToConstant: 200.0)
        ])
    }
    
    fileprivate func setAddress(seller: User) {
        let sellerLocation = CLLocation(latitude: seller.latitude!,
                                        longitude: seller.longitude!)
        
        /// Aplicamos geolocalizacion inversa con un CLGeocoder
        let geocoder = CLGeocoder()
        /// El closure nos devuelve las placemarks o el error
        geocoder.reverseGeocodeLocation(sellerLocation) { [weak self] placemarks, error in
            if let error = error {
                print(error)
            }
            
            guard let placemark = placemarks?.first else {
                print(CLError.geocodeFoundNoResult)
                return
            }
            
            /// Extraemos la informacion, la formateamos y la pintamos
            let postalCode = placemark.postalCode ?? ""
            let locality = placemark.locality ?? ""
            let address = ("\(postalCode), \(locality)")
            self?.locationLabel.text = address
        }
    }
    
    fileprivate func setMapLocation(seller: User) {
        let location2D = CLLocationCoordinate2D(latitude: seller.latitude!, longitude: seller.longitude!)
        mapView.centerCoordinate = location2D
        mapView.addOverlay(MKCircle(center: location2D, radius: 1000))
        mapView.showsTraffic = false
    }
}


// MARK: MKMapViewDelegate Delegate

extension ProductMapCell: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: overlay)
            circleRenderer.fillColor = UIColor.blue
            circleRenderer.alpha = 0.2
            return circleRenderer
        }
        return MKOverlayRenderer()
    }
}
