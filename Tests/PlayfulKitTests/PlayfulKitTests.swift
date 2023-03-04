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
    
    func testObjectAdd() {
        let node = SKNode()
        let collision = Collision(category: .object,
                                  collision: [.player, .enemy, .structure],
                                  contact: [.structure])
        
        let child = SKSpriteNode(imageNamed: "blueSquare")
        
        let object = PKObjectNode(imageNamed: "redSquare")
        object.size = CGSize(width: 999, height: 999)
        object.coordinate = Coordinate(x: 99, y: 99)
        object.logic.health = 999
        object.logic.isDestructible = true
        object.applyPhysicsBody(size: CGSize(width: 50, height: 50), collision: collision)
        object.addAnimation(ObjectAnimation(identifier: "idle", frames: ["idle0", "idle1"]))
        
        object.addChild(child)
        
        node.addChild(object)
        
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
