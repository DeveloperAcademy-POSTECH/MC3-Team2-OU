//
//  MessageWrapper.swift
//  SeaYa
//
//  Created by hyebin on 2023/07/25.
//

import Foundation

struct MessageWrapper<T: Codable>: Codable {
    let messageType: MessageType
    let data: T
}

enum MessageType: String, Codable {
    case GroupInfo
    case ListUP
    case ScheduleDone
    case CheckTimeDone
}
