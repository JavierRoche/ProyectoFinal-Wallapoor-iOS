//
//  ProductImagesCell.swift
//  Wallapobre
//
//  Created by APPLE on 10/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit
import ImageSlideshow

protocol ProductImagesCellDelegate: class {
    func tapOnImageSlider()
}

class ProductImagesCell: UITableViewCell {
    lazy var pageControl: UIPageControl = {
        let pager: UIPageControl = UIPageControl()
        pager.currentPageIndicatorTintColor = UIColor.black
        pager.pageIndicatorTintColor = UIColor.lightGray
        return pager
    }()
    
    lazy var imageSlide: ImageSlideshow = {
        let slide: ImageSlideshow = ImageSlideshow()//frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 400))
        //slide.slideshowInterval = 10.0
        slide.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slide.contentScaleMode = UIViewContentMode.scaleAspectFit
        slide.pageIndicator = pageControl
        slide.sizeToFit()
        slide.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapPhoto)))
        slide.translatesAutoresizingMaskIntoConstraints = false
        return slide
    }()
    
    
    /// Delegado para la comunicacion con el controlador
    weak var delegate: ProductImagesCellDelegate?
    
    
    //MARK: Life Cycle
    
    public func configureCell(viewModel: DetailProductViewModel) {
        self.setViewsHierarchy()
        self.setConstraints()
        self.setSource(source: viewModel.urls)
    }

    
    // MARK: User Interactors
    
    @objc private func tapPhoto() {
        self.delegate?.tapOnImageSlider()
    }
    
    
    // MARK: Private Functions
        
    fileprivate func setViewsHierarchy() {
        self.addSubview(imageSlide)
    }
    
    fileprivate func setConstraints() {
        NSLayoutConstraint.activate([
            imageSlide.topAnchor.constraint(equalTo: self.topAnchor),
            imageSlide.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageSlide.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageSlide.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageSlide.heightAnchor.constraint(greaterThanOrEqualToConstant: 400.0)
        ])
    }
    
    fileprivate func setSource(source: [KingfisherSource]) {
        self.imageSlide.setImageInputs(source)
    }
}




// MARK: Using CollectionView in TableViewCell

/*
// MARK: UICollectionView DataSource
extension ProductImagesCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel!.product.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieCollectionViewCell.self), for: indexPath) as? MovieCollectionViewCell else { fatalError() }
        
        let url = URL.init(string: self.viewModel!.product.photos[0])
        cell.moviePoster.kf.setImage(with: url!, placeholder: nil, options: nil, progressBlock: nil) { (image,_,_,_) in
            if let image = image {
                cell.moviePoster.image = image
            }
        }
        
        return cell
    }
}


extension ProductImagesCell:  UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.width, height: self.collectionView.bounds.height)
    }
}


class MovieCollectionViewCell: UICollectionViewCell {
    var moviePoster = UIImageView()
    var view: UIView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(moviePoster)
        moviePoster.contentMode = .scaleAspectFill
        moviePoster.isUserInteractionEnabled = true
        moviePoster.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            moviePoster.topAnchor.constraint(equalTo: self.topAnchor),
            moviePoster.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            moviePoster.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            moviePoster.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            moviePoster.widthAnchor.constraint(equalToConstant: self.bounds.size.width),
            moviePoster.heightAnchor.constraint(equalToConstant: 400.0)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
 
lazy var collectionView: UICollectionView = {
    let frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 400)
    let collection = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
    collection.backgroundColor = UIColor.gray
    collection.isPagingEnabled = true
    collection.isUserInteractionEnabled = true
    collection.dataSource = self
    collection.delegate = self
    collection.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: MovieCollectionViewCell.self))
    collection.translatesAutoresizingMaskIntoConstraints = false
    return collection
}()
lazy var flowLayout: UICollectionViewFlowLayout = {
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumInteritemSpacing = 0
    return layout
}()
*/
