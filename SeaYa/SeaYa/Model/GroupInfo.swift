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
    var selectedDate: [Date]
    var estimatedTime: Int
    
    static func empty() -> GroupInfo{
        return GroupInfo(scheduleName: "err", selectedDate: [Date.now], estimatedTime: 1)
    }
}
