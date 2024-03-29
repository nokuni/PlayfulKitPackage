import XCTest
import SpriteKit
@testable import PlayfulKit

final class PlayfulKitTests: XCTestCase {
    
    func testCoordinateString() {
        let coordinateString = "0835"
        let coordinate = coordinateString.coordinate
        print(coordinate)
        let expectedResult = Coordinate(x: 8, y: 35)
        
        XCTAssertEqual(coordinate, expectedResult)
    }
    
    func testMatrixString() {
        let data = "0709"
        print(data.coordinate)
    }
    
    func testScribe() {
        let rectangle = SKShapeNode(rectOf: CGSize(width: 300, height: 100))
        rectangle.name = "Window"
        let scribeNode = PKTypewriterNode(container: rectangle,
                                          parameter: .init(content: "Hello World 􀋃"))
        rectangle.addChildSafely(scribeNode)
    }
    
    func testObjectAdd() {
        let node = SKNode()
        let collision = Collision(category: .object,
                                  collision: [.player, .enemy, .structure],
                                  contact: [.structure])
        
        let child = SKSpriteNode(imageNamed: "blueSquare")
        
        let object = PKObjectNode()
        object.texture = SKTexture(imageNamed: "redSquare")
        object.size = CGSize(width: 999, height: 999)
        object.coordinate = Coordinate(x: 99, y: 99)
        object.applyPhysicsBody(size: CGSize(width: 50, height: 50), collision: collision)
        object.addAnimation(ObjectAnimation(identifier: "idle", frames: ["idle0", "idle1"]))
        
        object.addChildSafely(child)
        
        node.addChildSafely(object)
        
        // The parameters that doesnt get copied are the logic, the animations and the coordinates.
        for _ in 0..<3 {
            let anotherObject = object.copy() as? PKObjectNode
            if let anotherObject = anotherObject {
                print(anotherObject.children)
            }
        }
    }
    
    func testCollisions() {
        let result: UInt32 = 48
        let bitMasks: [CollisionCategory] = [.object, .structure] // 0x1 << 4 and 0x1 << 5
        let bitMaskValue = bitMasks.withXOROperators() // (0x1 << 4 | 0x1 << 5) = 48
        XCTAssertEqual(bitMaskValue, result)
    }
}
