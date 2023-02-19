//
//  PKMapNode.swift
//  
//
//  Created by Maertens Yann-Christophe on 15/02/23.
//

import SpriteKit

public class PKMapNode: SKNode {
    
    public init(tileSize: CGSize = CGSize(width: 25, height: 25),
                tileBitMask: PKBitMask? = nil,
                rows: Int = 10,
                columns: Int = 10,
                origin: CGPoint = CGPoint.center) {
        self.tileSize = tileSize
        self.tileBitMask = tileBitMask
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
    public var tileBitMask: PKBitMask?
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
        
        let firstRow = 0
        let lastRow = rows - 1
        
        let firstColumn = 0
        let lastColumn = columns - 1
        
        let topLeftCornerCoordinate = PKCoordinate(x: firstRow, y: firstColumn)
        let topRightCornerCoordinate = PKCoordinate(x: firstRow, y: lastColumn)
        let bottomLeftCornerCoordinate = PKCoordinate(x: lastRow, y: firstColumn)
        let bottomRightCornerCoordinate = PKCoordinate(x: lastRow, y: lastColumn)
        
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
        applyTexture(structure.left, column: firstColumn, excluding: [firstRow, lastRow])
        // Fill last column
        applyTexture(structure.right, column: lastColumn, excluding: [firstRow, lastRow])
        // Fill first row
        applyTexture(structure.top, row: firstRow, excluding: [firstColumn, lastColumn])
        // Fill last row
        applyTexture(structure.bottom, row: lastRow, excluding: [firstColumn, lastColumn])
        // Fill Middle
        applyTexture(structure.middle,
                     startingCoordinate: PKCoordinate(x: firstRow,
                                                      y: firstColumn),
                     endingCoordinate: PKCoordinate(x: lastRow,
                                                    y: lastColumn),
                     isExcludingBorders: true
        )
        
    }
    
    // Apply a texture on all the tiles of the map
    public func applyTexture(_ texture: SKTexture) {
        applyTexture(texture, on: self.tiles)
    }
    
    // Apply texture on all the tile in a specific column of the map
    public func applyTexture(_ texture: SKTexture, column: Int, excluding rows: [Int] = []) {
        let tilesOnColumn = self.tiles.filter {
            ($0.coordinate.y == column) && !rows.contains($0.coordinate.x)
        }
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
    public func applyTexture(_ texture: SKTexture, row: Int, excluding columns: [Int] = []) {
        let tilesOnRow = self.tiles.filter {
            $0.coordinate.x == row && !columns.contains($0.coordinate.y)
        }
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
                             endingCoordinate: PKCoordinate,
                             isExcludingBorders: Bool = false) {
        guard (endingCoordinate.x > startingCoordinate.x) ||
                (startingCoordinate.y < columns) else { return }
        var coordinate = startingCoordinate
        repeat {
            applyTexture(texture, on: coordinate, isExcludingBorders: isExcludingBorders)
            advanceCoordinate(&coordinate)
        } while (coordinate.x < endingCoordinate.x) || (coordinate.y < endingCoordinate.y)
    }
    
    // MARK: - PRIVATE
    
    private func applyTexture(_ texture: SKTexture,
                              on coordinate: PKCoordinate,
                              isExcludingBorders: Bool) {
        if isExcludingBorders {
            if canFillBorders(on: coordinate) {
                applyTexture(texture, at: coordinate)
            }
        } else {
            applyTexture(texture, at: coordinate)
        }
    }
    
    private func canFillBorders(on coordinate: PKCoordinate) -> Bool {
        let isCoordinateOnFirstRow = coordinate.x == 0
        let isCoordinateOnFirstColumn = coordinate.y == 0
        let isCoordinateOnLastRow = coordinate.x == (rows - 1)
        let isCoordinateOnLastColumn = coordinate.y == (columns - 1)
        
        return !isCoordinateOnFirstRow &&
        !isCoordinateOnFirstColumn &&
        !isCoordinateOnLastRow &&
        !isCoordinateOnLastColumn
    }
    
    private func advanceCoordinate(_ coordinate: inout PKCoordinate) {
        switch true {
        case coordinate.y == columns:
            coordinate.x += 1
            coordinate.y = 0
        default:
            coordinate.y += 1
        }
    }
    
    private func tiles(size: CGSize,
                       amount: Int,
                       bitMask: PKBitMask? = nil) -> [PKTileNode] {
        var tileNodes: [PKTileNode] = []
        for _ in 0..<amount {
            let tileNode = PKTileNode()
            tileNode.size = size
            tileNode.texture = SKTexture(imageNamed: "")
            if let bitMask = bitMask {
                tileNode.applyPhysicsBody(size: tileNode.size,
                                          bitMask: .init(category: bitMask.category,
                                                         collision: bitMask.collision,
                                                         contact: bitMask.contact)
                )
            }
            tileNodes.append(tileNode)
        }
        return tileNodes
    }
    
    private func createMap() {
        let amount = rows * columns
        var tileNodes = tiles(size: tileSize, amount: amount, bitMask: tileBitMask)
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
