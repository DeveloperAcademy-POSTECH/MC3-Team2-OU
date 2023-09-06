//
//  FixedTimeViewModel.swift
//  SeaYa
//
//  Created by Kihyun Roh on 2023/07/27.
//

import Foundation

class FixedTimeViewModel: ObservableObject {
    @Published var fixedTimeModels: [FixedTimeModel]

    init() {
        // LocalCalendarRepository.shared.resetUserDefaults()
        fixedTimeModels = LocalCalendarRepository.shared.getEvents().map { event in
            FixedTimeModel(
                id: event.id,
                category: event.title,
                weekdays: event.days,
                start: event.start,
                end: event.end
            )
        }
    }

    init(_ fixedTimeModels: [FixedTimeModel]) {
        self.fixedTimeModels = fixedTimeModels
    }

    public func buttonClicked() {
        fixedTimeModels.forEach { model in
            let event = LocalEvent(title: model.category, days: model.weekdays, start: model.start.removeSeconds()!, end: model.end.removeSeconds()!)
            LocalCalendarRepository.shared.createEvent(event: event)
        }
    }

    func deleteItem(withID id: UUID) {
        fixedTimeModels.removeAll { $0.id == id }
        if let event = LocalCalendarRepository.shared.getEvent(id: id.uuidString) {
            LocalCalendarRepository.shared.removeEvent(event: event)
        }
    }

    func getItem(_ id: String) -> FixedTimeModel {
        return fixedTimeModels.filter { item in
            item.id.uuidString == id
        }.first ?? FixedTimeModel()
    }

    func addItem(item: FixedTimeModel) {
        fixedTimeModels.append(item)
        LocalCalendarRepository.shared.createEvent(event: LocalEvent(id: item.id, title: item.category, days: item.weekdays, start: item.start, end: item.end))
    }

    func updateItem(item: FixedTimeModel) {
        fixedTimeModels = fixedTimeModels.map { model in
            item.id == model.id ? item : model
        }
        LocalCalendarRepository.shared.createEvent(event: LocalEvent(id: item.id, title: item.category, days: item.weekdays, start: item.start, end: item.end))
    }

    func isExist(_ id: String) -> Bool {
        return (fixedTimeModels.filter { item in
            item.id.uuidString == id
        }.first != nil) ? true : false
    }
}

struct FixedTimeModel: Hashable, Identifiable, Codable {
    var id: UUID
    var category: String
    var weekdays: [WeekDay]
    var start: Date
    var end: Date

    init() {
        id = UUID()
        category = "취침"
        weekdays = [.monday]
        start = DateUtil.createDate(year: 1970, month: 1, day: 1, hour: 9, minute: 00)
        end = DateUtil.createDate(year: 1970, month: 1, day: 1, hour: 17, minute: 00)
    }

    init(_ category: String) {
        id = UUID()
        self.category = category
        weekdays = [.monday]
        start = DateUtil.createDate(year: 1970, month: 1, day: 1, hour: 9, minute: 00)
        end = DateUtil.createDate(year: 1970, month: 1, day: 1, hour: 17, minute: 00)
    }

    init(id: UUID, category: String, weekdays: [WeekDay], start: Date, end: Date) {
        self.id = id
        self.category = category
        self.weekdays = weekdays
        self.start = start
        self.end = end
    }
}
