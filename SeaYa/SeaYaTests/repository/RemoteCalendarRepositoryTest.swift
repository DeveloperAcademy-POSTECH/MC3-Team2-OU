//
//  RemoteCalendarRepositoryTest.swift
//  SeaYaTests
//
//  Created by musung on 2023/07/17.
//

import XCTest
@testable import SeaYa

final class RemoteCalendarRepositoryTest: XCTestCase {
    let repo = RemoteCalendarRepository.shared
    let event = Event(title: "test", start: Date.now, end: Date.now.advanced(by: 1800))
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateRemoteEvent() async throws {
        let success = try await repo.createEvent(event: event)
        let events = try await repo.fetchEvent(start: Date.now.advanced(by: -1800), end: Date.now.advanced(by: 1800))
        XCTAssertTrue(events.contains(where: { testEvent in
            testEvent.title == event.title
        }),"createRemoteEvent 성공")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
