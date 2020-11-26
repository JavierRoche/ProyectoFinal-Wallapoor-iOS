//
//  UIStringAdditions.swift
//  Wallapobre
//
//  Created by APPLE on 14/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

enum Constants {
    // MARK: TabBar
    
    static let shopping: String = "Shopping"
    static let profile: String = "Profile"
    
    // MARK: Firestore DB
    
    static let firestoreUsers: String = "users"
    static let firestoreProducts: String = "products"
    static let firestoreSearches: String = "searches"
    static let firestoreDiscussions: String = "discussions"
    static let firestoreMessages: String = "messages"
    static let firestoreJpegDirectory: String = "image/jpeg"
    
    // MARK: LoginViewController
    
    static let iconApp: String = "iconApp"
    static let email: String = "Email"
    static let password: String = "Password"
    static let username: String = "Username"
    static let login: String = "Login"
    static let register: String = "Register"
    static let recoverPassword: String = "Recover password"
    static let iconUp: String = "chevron.up"
    static let typeEmail: String = "Type an email"
    static let typePassword: String = "Type a password"
    static let typeUsername: String = "Type an username"
    
    // MARK: MainViewController
    
    static let iconCategoryOff: String = "iconCategoryOff"
    static let iconCategoryOn: String = "iconCategoryOn"
    static let iconStar: String = "star.fill"
    static let iconPlus: String = "plus"
    static let iconArchieveboxFill: String = "archivebox.fill"
    static let iconPersonFill: String = "person.fill"
    static let newParagraph: String = "\n"
    
    // MARK: FiltersViewController
    
    static let filtersByCategory: String = "Filters by category"
    static let filterByDistance: String = "Filter by distance"
    static let iconCheckmark: String = "checkmark"
    static let maxDistance: String = "50"
    
    // MARK: NewProductViewController
    
    static let newProduct: String = "New product"
    static let modifyProduct: String = "Modify product"
    static let title: String = "Title"
    static let productName: String = "Product name"
    static let category: String = "Category"
    static let selectCategory: String = "Select a category"
    static let description: String = "Description"
    static let price: String = "Price"
    static let priceHolder: String = "0"
    static let euro: String = "€"
    static let iconCameraFill: String = "camera.fill"
    static let upload: String = "Upload"
    static let update: String = "Update"
    static let iconImageWarning: String = "exclamationmark.triangle"
    
    // MARK: DetailProductViewController
    
    static let modify: String = "Modify"
    static let chat: String = "Chat"
    static let deleteProduct: String = "Delete product"
    static let lastEdition: String = "Last edition: "
    static let dateFormat: String = "dd-MM-yyyy"
    static let iconEye: String = "eye"
    static let iconLocation: String = "location.circle"
    static let iconAvatarHolder: String = "faceid"
    static let shoppingPlusPipe: String = "shopping |"
    static let sales: String = "sales"
    static let iconFacebook: String = "iconFacebook"
    static let iconTwitter: String = "iconTwitter"
    static let iconWhatsapp: String = "iconWhatsapp"
    
    // MARK: ChatViewController
    
    static let iconChevronLeft: String = "chevron.left"
    static let iconDeal: String = "iconDeal"
    
    // MARK: SellingViewController
    
    static let selectBuyer: String = "Select buyer"
    static let cell: String = "Cell"
    
    // MARK: ProfileViewController
    
    static let logout: String = "Logout"
    static let selling: String = "Selling"
    static let sold: String = "Sold"
    static let searches: String = "Searches"
    static let messages: String = "Messages"
    static let save: String = "Save"
    static let seller: String = "seller"
    static let buyer: String = "buyer"
    
    // MARK: UIAlertController
    
    static let accept: String = "Accept"
    static let cancel: String = "Cancel"
    static let error: String = "Error"
    static let userLogout: String = "User logout"
    static let errorLocation: String = "Location error"
    static let appNeedLocation: String = "Wallapoor needs to get the locations to work"
    static let warning: String = "Warning"
    static let missingData: String = "Missing data"
    static let passwordRecovered: String = "Password recovered\nCheck your email"
    static let saveSearch: String = "Save search"
    static let nameForSearch: String = "Name for search"
    static let success: String = "Success"
    static let productUploaded: String = "Product uploaded"
    static let info: String = "Info"
    static let productDeleted: String = "Product deleted"
    static let uploadProduct: String = "Upload product"
    static let goingToUpload: String = "Going to upload a product"
    static let priceHasToBe: String = "Price has to be a number"
    static let photoRequired: String = "At less 1 photo is required"
    static let goingToDelete: String = "Going to delete a product"
    static let missingSeller: String = "Missing seller"
    static let productUpdated: String = "Product updated"
    static let purchasingProcess: String = "Purchasing process"
    static let buyerSelected: String = "Buyer has been selected"
    static let purchaseCompleted: String = "Purchase completed"
    static let goingToLogout: String = "Going to logout"
    static let updateProfile: String = "Update profile"
    static let goingToUpdate: String = "Going to update profile"
    static let profileUpdated: String = "Profile updated"
    static let personalSearchSaved: String = "Personal search saved"
}
