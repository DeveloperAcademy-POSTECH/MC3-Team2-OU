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
    var isAttend: [UUID: Bool]
}
