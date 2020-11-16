//
//  Search.swift
//  Wallapobre
//
//  Created by APPLE on 14/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import Foundation
import FirebaseFirestore

public class Search {
    var searchId: String
    var searcher: String
    var title: String
    var filter: Filter
    
    init(searchId: String, searcher: String, title: String, filter: Filter){
        self.searchId = searchId
        self.searcher = searcher
        self.title = title
        self.filter = filter
    }
    
    convenience init(searcher: String,
                     title: String,
                     filter: Filter) {
        self.init(searchId: UUID().uuidString,
                  searcher: searcher,
                  title: title,
                  filter: filter)
    }
    
    // MARK: Static Class Functions
    
    class func mapper(document: QueryDocumentSnapshot) -> Search {
        let json: [String : Any] = document.data()
        /// Extraemos los valores; como puede venir vacio indicamos un valor por defecto
        let searchId = json["searchid"] as? String ?? String()
        let searcher = json["searcher"] as? String ?? String()
        let title = json["title"] as? String ?? String()
        let motor = json["motor"] as? Bool ?? true
        let textile = json["textile"] as? Bool ?? true
        let homes = json["homes"] as? Bool ?? true
        let informatic = json["informatic"] as? Bool ?? true
        let sports = json["sports"] as? Bool ?? true
        let services = json["services"] as? Bool ?? true
        let distance = json["distance"] as? Double ?? 50.0
        let text = json["text"] as? String ?? String()
        let filter = Filter.init(motor: motor, textile: textile, homes: homes, informatic: informatic, sports: sports, services: services, distance: distance, text: text)
        
        /// Creamos y devolvemos el objeto Discussion
        return Search.init(searchId: searchId, searcher: searcher, title: title, filter: filter)
    }
    
    class func toSnapshot(search: Search) -> [String: Any] {
        /// Creamos el objeto QueryDocumentSnapshot de Firestore y lo devolvemos
        var snapshot = [String: Any]()
        
        snapshot["searchid"] = search.searchId
        snapshot["searcher"] = search.searcher
        snapshot["title"] = search.title
        snapshot["motor"] = search.filter.motor
        snapshot["textile"] = search.filter.textile
        snapshot["homes"] = search.filter.homes
        snapshot["informatic"] = search.filter.informatic
        snapshot["sports"] = search.filter.sports
        snapshot["services"] = search.filter.services
        snapshot["distance"] = search.filter.distance
        snapshot["text"] = search.filter.text
        
        return snapshot
    }
}

