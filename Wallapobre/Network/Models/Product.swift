//
//  Product.swift
//  Wallapobre
//
//  Created by APPLE on 31/10/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import FirebaseFirestore

class Product {
    var productId: String
    var seller: String
    var state: ProductState
    var title: String
    var category: Category
    var description: String
    var price: Int
    var viewers: Int
    var sentDate: Date
    var photos: [String]
    var heightMainphoto: Double
    
    
    // MARK: Inits
    
    public init(productId: String,
                seller: String,
                state: ProductState,
                title: String,
                category: Category.RawValue,
                description: String,
                price: Int,
                viewers: Int,
                sentDate: Date,
                photos: [String],
                heightMainphoto: Double) {
        self.productId = productId
        self.seller = seller
        self.state = state
        self.title = title
        self.category = Category(rawValue: category)!
        self.description = description
        self.price = price
        self.viewers = viewers
        self.sentDate = sentDate
        self.photos = photos
        self.heightMainphoto = heightMainphoto
    }
    
    convenience init(seller: String,
                     title: String,
                     category: Category,
                     description: String,
                     price: Int,
                     photos: [String],
                     heightMainphoto: Double) {
        self.init(productId: UUID().uuidString,
                  seller: seller,
                  state: ProductState.selling,
                  title: title,
                  category: category.rawValue,
                  description: description,
                  price: price,
                  viewers: 0,
                  sentDate: Date(),
                  photos: photos,
                  heightMainphoto: heightMainphoto)
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
        let viewers = json["viewers"] as? Int ?? 0
        let sentDate = json["sentdate"] as? Timestamp ?? Timestamp.init(date: Date())
        let heightMainphoto = json["heightmainphoto"] as? Double ?? 0.0
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
        return Product.init(productId: productId, seller: seller, state: ProductState(rawValue: state)!, title: title, category: category, description: description, price: price, viewers: viewers, sentDate: sentDate.dateValue(), photos: photos, heightMainphoto: heightMainphoto)
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
        snapshot["viewers"] = product.viewers
        snapshot["sentdate"] = product.sentDate
        snapshot["heightmainphoto"] = product.heightMainphoto
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
