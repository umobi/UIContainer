import XCTest
@testable import UIContainer

final class UIContainerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(UIContainer().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
