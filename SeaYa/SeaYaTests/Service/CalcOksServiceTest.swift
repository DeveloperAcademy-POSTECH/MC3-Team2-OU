//
//  SeaYaTests.swift
//  SeaYaTests
//
//  Created by Kihyun Roh on 2023/07/12.
//

import XCTest
@testable import SeaYa

final class CalcOksServiceTest: XCTestCase {
    var members : [DateMember]? = nil
    
    //BeforEach
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let testBundle = Bundle(for: Self.self)
        guard let fileURL = testBundle.url(forResource: "CLMTest", withExtension: "json") else{
            fatalError()
        }
        let decoder = JSONDecoder()
        let data : Data = try Data(contentsOf: fileURL)
        members = try decoder.decode([DateMember].self, from: data)
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
        let manager = CalcOksService()
        let boundDate = BoundedDate(
            start: Calendar.current.date(from: DateComponents(year:2023, month: 8, day: 27, hour: 12,  minute: 00))!,
            end:   Calendar.current.date(from: DateComponents(year:2023, month: 8, day: 27, hour: 18,  minute: 30))!
            )
        try await manager.performCalculation(members!, by: [boundDate])
        let result = manager.result!
        print(manager.groupByConsecutiveTime(result))
        XCTAssertTrue(manager.result?.last?.timeInt == 940624)
    }
    
    func testExample_3() throws {
        let _ = Calendar.current.date(from: DateComponents(year:2023, month:1, day:1))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
