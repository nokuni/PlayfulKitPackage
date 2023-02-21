//
//  PKMapNode.swift
//  
//
//  Created by Maertens Yann-Christophe on 15/02/23.
//

import SpriteKit

public class PKMapNode: SKNode {
    
    public init(tileSize: CGSize = CGSize(width: 25, height: 25),
                tileBitMask: Collision? = nil,
                matrix: Matrix = Matrix(row: 10, column: 10),
                origin: CGPoint = CGPoint.center) {
        self.tileSize = tileSize
        self.tileBitMask = tileBitMask
        self.matrix = matrix
        self.origin = origin
        super.init()
        self.createMap()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var tileSize: CGSize
    public var tileBitMask: Collision?
    public var matrix: Matrix
    public var origin: CGPoint
    
    private let group = PKGroup()
    
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
    
    // Add object on a coordinate
    public func addObject(_ object: PKObjectNode, at coordinate: Coordinate) {
        guard let position = tilePosition(from: coordinate) else { return }
        object.coordinate = coordinate
        object.position = position
        addChild(object)
    }
    
    // Add object through the map from a coordinate to another.
    public func addObject(_ object: PKObjectNode,
                          startingCoordinate: Coordinate,
                          endingCoordinate: Coordinate) {
        let coordinates = Coordinate.coordinates(from: startingCoordinate,
                                                 to: endingCoordinate)
        for coordinate in coordinates {
            addObject(object, at: coordinate)
        }
    }
    
    // Apply Texture
    public func applyTexture(structure: TileStructure,
                             startingCoordinate: Coordinate = Coordinate.zero,
                             rows: Int,
                             columns: Int,
                             object: PKObjectNode? = nil) {
        let firstRow = startingCoordinate.x
        let lastRow = rows - 1
        
        let firstColumn = startingCoordinate.y
        let lastColumn = columns - 1
        
        let topLeftCornerCoordinate = Coordinate(x: firstRow, y: firstColumn)
        let topRightCornerCoordinate = Coordinate(x: firstRow, y: lastColumn)
        let bottomLeftCornerCoordinate = Coordinate(x: lastRow, y: firstColumn)
        let bottomRightCornerCoordinate = Coordinate(x: lastRow, y: lastColumn)
        
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
                     startingCoordinate: Coordinate(x: firstRow,
                                                      y: firstColumn),
                     endingCoordinate: Coordinate(x: lastRow,
                                                    y: lastColumn),
                     isExcludingBorders: true
        )
        
        if let object = object {
            addObject(object,
                      startingCoordinate: Coordinate(x: firstRow,
                                                       y: firstColumn),
                      endingCoordinate: Coordinate(x: lastRow,
                                                     y: lastColumn))
        }
        
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
    public func applyTexture(_ texture: SKTexture, at coordinate: Coordinate) {
        let tileNode = self.tiles.tile(at: coordinate)
        tileNode?.texture = texture
    }
    
    // Apply a texture on all the tiles from a coordinate to another.
    public func applyTexture(_ texture: SKTexture,
                             startingCoordinate: Coordinate,
                             endingCoordinate: Coordinate,
                             isExcludingBorders: Bool = false) {
        let coordinates = Coordinate.coordinates(from: startingCoordinate,
                                                 to: endingCoordinate)
        for coordinate in coordinates {
            applyTexture(texture, at: coordinate)
        }
    }
    
    // MARK: - PRIVATE
    
    private func applyTexture(_ texture: SKTexture,
                              on coordinate: Coordinate,
                              isExcludingBorders: Bool) {
        if isExcludingBorders {
            if canFillBorders(on: coordinate) {
                applyTexture(texture, at: coordinate)
            }
        } else {
            applyTexture(texture, at: coordinate)
        }
    }
    
    private func canFillBorders(on coordinate: Coordinate) -> Bool {
        let isCoordinateOnFirstRow = coordinate.x == 0
        let isCoordinateOnFirstColumn = coordinate.y == 0
        let isCoordinateOnLastRow = coordinate.x == (matrix.row - 1)
        let isCoordinateOnLastColumn = coordinate.y == (matrix.column - 1)
        
        return !isCoordinateOnFirstRow &&
        !isCoordinateOnFirstColumn &&
        !isCoordinateOnLastRow &&
        !isCoordinateOnLastColumn
    }
    
    private func advanceCoordinate(_ coordinate: inout Coordinate) {
        switch true {
        case coordinate.y == matrix.column:
            coordinate.x += 1
            coordinate.y = 0
        default:
            coordinate.y += 1
        }
    }
    
    private func tiles(size: CGSize,
                       amount: Int,
                       bitMask: Collision? = nil) -> [PKTileNode] {
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
        var tileNodes = tiles(size: tileSize, amount: matrix.product, bitMask: tileBitMask)
        tileNodes.coordinateTiles(splittedBy: matrix.column)
        group.createSpriteCollection(of: tileNodes,
                                      at: origin,
                                      in: self,
                                      parameter: .init(columns: matrix.column))
    }
    
    private func applyTexture(_ texture: SKTexture, on tiles: [PKTileNode]) {
        tiles.forEach { $0.texture = texture }
    }
}
