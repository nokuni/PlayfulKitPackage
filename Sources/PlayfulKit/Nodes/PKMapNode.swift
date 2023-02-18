//
//  PKMapNode.swift
//  
//
//  Created by Maertens Yann-Christophe on 15/02/23.
//

import SpriteKit

public class PKMapNode: SKNode {
    
    public init(tileSize: CGSize = CGSize(width: 25, height: 25),
                rows: Int = 10,
                columns: Int = 10,
                origin: CGPoint = CGPoint.center) {
        self.tileSize = tileSize
        self.rows = rows
        self.columns = columns
        self.origin = origin
        super.init()
        self.createMap()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var tileSize: CGSize
    public var rows: Int
    public var columns: Int
    public var origin: CGPoint
    
    private let matrix = PKMatrix()
    
    public struct TileStructure {
        public init(topLeft: SKTexture,
                    topRight: SKTexture,
                    bottomLeft: SKTexture,
                    bottomRight: SKTexture,
                    left: SKTexture,
                    right: SKTexture,
                    top: SKTexture,
                    bottom: SKTexture,
                    middle: SKTexture) {
            self.topLeft = topLeft
            self.topRight = topRight
            self.bottomLeft = bottomLeft
            self.bottomRight = bottomRight
            self.left = left
            self.right = right
            self.top = top
            self.bottom = bottom
            self.middle = middle
        }
        
        public var topLeft: SKTexture
        public var topRight: SKTexture
        public var bottomLeft: SKTexture
        public var bottomRight: SKTexture
        public var left: SKTexture
        public var right: SKTexture
        public var top: SKTexture
        public var bottom: SKTexture
        public var middle: SKTexture
    }
    
    // MARK: - PUBLIC
    
    // Apply Texture
    public func applyTexture(structure: TileStructure) {
        let topLeftCornerCoordinate = PKCoordinate(x: 0, y: 0)
        let topRightCornerCoordinate = PKCoordinate(x: 0, y: columns - 1)
        let bottomLeftCornerCoordinate = PKCoordinate(x: rows - 1, y: 0)
        let bottomRightCornerCoordinate = PKCoordinate(x: rows - 1, y: columns - 1)
        
        // Fill corners
        applyTexture(structure.topLeft,
                     at: topLeftCornerCoordinate)
        applyTexture(structure.topRight,
                     at: topRightCornerCoordinate)
        applyTexture(structure.bottomLeft,
                     at: bottomLeftCornerCoordinate)
        applyTexture(structure.bottomRight,
                     at: bottomRightCornerCoordinate)
        
        // Fill first column
        applyTexture(structure.left,
                     startingCoordinate: PKCoordinate(x: topLeftCornerCoordinate.x + 1,
                                                      y: 0),
                     endingCoordinate: PKCoordinate(x: bottomLeftCornerCoordinate.x - 1,
                                                    y: 0))
        // Fill last column
        applyTexture(structure.right,
                     startingCoordinate: PKCoordinate(x: topRightCornerCoordinate.x + 1,
                                                      y: columns - 1),
                     endingCoordinate: PKCoordinate(x: bottomRightCornerCoordinate.x - 1,
                                                    y: columns - 1))
        // Fill first row
        applyTexture(structure.top,
                     startingCoordinate: PKCoordinate(x: 0,
                                                      y: topLeftCornerCoordinate.y + 1),
                     endingCoordinate: PKCoordinate(x: 0,
                                                    y: topRightCornerCoordinate.y - 1))
        // Fill last row
        applyTexture(structure.bottom,
                     startingCoordinate: PKCoordinate(x: rows - 1,
                                                      y: bottomLeftCornerCoordinate.y + 1),
                     endingCoordinate: PKCoordinate(x: rows - 1,
                                                    y: bottomRightCornerCoordinate.y - 1))
        // Fill Middle
        applyTexture(structure.middle,
                     startingCoordinate: PKCoordinate(x: 0,
                                                      y: 0),
                     endingCoordinate: PKCoordinate(x: rows - 1,
                                                    y: columns - 1)
        )
    }
    
    // Apply a texture on all the tiles of the map
    public func applyTexture(_ texture: SKTexture) {
        applyTexture(texture, on: self.tiles)
    }
    
    // Apply texture on all the tile in a specific column of the map
    public func applyTexture(_ texture: SKTexture, column: Int) {
        let tilesOnColumn = self.tiles.filter { $0.coordinate.y == column }
        applyTexture(texture, on: tilesOnColumn)
    }
    
    // Apply a texture on all the tiles in multiples columns of the map
    public func applyTexture(_ texture: SKTexture,
                             startingColumn: Int,
                             endingColumn: Int) {
        for column in startingColumn..<endingColumn {
            applyTexture(texture, column: column)
        }
    }
    
    // Apply a texture on all the tiles in a specific row of the map
    public func applyTexture(_ texture: SKTexture, row: Int) {
        let tilesOnRow = self.tiles.filter { $0.coordinate.x == row }
        applyTexture(texture, on: tilesOnRow)
    }
    
    // Apply a texture on all the tiles in multiples row of the map
    public func applyTexture(_ texture: SKTexture,
                             startingRow: Int,
                             endingRow: Int) {
        for row in startingRow..<endingRow {
            applyTexture(texture, row: row)
        }
    }
    
    // Apply a texture on one tiles at a specific coordinate
    public func applyTexture(_ texture: SKTexture, at coordinate: PKCoordinate) {
        let tileNode = self.tiles.tile(at: coordinate)
        tileNode?.texture = texture
    }
    
    // Apply a texture on all the tiles from a coordinate to another.
    public func applyTexture(_ texture: SKTexture,
                             startingCoordinate: PKCoordinate,
                             endingCoordinate: PKCoordinate) {
        let hasPositiveCoordinateRange = (endingCoordinate.x > startingCoordinate.x) ||
        (startingCoordinate.y < columns)
        guard hasPositiveCoordinateRange else { return }
        var coordinate = startingCoordinate
        repeat {
            applyTexture(texture, at: coordinate)
            advanceCoordinate(&coordinate)
        } while (coordinate.x < endingCoordinate.x) || (coordinate.y < columns)
    }
    
    // MARK: - PRIVATE
    
    private func advanceCoordinate(_ coordinate: inout PKCoordinate) {
        switch true {
        case coordinate.y == columns:
            coordinate.x += 1
            coordinate.y = 0
        default:
            coordinate.y += 1
        }
    }
    
    private func tiles(size: CGSize, amount: Int) -> [PKTileNode] {
        var tileNodes: [PKTileNode] = []
        for _ in 0..<amount {
            let tileNode = PKTileNode()
            tileNode.size = size
            tileNode.texture = SKTexture(imageNamed: "")
            tileNodes.append(tileNode)
        }
        return tileNodes
    }
    
    private func createMap() {
        let amount = rows * columns
        var tileNodes = tiles(size: tileSize, amount: amount)
        tileNodes.coordinateTiles(splittedBy: columns)
        matrix.createSpriteCollection(of: tileNodes,
                                      at: origin,
                                      in: self,
                                      parameter: .init(columns: columns))
    }
    
    private func applyTexture(_ texture: SKTexture, on tiles: [PKTileNode]) {
        tiles.forEach { $0.texture = texture }
    }
}
