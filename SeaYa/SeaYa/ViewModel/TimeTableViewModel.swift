//
//  TimeTableViewModel.swift
//  SeaYa
//
//  Created by musung on 2023/07/18.
//

import Foundation

class TimeTableViewModel: ObservableObject{
    typealias Calendar = Dictionary<String,[Event]>
    let localCalendarRepo = LocalCalendarRepository.shared
    let remoteCalendarRepo = RemoteCalendarRepository.shared
    let calendarService = CalendarService.shared
    let timeTableService = TimeTableService.shared
    var selectedDay:[String]
    var tableCalendar = Dictionary<String,[TableItem]>()
    @Published var selectedItem: Set<TableItem> = []
    @Published var current:TableItem?
    @Published var selectedEventCalendar = Calendar()
    @Published var calendar: Calendar?
    
    init(selectedDay: [String]) {
        self.selectedDay = selectedDay
        selectedDay.forEach { day in
            selectedEventCalendar.updateValue([], forKey: day)
        }
        Task{
            //await makeTestCal()
            calendar = await getCalendar()
            tableCalendar = calToTableCal(calendar!)
        }
    }
    private func calToTableCal(_ cal:Calendar) -> Dictionary<String,[TableItem]>{
        var tableCalendar = Dictionary<String,[TableItem]>()
        cal.keys.sorted().forEach { day in
            let tableItems = eventToTableItem(cal[day]!)
            tableCalendar.updateValue(tableItems, forKey: day)
        }
        return tableCalendar
    }
    public func eventToTableItem(_ events:[Event]) -> [TableItem]{
        return events.map { event in
            TableItem(event)
        }
    }
    public func buttonClicked(userData: UserData,connectionManager: ConnectionService){
        let selectedDateEvent = selectedItem.map { item in
            DateEvent(title: item.event.title, startDate: item.event.start, endDate: item.event.end)
        }
        if connectionManager.isHosting{
            
        }
        else{
            let dateMember = DateMember(id: UUID(uuidString: userData.uid)!, name: userData.nickname, dateEvents: selectedDateEvent)
            connectionManager.sendTimeTableInfoToHost(dateMember)
        }
    }
//    private func makeTestCal()async{
//        let selectedDays = ["2023-07-16","2023-07-17","2023-07-18"]
//        let date1 = DateUtil.createDate(year: 2023, month: 7, day: 16, hour: 9, minute: 30)
//        let date2 = DateUtil.createDate(year: 2023, month: 7, day: 17, hour: 18, minute: 00)
//        let date3 = DateUtil.createDate(year: 2023, month: 7, day: 18, hour: 19, minute: 30)
//        let date4 = DateUtil.createDate(year: 2023, month: 7, day: 16, hour: 11, minute: 30)
//        let date5 = DateUtil.createDate(year: 2023, month: 7, day: 17, hour: 12, minute: 00)
//        let date6 = DateUtil.createDate(year: 2023, month: 7, day: 18, hour: 13, minute: 30)
//        var localEvents = [LocalEvent]()
//        var  remoteEvents = [Event]()
//        localEvents = [
//            LocalEvent(title: "test1", days: [.monday,.tuesday,.thursday], start: date1, end: date1.advanced(by: 3600)),
//            LocalEvent(title: "test2", days: [.wednesday], start: date2, end: date2.advanced(by: 3600)),
//            LocalEvent(title: "test3", days: [.sunday], start: date3, end: date3.advanced(by: 3600)),
//        ]
//        remoteEvents = [
//            Event(title: "test4", start: date4, end: date4.advanced(by: 3600)),
//            Event(title: "test5", start: date5, end: date5.advanced(by: 3600)),
//            Event(title: "test6", start: date6, end: date6.advanced(by: 3600)),
//        ]
//        localEvents.forEach { event in
//            localCalendarRepo.createEvent(event: event)
//        }
//        remoteEvents.forEach { event in
//            Task{
//                try await remoteCalendarRepo.createEvent(event:event)
//            }
//        }
//
//    }
   @MainActor private func getCalendar() async -> Calendar {
        let localEvents = localCalendarRepo.getEvents()
        let remoteEvents = try! await remoteCalendarRepo.fetchEvent(start: DateUtil.formattedDayToDate(selectedDay.first!), end: DateUtil.formattedDayToDate(selectedDay.last!))
        let localCalendar = calendarService.makeCalendar(selectedDay,localEvents)
        let remoteCalendar = calendarService.makeCalendar(selectedDay, remoteEvents)
        let mergedCalendar = calendarService.mergeCalendar(localCalendar, remoteCalendar)
        let timeTableCalendar = timeTableService.getCalendarForTimeTable(mergedCalendar)
        return timeTableCalendar
    }
    //1. timeTable에 넣을 데이터 준비 및 제공
    //2. 선택된 event 반환
}
