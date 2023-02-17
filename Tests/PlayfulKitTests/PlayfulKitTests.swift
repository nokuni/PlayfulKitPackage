import XCTest
import SpriteKit
@testable import PlayfulKit

final class PlayfulKitTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
    }
    
    func testScribe() {
        let rectangle = SKShapeNode(rectOf: CGSize(width: 300, height: 100))
        rectangle.name = "Window"
        let scribeNode = PKScribeNode(container: rectangle,
                                      parameter: .init(content: "Hello World"))
        rectangle.addChild(scribeNode)
    }
}
