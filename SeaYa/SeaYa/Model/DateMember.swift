//
//  DateModel.swift
//  SeaYa
//
//  Created by Kihyun Roh on 2023/07/13.
//

import Foundation

struct DateMember : Hashable, Decodable{
    var id : UUID
    var name : String
    var dateEvents : [DateEvent]
    
    init(id : UUID, name : String){
        self.id = id
        self.name = name
        self.dateEvents = []
    }
}

