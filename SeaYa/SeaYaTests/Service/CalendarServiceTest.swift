//
//  CalendarServiceTest.swift
//  SeaYaTests
//
//  Created by musung on 2023/07/17.
//

import XCTest
@testable import SeaYa

final class CalendarServiceTest: XCTestCase {
    let service = CalendarService.shared
    let selectedDays = ["2023-07-16","2023-07-17","2023-07-18"]
    let date1 = DateUtil.createDate(year: 2023, month: 7, day: 16, hour: 9, minute: 30)
    let date2 = DateUtil.createDate(year: 2023, month: 7, day: 17, hour: 18, minute: 00)
    let date3 = DateUtil.createDate(year: 2023, month: 7, day: 18, hour: 19, minute: 30)
    let date4 = DateUtil.createDate(year: 2023, month: 7, day: 16, hour: 11, minute: 30)
    let date5 = DateUtil.createDate(year: 2023, month: 7, day: 17, hour: 12, minute: 00)
    let date6 = DateUtil.createDate(year: 2023, month: 7, day: 18, hour: 13, minute: 30)
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMakeLocalEventCalendar() throws {
        let localEvents = [
            LocalEvent(title: "test1", days: [.monday,.tuesday,.thursday], start: date1, end: date1.advanced(by: 3600)),
            LocalEvent(title: "test2", days: [.wednesday], start: date2, end: date2.advanced(by: 3600)),
            LocalEvent(title: "test3", days: [.sunday], start: date3, end: date3.advanced(by: 3600)),
        ]
        // 1. test1 -> 월 화 목 -> 월(7.17), 화(7.18), 목 X -> 9시 30분
        // 2. test2 -> 수 -> X
        // 3. test3 -> 일 -> 일(7.16) -> 19시 30분
        let calendar = service.makeCalendar(selectedDays, localEvents)
        XCTAssertEqual(DateUtil.createDate(year: 2023, month: 7, day: 17, hour: 9, minute: 30),calendar["2023-07-17"]!.first?.start)
        XCTAssertEqual(DateUtil.createDate(year: 2023, month: 7, day: 18, hour: 9, minute: 30),calendar["2023-07-18"]!.first?.start)
        XCTAssertEqual(DateUtil.createDate(year: 2023, month: 7, day: 16, hour: 19, minute: 30),calendar["2023-07-16"]!.first?.start)
    }
    
    func testMakeRemoteEventCalendar() throws {
        let remoteEvents = [
            Event(title: "test1", start: date1, end: date1.advanced(by: 3600)),
            Event(title: "test2", start: date2, end: date2.advanced(by: 3600)),
            Event(title: "test3", start: date3, end: date3.advanced(by: 3600)),
            Event(title: "test4", start: date4, end: date4.advanced(by: 3600)),
        ]
        let calendar = service.makeCalendar(selectedDays, remoteEvents)
        XCTAssertEqual(date1,calendar["2023-07-16"]!.first(where: { event in
            event.title == "test1"
        })!.start)
        XCTAssertEqual(date4,calendar["2023-07-16"]!.first(where: { event in
            event.title == "test4"
        })!.start)
        XCTAssertEqual(date2,calendar["2023-07-17"]!.first?.start)
        XCTAssertEqual(date3,calendar["2023-07-18"]!.first?.start)
        
    }
    func testMergeCalendar() throws {
        // 1. test1 -> 월 화 목 -> 월(7.17), 화(7.18), 목 X -> 9시 30분
        // 2. test2 -> 수 -> X
        // 3. test3 -> 일 -> 일(7.16) -> 19시 30분
        let localEvents = [
            LocalEvent(title: "test1", days: [.monday,.tuesday,.thursday], start: date1, end: date1.advanced(by: 3600)),
            LocalEvent(title: "test2", days: [.wednesday], start: date2, end: date2.advanced(by: 3600)),
            LocalEvent(title: "test3", days: [.sunday], start: date3, end: date3.advanced(by: 3600)),
        ]
        
        let remoteEvents = [
            Event(title: "test4", start: date4, end: date4.advanced(by: 3600)),
            Event(title: "test5", start: date5, end: date5.advanced(by: 3600)),
            Event(title: "test6", start: date6, end: date6.advanced(by: 3600)),
        ]
        let localCalendar  = service.makeCalendar(selectedDays, localEvents)
        let remoteCalendar = service.makeCalendar(selectedDays, remoteEvents)
        let mergedCalendar = service.mergeCalendar(localCalendar, remoteCalendar)
        XCTAssertTrue(mergedCalendar["2023-07-16"]!.contains(where: { event in
            event.title == "test3"
        }))
        XCTAssertTrue(mergedCalendar["2023-07-16"]!.contains(where: { event in
            event.title == "test4"
        }))
        XCTAssertTrue(mergedCalendar["2023-07-17"]!.contains(where: { event in
            event.title == "test1"
        }))
        XCTAssertTrue(mergedCalendar["2023-07-17"]!.contains(where: { event in
            event.title == "test5"
        }))
        XCTAssertTrue(mergedCalendar["2023-07-18"]!.contains(where: { event in
            event.title == "test6"
        }))
        XCTAssertTrue(mergedCalendar["2023-07-18"]!.contains(where: { event in
            event.title == "test1"
        }))
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
