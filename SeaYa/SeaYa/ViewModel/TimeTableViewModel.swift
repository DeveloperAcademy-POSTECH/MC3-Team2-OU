//
//  TimeTableViewModel.swift
//  SeaYa
//
//  Created by musung on 2023/07/18.
//

import Foundation

final class TimeTableViewModel: ObservableObject{
    typealias Calendar = Dictionary<String,[Event]>
    static let shared: TimeTableViewModel = .init()
    let localCalendarRepo = LocalCalendarRepository.shared
    let remoteCalendarRepo = RemoteCalendarRepository.shared
    let calendarService = CalendarService.shared
    let timeTableService = TimeTableService.shared
    var selectedDay:[String] = []
    var tableCalendar = Dictionary<String,[TableItem]>()
    @Published var selectedItem: Set<TableItem> = []
    @Published var current:TableItem?
    @Published var selectedEventCalendar = Calendar()
    @Published var calendar: Calendar?
    
    @Published var xArray : [CGFloat] = []
    @Published var yArray : [CGFloat] = []
    @Published var canvasSize : CGRect?
    @Published var isFirstSelectd : Bool?
    @Published var cellSize : CGRect?
    @Published var xStartIndex : Int?
    @Published var yStartIndex : Int?
    @Published var xEndIndex : Int?
    @Published var yEndIndex : Int?
    @Published var indexDay = Dictionary<Int, String>()
    
    @Published var available : Bool?
    
    private init(){}
    @MainActor
    public func setSelectedDay(selectedDay: [String]){
        clear()
        self.selectedDay = selectedDay.sorted()
        selectedDay.forEach { day in
            selectedEventCalendar.updateValue([], forKey: day)
        }
        task()
    }
    private func clear(){
        selectedItem = []
        current = nil
        selectedEventCalendar = Calendar()
        calendar = nil
    }
    @MainActor
    private func task(){
        Task{
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
        let dateMember = DateMember(id: UUID(uuidString: userData.uid)!,
                                    name: userData.nickname,
                                    dateEvents: selectedDateEvent,
                                    profileImage: userData.characterImageName
        )
        if !connectionManager.isHosting{
            connectionManager.listUP.append(dateMember)
        }
        else{
            connectionManager.sendTimeTableInfoToHost(dateMember)
        }
    }
    
   @MainActor
    private func getCalendar() async -> Calendar {
        let localEvents = localCalendarRepo.getEvents()
        let start = DateUtil.formattedDayToDate(selectedDay.first!)
        let last = DateUtil.formattedDayToDate(selectedDay.last!).addingTimeInterval(86_400)
        let remoteEvents = try! await remoteCalendarRepo.fetchEvent(start: start, end: last)
        let localCalendar = calendarService.makeCalendar(selectedDay,localEvents)
        let remoteCalendar = calendarService.makeCalendar(selectedDay, remoteEvents)
        let mergedCalendar = calendarService.mergeCalendar(localCalendar, remoteCalendar)
        let timeTableCalendar = timeTableService.getCalendarForTimeTable(mergedCalendar)
        return timeTableCalendar
    }
    //1. timeTable에 넣을 데이터 준비 및 제공
    //2. 선택된 event 반환
}
