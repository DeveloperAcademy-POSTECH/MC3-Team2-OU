//
//  DateModel.swift
//  SeaYa
//
//  Created by Kihyun Roh on 2023/07/13.
//

import Foundation

struct DateMember : Hashable, Codable{
    var id : UUID
    var name : String
    var dateEvents : [DateEvent]
    var profileImage : String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case dateEvents
        case profileImage
    }
    
    init(id : UUID, name : String){
        self.id = id
        self.name = name
        self.dateEvents = []
        self.profileImage = "01"
    }
    init(id: UUID, name: String, dateEvents : [DateEvent]){
        self.id = id
        self.name = name
        self.dateEvents = dateEvents
        self.profileImage = "01"
    }
    init(name : String, dateEvents : [DateEvent]){
        self.id = UUID()
        self.name = name
        self.dateEvents = dateEvents
        self.profileImage = "01"
    }
    
    init(id: UUID, name: String, dateEvents : [DateEvent], profileImage : String){
        self.id = id
        self.name = name
        self.dateEvents = dateEvents
        self.profileImage = profileImage
    }
}

