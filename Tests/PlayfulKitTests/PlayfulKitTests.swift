import XCTest
import SpriteKit
@testable import PlayfulKit

final class PlayfulKitTests: XCTestCase {
    
    func testScribe() {
        let rectangle = SKShapeNode(rectOf: CGSize(width: 300, height: 100))
        rectangle.name = "Window"
        let scribeNode = PKTypewriterNode(container: rectangle,
                                          parameter: .init(content: "Hello World"))
        rectangle.addChild(scribeNode)
    }
    
    func testCollisions() {
        let result: UInt32 = 48
        let bitMasks: [CollisionCategory] = [.object, .structure] // 0x1 << 4 and 0x1 << 5
        let bitMaskValue = bitMasks.withXOROperators() // (0x1 << 4 | 0x1 << 5) = 48
        XCTAssertEqual(bitMaskValue, result)
    }
}
