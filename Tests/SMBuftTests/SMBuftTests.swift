import XCTest
@testable import SMBuft

class SMBuftTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(SMBuft().text, "Hello, World!")
    }


    static var allTests : [(String, (SMBuftTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
