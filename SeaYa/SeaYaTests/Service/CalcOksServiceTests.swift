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
    
    func testExample() throws {
        XCTAssertNotNil(members)
        XCTAssertTrue(members!.first!.name == "member1")
    }
    
    func testExample2() async throws {
        let manager = CalcOksService()
        try await manager.performCalculation(members!)
        XCTAssertTrue(manager.result?.first?.timeInt == 940617)
    }
}
