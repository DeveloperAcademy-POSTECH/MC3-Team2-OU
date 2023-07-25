//
//  GroupInfo.swift
//  SeaYa
//
//  Created by hyebin on 2023/07/25.
//

import Foundation

struct GroupInfo: Codable {
    var hostName: String?
    var scheduleName: String
    var choseDate: [Date]
    var estimatedTime: Int
}
