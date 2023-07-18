//
//  LocalCalendarRepositoryTest.swift
//  SeaYaTests
//
//  Created by musung on 2023/07/17.
//

import XCTest

final class LocalCalendarRepositoryTest: XCTestCase {
    
    let repo = LocalCalendarRepository.shared
    let event = LocalEvent(title: "test", days: [.friday,.monday], start: Date.now, end: Date.now)

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testResetUserDefaults() throws{
        repo.resetUserDefaults()
        XCTAssertTrue(repo.getEvents().isEmpty,"reset 성공")
    }
    func testCreateEvent() throws{
        repo.createEvent(event: event)
        let testEvents = repo.getEvents()
        XCTAssertTrue(testEvents.contains(where: { localEvent in
            localEvent.id == event.id
        }),"event 생성 성공")
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
