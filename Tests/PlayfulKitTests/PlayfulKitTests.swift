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
        let map = PKMapNode(rows: 4, columns: 6)
        map.applyTexture(structure: .init(
            topLeft: SKTexture(imageNamed: "purpleSquare"),
            topRight: SKTexture(imageNamed: "orangeSquare"),
            bottomLeft: SKTexture(imageNamed: "yellowSquare"),
            bottomRight: SKTexture(imageNamed: "blueSquare"),
            left: SKTexture(imageNamed: "redSquare"),
            right: SKTexture(imageNamed: "redSquare"),
            top: SKTexture(imageNamed: "redSquare"),
            bottom: SKTexture(imageNamed: "redSquare"),
            middle: SKTexture(imageNamed: "redSquare")))
        //dump(map.tiles)
    }
    
    func testBitMasks() {
        let bitMasks: [PKBitMaskCategory] = [.object, .wall] // 0x1 << 4 and 0x1 << 5
        let bitMaskValue = bitMasks.withXOROperators() // (0x1 << 4 | 0x1 << 5) = 48
        let result: UInt32 = 48
        XCTAssertEqual(bitMaskValue, result)
    }
}
