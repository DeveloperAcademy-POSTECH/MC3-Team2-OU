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
        
        //Array 초기화
        self.xArray = []
        self.yArray = []
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
    
    static let preview: TimeTableViewModel = .init(true)
    private init(_ boolVar : Bool){
        calendar = Optional(
            [
                "2023-08-29":
                    [
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-29 00:00"), end:  DateUtil.formattedDateToDate("2023-08-29 00:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-29 00:30"), end:  DateUtil.formattedDateToDate("2023-08-29 01:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-29 01:00"), end:  DateUtil.formattedDateToDate("2023-08-29 01:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-29 01:30"), end:  DateUtil.formattedDateToDate("2023-08-29 02:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-29 02:00"), end:  DateUtil.formattedDateToDate("2023-08-29 02:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-29 02:30"), end:  DateUtil.formattedDateToDate("2023-08-29 03:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-29 03:00"), end:  DateUtil.formattedDateToDate("2023-08-29 03:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-29 03:30"), end:  DateUtil.formattedDateToDate("2023-08-29 04:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-29 04:00"), end:  DateUtil.formattedDateToDate("2023-08-29 04:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-29 04:30"), end:  DateUtil.formattedDateToDate("2023-08-29 05:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-29 05:00"), end:  DateUtil.formattedDateToDate("2023-08-29 05:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-29 05:30"), end:  DateUtil.formattedDateToDate("2023-08-29 06:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-29 06:00"), end:  DateUtil.formattedDateToDate("2023-08-29 06:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-29 06:30"), end:  DateUtil.formattedDateToDate("2023-08-29 07:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-29 07:00"), end:  DateUtil.formattedDateToDate("2023-08-29 07:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-29 07:30"), end:  DateUtil.formattedDateToDate("2023-08-29 08:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-29 08:00"), end:  DateUtil.formattedDateToDate("2023-08-29 08:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-29 08:30"), end:  DateUtil.formattedDateToDate("2023-08-29 09:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-29 09:00"), end:  DateUtil.formattedDateToDate("2023-08-29 09:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-29 09:30"), end:  DateUtil.formattedDateToDate("2023-08-29 10:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-29 10:00"), end:  DateUtil.formattedDateToDate("2023-08-29 10:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-29 10:30"), end:  DateUtil.formattedDateToDate("2023-08-29 11:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-29 11:00"), end:  DateUtil.formattedDateToDate("2023-08-29 11:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-29 11:30"), end:  DateUtil.formattedDateToDate("2023-08-29 12:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-29 12:00"), end:  DateUtil.formattedDateToDate("2023-08-29 12:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-29 12:30"), end:  DateUtil.formattedDateToDate("2023-08-29 13:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-29 13:00"), end:  DateUtil.formattedDateToDate("2023-08-29 13:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-29 13:30"), end:  DateUtil.formattedDateToDate("2023-08-29 14:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-29 14:00"), end:  DateUtil.formattedDateToDate("2023-08-29 14:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-29 14:30"), end:  DateUtil.formattedDateToDate("2023-08-29 15:00"))
                    ],
                "2023-08-30":
                    [
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-30 00:00"), end:  DateUtil.formattedDateToDate("2023-08-30 00:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-30 00:30"), end:  DateUtil.formattedDateToDate("2023-08-30 01:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-30 01:00"), end:  DateUtil.formattedDateToDate("2023-08-30 01:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-30 01:30"), end:  DateUtil.formattedDateToDate("2023-08-30 02:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-30 02:00"), end:  DateUtil.formattedDateToDate("2023-08-30 02:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-30 02:30"), end:  DateUtil.formattedDateToDate("2023-08-30 03:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-30 03:00"), end:  DateUtil.formattedDateToDate("2023-08-30 03:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-30 03:30"), end:  DateUtil.formattedDateToDate("2023-08-30 04:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-30 04:00"), end:  DateUtil.formattedDateToDate("2023-08-30 04:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-30 04:30"), end:  DateUtil.formattedDateToDate("2023-08-30 05:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-30 05:00"), end:  DateUtil.formattedDateToDate("2023-08-30 05:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-30 05:30"), end:  DateUtil.formattedDateToDate("2023-08-30 06:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-30 06:00"), end:  DateUtil.formattedDateToDate("2023-08-30 06:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-30 06:30"), end:  DateUtil.formattedDateToDate("2023-08-30 07:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-30 07:00"), end:  DateUtil.formattedDateToDate("2023-08-30 07:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-30 07:30"), end:  DateUtil.formattedDateToDate("2023-08-30 08:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-30 08:00"), end:  DateUtil.formattedDateToDate("2023-08-30 08:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-30 08:30"), end:  DateUtil.formattedDateToDate("2023-08-30 09:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-30 09:00"), end:  DateUtil.formattedDateToDate("2023-08-30 09:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-30 09:30"), end:  DateUtil.formattedDateToDate("2023-08-30 10:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-30 10:00"), end:  DateUtil.formattedDateToDate("2023-08-30 10:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-30 10:30"), end:  DateUtil.formattedDateToDate("2023-08-30 11:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-30 11:00"), end:  DateUtil.formattedDateToDate("2023-08-30 11:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-30 11:30"), end:  DateUtil.formattedDateToDate("2023-08-30 12:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-30 12:00"), end:  DateUtil.formattedDateToDate("2023-08-30 12:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-30 12:30"), end:  DateUtil.formattedDateToDate("2023-08-30 13:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-30 13:00"), end:  DateUtil.formattedDateToDate("2023-08-30 13:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-30 13:30"), end:  DateUtil.formattedDateToDate("2023-08-30 14:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-30 14:00"), end:  DateUtil.formattedDateToDate("2023-08-30 14:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-30 14:30"), end:  DateUtil.formattedDateToDate("2023-08-30 15:00"))
                    ],
                "2023-08-31":
                    [
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-31 00:00"), end:  DateUtil.formattedDateToDate("2023-08-31 00:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-31 00:30"), end:  DateUtil.formattedDateToDate("2023-08-31 01:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-31 01:00"), end:  DateUtil.formattedDateToDate("2023-08-31 01:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-31 01:30"), end:  DateUtil.formattedDateToDate("2023-08-31 02:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-31 02:00"), end:  DateUtil.formattedDateToDate("2023-08-31 02:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-31 02:30"), end:  DateUtil.formattedDateToDate("2023-08-31 03:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-31 03:00"), end:  DateUtil.formattedDateToDate("2023-08-31 03:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-31 03:30"), end:  DateUtil.formattedDateToDate("2023-08-31 04:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-31 04:00"), end:  DateUtil.formattedDateToDate("2023-08-31 04:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-31 04:30"), end:  DateUtil.formattedDateToDate("2023-08-31 05:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-31 05:00"), end:  DateUtil.formattedDateToDate("2023-08-31 05:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-31 05:30"), end:  DateUtil.formattedDateToDate("2023-08-31 06:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-31 06:00"), end:  DateUtil.formattedDateToDate("2023-08-31 06:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-31 06:30"), end:  DateUtil.formattedDateToDate("2023-08-31 07:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-31 07:00"), end:  DateUtil.formattedDateToDate("2023-08-31 07:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-31 07:30"), end:  DateUtil.formattedDateToDate("2023-08-31 08:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-31 08:00"), end:  DateUtil.formattedDateToDate("2023-08-31 08:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-31 08:30"), end:  DateUtil.formattedDateToDate("2023-08-31 09:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-31 09:00"), end:  DateUtil.formattedDateToDate("2023-08-31 09:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-31 09:30"), end:  DateUtil.formattedDateToDate("2023-08-31 10:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-31 10:00"), end:  DateUtil.formattedDateToDate("2023-08-31 10:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-31 10:30"), end:  DateUtil.formattedDateToDate("2023-08-31 11:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-31 11:00"), end:  DateUtil.formattedDateToDate("2023-08-31 11:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-31 11:30"), end:  DateUtil.formattedDateToDate("2023-08-31 12:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-31 12:00"), end:  DateUtil.formattedDateToDate("2023-08-31 12:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-31 12:30"), end:  DateUtil.formattedDateToDate("2023-08-31 13:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-31 13:00"), end:  DateUtil.formattedDateToDate("2023-08-31 13:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-31 13:30"), end:  DateUtil.formattedDateToDate("2023-08-31 14:00")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-31 14:00"), end:  DateUtil.formattedDateToDate("2023-08-31 14:30")),
                        SeaYa.Event(title: "blank", start: DateUtil.formattedDateToDate("2023-08-31 14:30"), end:  DateUtil.formattedDateToDate("2023-08-31 15:00"))
                    ]
            ]
        )
        tableCalendar = calToTableCal(calendar!)
        selectedDay = ["2023-08-29", "2023-08-30", "2023-08-31"]
    }
}
