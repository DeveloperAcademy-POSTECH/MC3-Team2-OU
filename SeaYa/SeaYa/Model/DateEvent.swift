//
//  DateEvent.swift
//  SeaYa
//
//  Created by Kihyun Roh on 2023/07/13.
//

import Foundation

struct DateEvent : Hashable, Codable {
    var title : String
    var startDate : Date
    var endDate : Date
    
    enum CodingKeys: String, CodingKey {
        case title
        case startDate
        case endDate
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        startDate = try values.decode(Date.self, forKey: .startDate)
        endDate = try values.decode(Date.self, forKey: .endDate)
    }
    
    init(){
        self.title = "member"
        self.startDate = Date()
        self.endDate = Date(timeIntervalSinceNow: 60*30)
    }
    
    init(title : String, startDate : Date, endDate : Date){
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
    }
}
