//
//  SeaYaTests.swift
//  SeaYaTests
//
//  Created by Kihyun Roh on 2023/07/12.
//

@testable import SeaYa
import XCTest

final class CalcOksServiceTest: XCTestCase {
    var members: [DateMember]? = [
        DateMember(name: "member1", dateEvents: [
            DateEvent(
                title: "member1 available, 12:00~15:30",
                startDate: Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 27, hour: 12, minute: 00))!,
                endDate: Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 27, hour: 15, minute: 30))!
            ),
            DateEvent(
                title: "member1 available, 17:00~18:30",
                startDate: Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 27, hour: 17, minute: 00))!,
                endDate: Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 27, hour: 18, minute: 30))!
            )]),

        DateMember(name: "member2", dateEvents: [
            DateEvent(
                title: "member2 available, 12:30~15:00",
                startDate: Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 27, hour: 12, minute: 30))!,
                endDate: Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 27, hour: 15, minute: 00))!
            ),
            DateEvent(
                title: "member2 available, 17:00~18:30",
                startDate: Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 27, hour: 15, minute: 30))!,
                endDate: Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 27, hour: 18, minute: 30))!
            )]),

        DateMember(name: "member3", dateEvents: [
            DateEvent(
                title: "member3 available, 12:00~13:00",
                startDate: Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 27, hour: 12, minute: 00))!,
                endDate: Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 27, hour: 13, minute: 00))!
            ),
            DateEvent(
                title: "member3 available, 13:30~15:00",
                startDate: Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 27, hour: 13, minute: 30))!,
                endDate: Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 27, hour: 15, minute: 00))!
            ),
            DateEvent(
                title: "member3 available, 16:00~18:30",
                startDate: Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 27, hour: 16, minute: 00))!,
                endDate: Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 27, hour: 18, minute: 30))!
            )]),

        DateMember(name: "member4", dateEvents: [
            DateEvent(
                title: "member4 available, 13:00~17:30",
                startDate: Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 27, hour: 13, minute: 00))!,
                endDate: Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 27, hour: 17, minute: 30))!
            )]),
    ]

    // BeforEach
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample_1() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        XCTAssertNotNil(members)
        XCTAssertTrue(members!.first!.name == "member1")
    }

    func testExample_2() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        let manager = CalcOksService.shared
        let boundDate = BoundedDate(
            start: Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 27, hour: 12, minute: 00))!,
            end: Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 27, hour: 18, minute: 30))!
        )
        try await manager.performCalculation(members!, by: [boundDate])
        let result = manager.result!
        print(manager.groupByConsecutiveTime(result))
        XCTAssertTrue(manager.result?.last?.timeInt == 940_621)
    }

    func testExample_3() throws {
        let _ = Calendar.current.date(from: DateComponents(year: 2023, month: 1, day: 1))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
