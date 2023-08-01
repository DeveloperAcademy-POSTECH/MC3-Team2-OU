//
//  ScheduleDone.swift
//  SeaYa
//
//  Created by hyebin on 2023/07/25.
//

import Foundation

struct ScheduleDone: Codable { 
    var scheduleName: String
    var selectedDate: Date
    var startTime: Date
    var endTime: Date
    var isAttend: [String : Bool] // UUID, true or false
    
    init(scheduleName: String, selectedDate: Date, startTime: Date, endTime: Date, isAttend: [String : Bool]) {
        self.scheduleName = scheduleName
        self.selectedDate = selectedDate
        self.startTime = startTime
        self.endTime = endTime
        self.isAttend = isAttend
    }
    
    init() {
        self.scheduleName = ""
        self.selectedDate = Date()
        self.startTime = Date()
        self.endTime = Date()
        self.isAttend = [:]
    }
}
