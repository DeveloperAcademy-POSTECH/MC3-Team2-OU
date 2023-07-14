//
//  LocalEvent.swift
//  calendarTest
//
//  Created by musung on 2023/07/13.
//

import Foundation
//local에 저장할 이벤트 모델
struct LocalEvent: Codable,Event{
    var id: UUID = UUID()
    let title:String
    let days:[WeekDay]
    let start: Date
    let end: Date
}
