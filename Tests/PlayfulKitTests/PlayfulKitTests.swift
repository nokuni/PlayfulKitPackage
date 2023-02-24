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
        let scribeNode = PKTypewriterNode(container: rectangle,
                                          parameter: .init(content: "Hello World"))
        rectangle.addChild(scribeNode)
    }
    
    func testMap() {
        let mapNode = PKMapNode(origin: CGPoint(x: CGPoint.center.x - 50, y: CGPoint.center.y))
        let object = PKObjectNode()
        mapNode.addObject(object,
                          structure: .init(
                            topLeft: SKTexture(imageNamed: "pinkSquare"),
                            topRight: SKTexture(imageNamed: "orangeSquare"),
                            bottomLeft: SKTexture(imageNamed: "greenSquare"),
                            bottomRight: SKTexture(imageNamed: "purpleSquare"),
                            left: SKTexture(imageNamed: "yellowSquare"),
                            right: SKTexture(imageNamed: "cyanSquare"),
                            top: SKTexture(imageNamed: "dBlueSquare"),
                            bottom: SKTexture(imageNamed: "blueSquare"),
                            middle: SKTexture(imageNamed: "redSquare")),
                          startingCoordinate: Coordinate(x: 1, y: 3),
                          matrix: Matrix(row: 4, column: 6))
        dump(mapNode.objects)
    }
    
    func testMapFill() {
        var object: PKObjectNode {
            let object = PKObjectNode(imageNamed: "blueSquare")
            object.size = map.squareSize
            return object
        }
        let map = PKMapNode(matrix: Matrix(row: 18, column: 30))
        map.drawTexture(SKTexture(imageNamed: "redSquare"),
                        matrix: Matrix(row: 14, column: 30),
                        startingCoordinate: Coordinate.zero)
        print(map.tiles.map { $0.coordinate })
        //        map.addObject(object,
        //                      startingCoordinate: Coordinate.zero,
        //                      endingCoordinate: Coordinate(x: 0, y: 5)
        //        )
        //        print(map.objects.map { $0.coordinate })
    }
    
    func testBitMasks() {
        let bitMasks: [CollisionCategory] = [.object, .structure] // 0x1 << 4 and 0x1 << 5
        let bitMaskValue = bitMasks.withXOROperators() // (0x1 << 4 | 0x1 << 5) = 48
        let result: UInt32 = 48
        XCTAssertEqual(bitMaskValue, result)
    }
}
