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
    
    /// Add a single object at a specific coordinate
    public func addObject(_ object: PKObjectNode, at coordinate: Coordinate) {
        guard let position = tilePosition(from: coordinate) else { return }
        object.coordinate = coordinate
        object.position = position
        addChild(object)
    }

    /// Add a shape of a single object.
    public func addObject(_ object: PKObjectNode,
                          matrix: Matrix,
                          startingCoordinate: Coordinate) {

        let endingCoordinate = matrix.lastCoordinate(from: startingCoordinate)

        let coordinates = Coordinate.coordinates(from: matrix.firstCoordinate,
                                                 to: matrix.lastCoordinate)

        for coordinate in coordinates {
            let isIncluding = isIncludingOtherCoordinates(coordinate,
                                                          startingCoordinate: startingCoordinate,
                                                          endingCoordinate: endingCoordinate)
            if isIncluding {
                addObject(object, at: coordinate)
            }
        }
    }
    
    // Apply Texture
    public func applyTexture(structure: TileStructure,
                             startingCoordinate: Coordinate = Coordinate.zero,
                             matrix: Matrix,
                             object: PKObjectNode? = nil) {

        let endingCoordinate = matrix.lastCoordinate(from: startingCoordinate)

        let firstRow = startingCoordinate.x
        let lastRow = endingCoordinate.x

        let firstColumn = startingCoordinate.y
        let lastColumn = endingCoordinate.y

        // Fill all area with middle texture first
        drawTexture(structure.middle,
                    matrix: matrix,
                    startingCoordinate: startingCoordinate
        )

        let topLeftCornerCoordinate = Coordinate(x: firstRow, y: firstColumn)
        let topRightCornerCoordinate = Coordinate(x: firstRow, y: lastColumn)
        let bottomLeftCornerCoordinate = Coordinate(x: lastRow, y: firstColumn)
        let bottomRightCornerCoordinate = Coordinate(x: lastRow, y: lastColumn)

        // Fill corners
        drawTexture(structure.topLeft,
                    at: topLeftCornerCoordinate)
        drawTexture(structure.topRight,
                    at: topRightCornerCoordinate)
        drawTexture(structure.bottomLeft,
                    at: bottomLeftCornerCoordinate)
        drawTexture(structure.bottomRight,
                    at: bottomRightCornerCoordinate)


        // Fill first column
        let firstColumnCoordinates = firstColumn.columnCoordinates(row: lastRow)
        let excludedFirstColumns = firstColumnCoordinates.filter {
            ($0 == firstRow) && ($0 == lastRow) && ($0 > lastRow)
        }
        drawTexture(structure.left, column: firstColumn, excluding: excludedFirstColumns)

        // Fill last column
        let lastColumnCoordinates = lastColumn.columnCoordinates(row: lastRow)
        let excludedLastColumns = lastColumnCoordinates.filter {
            ($0 == firstRow) && ($0 == lastRow) && ($0 > lastRow)
        }
        drawTexture(structure.right, column: lastColumn, excluding: excludedLastColumns)

        // Fill first row
        let firstRowCoordinates = firstRow.rowCoordinates(column: lastColumn)
        let excludedFirstRows = firstRowCoordinates.filter {
            ($0 == firstRow) && ($0 == lastRow) && ($0 < lastRow)
        }
        drawTexture(structure.top, row: firstRow, excluding: excludedFirstRows)

        // Fill last row
        let lastRowCoordinates = lastRow.rowCoordinates(column: lastColumn)
        let excludedLastRows = lastRowCoordinates.filter {
            ($0 == firstRow) && ($0 == lastRow) && ($0 < lastRow)
        }
        drawTexture(structure.bottom, row: lastRow, excluding: excludedLastRows)


        //        if let object = object {
        //            addObject(object,
        //                      startingCoordinate: Coordinate(x: firstRow,
        //                                                     y: firstColumn),
        //                      endingCoordinate: Coordinate(x: lastRow,
        //                                                   y: lastColumn))
        //        }

    }
    
    /// Draw a single texture on all tiles.
    public func drawTexture(_ texture: SKTexture) {
        drawTexture(texture, on: tiles)
    }

    /// Draw a single texture on all tiles in a specific row.
    public func drawTexture(_ texture: SKTexture, row: Int, excluding columns: [Int] = []) {
        let tilesOnRow = self.tiles.filter {
            $0.coordinate.x == row && !columns.contains($0.coordinate.y)
        }
        drawTexture(texture, on: tilesOnRow)
    }

    /// Draw a single texture on all tiles in a specific column.
    public func drawTexture(_ texture: SKTexture, column: Int, excluding rows: [Int] = []) {
        let tilesOnColumn = self.tiles.filter {
            ($0.coordinate.y == column) && !rows.contains($0.coordinate.x)
        }
        drawTexture(texture, on: tilesOnColumn)
    }
    
    // Apply a texture on all the tiles in multiples columns of the map
    public func applyTexture(_ texture: SKTexture,
                             startingColumn: Int,
                             endingColumn: Int) {
        for column in startingColumn..<endingColumn {
            drawTexture(texture, column: column)
        }
    }
    
    // Apply a texture on all the tiles in multiples row of the map
    public func applyTexture(_ texture: SKTexture,
                             startingRow: Int,
                             endingRow: Int) {
        for row in startingRow..<endingRow {
            drawTexture(texture, row: row)
        }
    }
    
    /// Draw a single texture on one tile at a specific coordinate.
    public func drawTexture(_ texture: SKTexture, at coordinate: Coordinate) {
        let tileNode = self.tiles.tile(at: coordinate)
        tileNode?.texture = texture
    }

    /// Draw a shape of a single texture.
    public func drawTexture(_ texture: SKTexture,
                            matrix: Matrix,
                            startingCoordinate: Coordinate) {

        let endingCoordinate = matrix.lastCoordinate(from: startingCoordinate)

        let coordinates = Coordinate.coordinates(from: matrix.firstCoordinate,
                                                 to: matrix.lastCoordinate)

        for coordinate in coordinates {
            let isIncluding = isIncludingOtherCoordinates(coordinate,
                                                          startingCoordinate: startingCoordinate,
                                                          endingCoordinate: endingCoordinate)
            if isIncluding {
                drawTexture(texture, at: coordinate)
            }
        }
    }
    
    // MARK: - PRIVATE
    
    private func tiles(count: Int) -> [PKTileNode] {
        var tileNodes: [PKTileNode] = []
        for _ in 0..<count {
            let tileNode = PKTileNode()
            tileNode.size = tileSize
            tileNode.texture = SKTexture(imageNamed: "")
            tileNodes.append(tileNode)
        }
        return tileNodes
    }
    private func createMap() {
        var tileNodes = tiles(count: matrix.product)
        tileNodes.attributeCoordinates(splittedBy: matrix.column)
        group.createSpriteCollection(of: tileNodes,
                                     at: origin,
                                     in: self,
                                     parameter: .init(columns: matrix.column))
    }
    private func drawTexture(_ texture: SKTexture, on tiles: [PKTileNode]) {
        tiles.forEach { $0.texture = texture }
    }
    private func isIncludingOtherCoordinates(_ coordinate: Coordinate,
                                             startingCoordinate: Coordinate,
                                             endingCoordinate: Coordinate) -> Bool {
        coordinate.x >= startingCoordinate.x &&
        coordinate.y >= startingCoordinate.y &&
        coordinate.x <= endingCoordinate.x &&
        coordinate.y <= endingCoordinate.y
    }
}
