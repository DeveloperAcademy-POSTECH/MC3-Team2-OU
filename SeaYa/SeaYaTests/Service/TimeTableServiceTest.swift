//
//  TimeTableService.swift
//  SeaYaTests
//
//  Created by musung on 2023/07/18.
//

import XCTest
@testable import SeaYa

final class TimeTableServiceTest: XCTestCase {
    typealias Calendar = Dictionary<String,[Event]>
    let calendarService = CalendarService.shared
    let timeTableService = TimeTableService.shared
    let selectedDays = ["2023-07-16","2023-07-17","2023-07-18"]
    let date1 = DateUtil.createDate(year: 2023, month: 7, day: 16, hour: 9, minute: 30)
    let date2 = DateUtil.createDate(year: 2023, month: 7, day: 17, hour: 18, minute: 00)
    let date3 = DateUtil.createDate(year: 2023, month: 7, day: 18, hour: 19, minute: 30)
    let date4 = DateUtil.createDate(year: 2023, month: 7, day: 16, hour: 11, minute: 30)
    let date5 = DateUtil.createDate(year: 2023, month: 7, day: 17, hour: 12, minute: 00)
    let date6 = DateUtil.createDate(year: 2023, month: 7, day: 18, hour: 13, minute: 30)
    var localEvents = [LocalEvent]()
    var  remoteEvents = [Event]()
    var localCalendar = Calendar()
    var remoteCalendar = Calendar()
    var mergedCalendar = Calendar()
    

    override func setUpWithError() throws {
        localEvents = [
            LocalEvent(title: "test1", days: [.monday,.tuesday,.thursday], start: date1, end: date1.advanced(by: 3600)),
            LocalEvent(title: "test2", days: [.wednesday], start: date2, end: date2.advanced(by: 3600)),
            LocalEvent(title: "test3", days: [.sunday], start: date3, end: date3.advanced(by: 3600)),
        ]
        // 1. test1 -> 월 화 목 -> 월(7.17), 화(7.18), 목 X -> 9시 30분
        // 2. test2 -> 수 -> X
        // 3. test3 -> 일 -> 일(7.16) -> 19시 30분
        localCalendar = calendarService.makeCalendar(selectedDays, localEvents)
        remoteEvents = [
            Event(title: "test4", start: date4, end: date4.advanced(by: 3600)),
            Event(title: "test5", start: date5, end: date5.advanced(by: 3600)),
            Event(title: "test6", start: date6, end: date6.advanced(by: 3600)),
        ]
        remoteCalendar = calendarService.makeCalendar(selectedDays, remoteEvents)
        mergedCalendar = calendarService.mergeCalendar(localCalendar, remoteCalendar)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetCalendarForTimeTable() throws {
        let timeTableCalendar = timeTableService.getCalendarForTimeTable(mergedCalendar)
       // XCTAssertNil(timeTableCalendar)
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
