//
//  DateModel.swift
//  SeaYa
//
//  Created by Kihyun Roh on 2023/07/13.
//

import Foundation

struct DateMember : Hashable, Decodable{
    var name : String
    var dateEvents : [DateEvent]
}


