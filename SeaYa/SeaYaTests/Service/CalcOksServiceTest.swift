import XCTest
@testable import SeaYa

final class CalcOksServiceTests: XCTestCase {
    var members : [DateMember]? = nil
    
    //BeforEach
    override func setUpWithError() throws {
        let testBundle = Bundle(for: Self.self)
        guard let fileURL = testBundle.url(forResource: "CLMTest", withExtension: "json") else{
            fatalError()
        }
        let decoder = JSONDecoder()
        let data : Data = try Data(contentsOf: fileURL)
        members = try decoder.decode([DateMember].self, from: data)
        
    }
    
    func json파일_로딩_확인() throws {
        XCTAssertNotNil(members)
        XCTAssertTrue(members!.first!.name == "member1")
    }
    
    func 필터링_알고리즘_적용_하루() async throws {
        let manager = CalcOksService()
        let boundDate = BoundedDate(
            start: Calendar.current.date(from: DateComponents(year:2023, month: 8, day: 27, hour: 12,  minute: 00))!,
            end:   Calendar.current.date(from: DateComponents(year:2023, month: 8, day: 27, hour: 18,  minute: 30))!
            )
        try await manager.performCalculation(members!, by: [boundDate])
        XCTAssertTrue(manager.result?.last?.timeInt == 940624)
    }
}
