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
    
    func testAddingTextures() {
        let map = PKMapNode(matrix: Matrix(row: 18, column: 30))
        
        map.drawTexture(SKTexture(imageNamed: "redSquare"),
                        matrix: Matrix(row: 6, column: 6),
                        startingCoordinate: Coordinate(x: 2, y: 5))

        let texturesWithoutImages = map.tiles.filter { $0.texture?.name != "MissingResource.png"}
        print(texturesWithoutImages.map { $0.coordinate })
    }
    
    func testCollisions() {
        let bitMasks: [CollisionCategory] = [.object, .structure] // 0x1 << 4 and 0x1 << 5
        let bitMaskValue = bitMasks.withXOROperators() // (0x1 << 4 | 0x1 << 5) = 48
        let result: UInt32 = 48
        XCTAssertEqual(bitMaskValue, result)
    }
}
