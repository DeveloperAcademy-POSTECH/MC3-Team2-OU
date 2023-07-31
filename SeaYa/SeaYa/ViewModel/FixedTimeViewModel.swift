//
//  FixedTimeViewModel.swift
//  SeaYa
//
//  Created by Kihyun Roh on 2023/07/27.
//

import Foundation


struct FixedTimeViewModel : Hashable {
    var fixedTimeModels : [FixedTimeModel]
    
    mutating func deleteItem(withID id : UUID){
        self.fixedTimeModels.removeAll {$0.id == id}
    }
    
    init() {
        fixedTimeModels = []
    }
    init(_ fixedTimeModels : [FixedTimeModel]) {
        self.fixedTimeModels = fixedTimeModels
    }
    public func buttonClicked(){
        fixedTimeModels.forEach { model in
            let event = LocalEvent(title: model.category, days: model.weekdays, start: model.start.removeSeconds()!, end: model.end.removeSeconds()!)
            LocalCalendarRepository.shared.createEvent(event: event)
        }
    }
}

struct FixedTimeModel : Hashable, Identifiable, Codable{
    var id : UUID
    var category : String
    var weekdays : [WeekDay]
    var start : Date
    var end : Date
    
    init(){
        id = UUID()
        category = "취침"
        weekdays = [.monday]
        start = DateUtil.createDate(year: 1970, month: 1, day: 1, hour: 9, minute: 00)
        end = DateUtil.createDate(year: 1970, month: 1, day: 1, hour: 17, minute: 00)
    }
    
    init(_ category : String){
        id = UUID()
        self.category = category
        weekdays = [.monday]
        start = DateUtil.createDate(year: 1970, month: 1, day: 1, hour: 9, minute: 00)
        end = DateUtil.createDate(year: 1970, month: 1, day: 1, hour: 17, minute: 00)
    }
}
