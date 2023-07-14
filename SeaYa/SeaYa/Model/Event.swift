//
//  Event.swift
//  calendarTest
//
//  Created by musung on 2023/07/13.
//

import Foundation
// 기본 event 모델
protocol Event{
    var title:String{get}
    var start:Date{get}
    var end:Date{get}
}
