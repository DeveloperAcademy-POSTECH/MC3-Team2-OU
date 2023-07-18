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
    @Published var selectedEvents = [Event]()
    @Published var calendar: Calendar?
    
    init(selectedDay: [String]) {
        self.selectedDay = selectedDay
        Task{
            calendar = await getCalendar()
        }
    }
    private func makeTestCal()async{
        
    }
    private func getCalendar() async -> Calendar {
        print("hello")
        let localEvents = localCalendarRepo.getEvents()
        let remoteEvents = try! await remoteCalendarRepo.fetchEvent(start: DateUtil.formattedDateToDate(selectedDay.first!), end: DateUtil.formattedDateToDate(selectedDay.last!))
        let localCalendar = calendarService.makeCalendar(selectedDay,localEvents)
        let remoteCalendar = calendarService.makeCalendar(selectedDay, remoteEvents)
        let mergedCalendar = calendarService.mergeCalendar(localCalendar, remoteCalendar)
        let timeTableCalendar = timeTableService.getCalendarForTimeTable(mergedCalendar)
        print(timeTableCalendar)
        return timeTableCalendar
    }
    //1. timeTable에 넣을 데이터 준비 및 제공
    //2. 선택된 event 반환
}
