//
//  DateEvent.swift
//  SeaYa
//
//  Created by Kihyun Roh on 2023/07/13.
//

import Foundation

struct DateEvent : Hashable, Decodable {
    var title : String
    var startDate : Date
    var endDate : Date
    
    init(){
        self.title = "member"
        self.startDate = Date()
        self.endDate = Date(timeIntervalSinceNow: 60*30)}
    
    init(title : String, startDate : Date, endDate : Date){
        self.title = title
        self.startDate = startDate
        self.endDate = endDate}}
