//
//  Product.swift
//  Wallapobre
//
//  Created by APPLE on 31/10/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import FirebaseFirestore

class Product {
    public var productId: String
    public var seller: String
    public var state: ProductState
    public var title: String
    public var category: Category
    public var description: String
    public var price: Int
    public var sentDate: Date
    public var photos: [String]
    
    
    // MARK: Inits
    
    public init(productId: String,
                seller: String,
                state: ProductState,
                title: String,
                category: Category.RawValue,
                description: String,
                price: Int,
                sentDate: Date,
                photos: [String]){
        self.productId = productId
        self.seller = seller
        self.state = state
        self.title = title
        self.category = Category(rawValue: category)!
        self.description = description
        self.price = price
        self.sentDate = sentDate
        self.photos = photos
    }
    
    convenience init(seller: String,
                     title: String,
                     category: Category,
                     description: String,
                     price: Int,
                     photos: [String]){
        self.init(productId: UUID().uuidString,
                  seller: seller,
                  state: ProductState.selling,
                  title: title,
                  category: category.rawValue,
                  description: description,
                  price: price,
                  sentDate: Date(),
                  photos: photos)
    }
    
    
    // MARK: Static Class Functions
    
    class func mapper(document: QueryDocumentSnapshot) -> Product {
        let json: [String : Any] = document.data()
        /// Extraemos los valores; como puede venir vacio indicamos un valor por defecto
        let productId = json["productid"] as? String ?? String()
        let seller = json["seller"] as? String ?? String()
        let state = json["state"] as? ProductState.RawValue ?? 0 /// Estado Selling si no puede mapear
        let title = json["title"] as? String ?? String()
        let category = json["category"] as? Category.RawValue ?? 2 /// Categoria Hogar si no puede mapear
        let description = json["description"] as? String ?? String()
        let price = json["price"] as? Int ?? 0
        let sentDate = json["sentDate"] as? Date ?? Date()
        let photo2 = json["photo2"] as? String ?? String()
        let photo3 = json["photo3"] as? String ?? String()
        let photo4 = json["photo4"] as? String ?? String()
        
        var photos: [String] = [String]()
        photos.append(json["photo1"] as? String ?? String())
        if !photo2.isEmpty {
            photos.append(photo2)
        }
        if !photo3.isEmpty {
            photos.append(photo3)
        }
        if !photo4.isEmpty {
            photos.append(photo4)
        }
        
        /// Creamos y devolvemos el objeto Product
        return Product.init(productId: productId, seller: seller, state: ProductState(rawValue: state)!, title: title, category: category, description: description, price: price, sentDate: sentDate, photos: photos)
    }
    
    class func toSnapshot(product: Product) -> [String: Any] {
        /// Creamos el objeto QueryDocumentSnapshot de Firestore y lo devolvemos
        var snapshot = [String: Any]()
        
        snapshot["productid"] = product.productId
        snapshot["seller"] = product.seller
        snapshot["state"] = product.state.rawValue
        snapshot["title"] = product.title
        snapshot["category"] = product.category.rawValue
        snapshot["description"] = product.description
        snapshot["price"] = product.price
        snapshot["sentdate"] = product.sentDate
        snapshot["photo1"] = product.photos[0]
        
        switch product.photos.count {
        case 1:
            snapshot["photo2"] = String()
            snapshot["photo3"] = String()
            snapshot["photo4"] = String()
            
        case 2:
            snapshot["photo2"] = product.photos[1]
            snapshot["photo3"] = String()
            snapshot["photo4"] = String()
            
        case 3:
            snapshot["photo2"] = product.photos[1]
            snapshot["photo3"] = product.photos[2]
            snapshot["photo4"] = String()
            
        case 4:
            snapshot["photo2"] = product.photos[1]
            snapshot["photo3"] = product.photos[2]
            snapshot["photo4"] = product.photos[3]
            
        default:
            break
        }
        
        return snapshot
    }
}
