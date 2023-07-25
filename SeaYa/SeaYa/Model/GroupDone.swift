//
//  GroupDone.swift
//  SeaYa
//
//  Created by hyebin on 2023/07/25.
//

import Foundation

struct GroupDone: Codable {
    var scheduleName: String
    var choseDate: Date
    var startTime: Int
    var endTime: Int
    var isAttend: Bool
}
