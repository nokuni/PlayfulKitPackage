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
    
    func testMap() {
        let map = PKMapNode(rows: 5, columns: 10)
        let texture = SKTexture(imageNamed: "redSquare")
        let firstCoordinate = PKCoordinate(x: 0, y: 0)
        let secondCoordinate = PKCoordinate(x: 1, y: 9)
        map.applyTexture(texture, startingCoordinate: firstCoordinate, endingCoordinate: secondCoordinate)
    }
    
    func testBitMasks() {
        let bitMasks: [PKBitMaskCategory] = [.object, .wall] // 0x1 << 4 and 0x1 << 5
        let bitMaskValue = bitMasks.withXOROperators() // (0x1 << 4 | 0x1 << 5) = 48
        let result: UInt32 = 48
        XCTAssertEqual(bitMaskValue, result)
    }
}
