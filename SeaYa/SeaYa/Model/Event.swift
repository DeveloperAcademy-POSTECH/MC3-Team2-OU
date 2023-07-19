//
//  Event.swift
//  calendarTest
//
//  Created by musung on 2023/07/13.
//

import Foundation
// 기본 event 모델
struct Event : Equatable{
    var title: String
    
    var start: Date
    
    var end: Date
}
