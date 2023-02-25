//
//  PKMapNode.swift
//  
//
//  Created by Maertens Yann-Christophe on 15/02/23.
//

import SpriteKit

public class PKMapNode: SKNode {
    
    public init(squareSize: CGSize = CGSize(width: 25, height: 25),
                matrix: Matrix = Matrix(row: 10, column: 10),
                origin: CGPoint = CGPoint.center) {
        
        self.squareSize = squareSize
        self.matrix = matrix
        self.origin = origin
        
        super.init()
        
        self.createMap()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var squareSize: CGSize
    public var matrix: Matrix
    public var origin: CGPoint
    
    private let assembly = AssemblyManager()
    
    // MARK: - OBJECTS
    
    /// Add a single object at a specific coordinate
    public func addObject(_ object: PKObjectNode, texture: SKTexture, at coordinate: Coordinate) {
        guard let position = tilePosition(from: coordinate) else { return }
        if let newObject = object.copy() as? PKObjectNode {
            newObject.size = squareSize
            newObject.texture = texture
            newObject.coordinate = coordinate
            newObject.position = position
            addChild(newObject)
        }
    }
    
    /// Add objects over specific coordinates.
    public func addObject(_ object: PKObjectNode,
                          texture: SKTexture,
                          matrix: Matrix,
                          startingCoordinate: Coordinate) {
        
        let endingCoordinate = matrix.lastCoordinate(from: startingCoordinate)
        
        let coordinates = Coordinate.coordinates(from: self.matrix.firstCoordinate,
                                                 to: self.matrix.lastCoordinate,
                                                 in: self.matrix)
        
        for coordinate in coordinates {
            let isIncluding = isIncludingOtherCoordinates(coordinate,
                                                          startingCoordinate: startingCoordinate,
                                                          endingCoordinate: endingCoordinate)
            if isIncluding {
                if let newObject = object.copy() as? PKObjectNode {
                    addObject(newObject, texture: texture, at: coordinate)
                }
            }
        }
    }
    
    /// Add objects over a specific row.
    public func addObject(_ object: PKObjectNode,
                          texture: SKTexture,
                          row: Int,
                          excluding columns: [Coordinate] = []) {
        let tilesOnRow = self.tiles.filter {
            $0.coordinate.x == row && !columns.contains($0.coordinate)
        }
        let coordinates = tilesOnRow.map { $0.coordinate }
        for coordinate in coordinates {
            if let newObject = object.copy() as? PKObjectNode {
                addObject(newObject, texture: texture, at: coordinate)
            }
        }
    }
    
    /// Add objects over a specific column.
    public func addObject(_ object: PKObjectNode,
                          texture: SKTexture,
                          column: Int,
                          excluding rows: [Coordinate] = []) {
        let tilesOnColumn = self.tiles.filter {
            ($0.coordinate.y == column) && !rows.contains($0.coordinate)
        }
        let coordinates = tilesOnColumn.map { $0.coordinate }
        for coordinate in coordinates {
            if let newObject = object.copy() as? PKObjectNode {
                addObject(newObject, texture: texture, at: coordinate)
            }
        }
    }
    
    /// Add objects following a specific textured structure.
    public func addObject(_ object: PKObjectNode,
                          structure: MapStructure,
                          startingCoordinate: Coordinate = Coordinate.zero,
                          matrix: Matrix) {
        
        let endingCoordinate = matrix.lastCoordinate(from: startingCoordinate)
        
        let firstRow = startingCoordinate.x
        let lastRow = endingCoordinate.x
        
        let firstColumn = startingCoordinate.y
        let lastColumn = endingCoordinate.y
        
        // Fill all area with object with middle texture first
        addObject(object,
                  texture: structure.middle,
                  matrix: matrix,
                  startingCoordinate: startingCoordinate
        )
        
        let topLeftCornerCoordinate = Coordinate(x: firstRow, y: firstColumn)
        let topRightCornerCoordinate = Coordinate(x: firstRow, y: lastColumn)
        let bottomLeftCornerCoordinate = Coordinate(x: lastRow, y: firstColumn)
        let bottomRightCornerCoordinate = Coordinate(x: lastRow, y: lastColumn)
        
        // Fill corners
        addObject(object,
                  texture: structure.topLeft,
                  at: topLeftCornerCoordinate)
        addObject(object,
                  texture: structure.topRight,
                  at: topRightCornerCoordinate)
        addObject(object,
                  texture: structure.bottomLeft,
                  at: bottomLeftCornerCoordinate)
        addObject(object,
                  texture: structure.bottomRight,
                  at: bottomRightCornerCoordinate)
        
        // Fill first column
        let firstColumnCoordinates = columnCoordinates(firstColumn)
        let excludedFirstColumns = firstColumnCoordinates.filter {
            ($0 == Coordinate(x: firstRow, y: $0.y)) ||
            ($0 == Coordinate(x: lastRow, y: $0.y)) ||
            $0.x > lastRow ||
            $0.x < firstRow
        }
        addObject(object, texture: structure.left, column: firstColumn, excluding: excludedFirstColumns)
        
        // Fill last column
        let lastColumnCoordinates = columnCoordinates(lastColumn)
        let excludedLastColumns = lastColumnCoordinates.filter {
            ($0 == Coordinate(x: firstRow, y: $0.y)) ||
            ($0 == Coordinate(x: lastRow, y: $0.y)) ||
            $0.x > lastRow ||
            $0.x < firstRow
        }
        addObject(object, texture: structure.right, column: lastColumn, excluding: excludedLastColumns)
        
        // Fill first row
        let firstRowCoordinates = rowCoordinates(firstRow)
        let excludedFirstRows = firstRowCoordinates.filter {
            ($0 == Coordinate(x: $0.x, y: firstColumn)) ||
            ($0 == Coordinate(x: $0.x, y: lastColumn)) ||
            $0.y > lastColumn ||
            $0.y < firstColumn
        }
        addObject(object, texture: structure.top, row: firstRow, excluding: excludedFirstRows)
        
        // Fill last row
        let lastRowCoordinates = rowCoordinates(lastRow)
        let excludedLastRows = lastRowCoordinates.filter {
            ($0 == Coordinate(x: $0.x, y: firstColumn)) ||
            ($0 == Coordinate(x: $0.x, y: lastColumn)) ||
            $0.y > lastColumn ||
            $0.y < firstColumn
        }
        addObject(object, texture: structure.bottom, row: lastRow, excluding: excludedLastRows)
    }
    
    /// Add object with multiples textures over specific coordinates
    public func addMultipleTexturedObject(_ object: PKObjectNode,
                                          textures: [SKTexture],
                                          matrix: Matrix,
                                          startingCoordinate: Coordinate) {
        
        let endingCoordinate = matrix.lastCoordinate(from: startingCoordinate)
        
        let coordinates = Coordinate.coordinates(from: self.matrix.firstCoordinate,
                                                 to: self.matrix.lastCoordinate,
                                                 in: self.matrix)
        
        let shapedCoordinates = coordinates.filter {
            isIncludingOtherCoordinates($0,
                                        startingCoordinate: startingCoordinate,
                                        endingCoordinate: endingCoordinate)
        }
        
        guard shapedCoordinates.count == textures.count else { return }
        
        for index in shapedCoordinates.indices {
            addObject(object, texture: textures[index], at: shapedCoordinates[index])
        }
    }
    
    // MARK: - TEXTURES
    
    /// Draw textures following a specific structure.
    public func drawTexture(structure: MapStructure,
                            startingCoordinate: Coordinate = Coordinate.zero,
                            matrix: Matrix) {
        
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
        let firstColumnCoordinates = columnCoordinates(firstColumn)
        let excludedFirstColumns = firstColumnCoordinates.filter {
            ($0 == Coordinate(x: firstRow, y: $0.y)) ||
            ($0 == Coordinate(x: lastRow, y: $0.y)) ||
            $0.x > lastRow ||
            $0.x < firstRow
        }
        drawTexture(structure.left, column: firstColumn, excluding: excludedFirstColumns)
        
        // Fill last column
        let lastColumnCoordinates = columnCoordinates(lastColumn)
        let excludedLastColumns = lastColumnCoordinates.filter {
            ($0 == Coordinate(x: firstRow, y: $0.y)) ||
            ($0 == Coordinate(x: lastRow, y: $0.y)) ||
            $0.x > lastRow ||
            $0.x < firstRow
        }
        drawTexture(structure.right, column: lastColumn, excluding: excludedLastColumns)
        
        // Fill first row
        let firstRowCoordinates = rowCoordinates(firstRow)
        let excludedFirstRows = firstRowCoordinates.filter {
            ($0 == Coordinate(x: $0.x, y: firstColumn)) ||
            ($0 == Coordinate(x: $0.x, y: lastColumn)) ||
            $0.y > lastColumn ||
            $0.y < firstColumn
        }
        drawTexture(structure.top, row: firstRow, excluding: excludedFirstRows)
        
        // Fill last row
        let lastRowCoordinates = rowCoordinates(lastRow)
        let excludedLastRows = lastRowCoordinates.filter {
            ($0 == Coordinate(x: $0.x, y: firstColumn)) ||
            ($0 == Coordinate(x: $0.x, y: lastColumn)) ||
            $0.y > lastColumn ||
            $0.y < firstColumn
        }
        drawTexture(structure.bottom, row: lastRow, excluding: excludedLastRows)
        
    }
    
    /// Draw a single texture on all tiles.
    public func drawTexture(_ texture: SKTexture) {
        drawTexture(texture, on: tiles)
    }
    
    /// Draw a single texture over a specific row.
    public func drawTexture(_ texture: SKTexture, row: Int, excluding columns: [Coordinate] = []) {
        let tilesOnRow = self.tiles.filter {
            $0.coordinate.x == row && !columns.contains($0.coordinate)
        }
        drawTexture(texture, on: tilesOnRow)
    }
    
    /// Draw a single texture over a specific column.
    public func drawTexture(_ texture: SKTexture, column: Int, excluding rows: [Coordinate] = []) {
        let tilesOnColumn = self.tiles.filter {
            ($0.coordinate.y == column) && !rows.contains($0.coordinate)
        }
        drawTexture(texture, on: tilesOnColumn)
    }
    
    /// Draw a single texture on one tile at a specific coordinate.
    public func drawTexture(_ texture: SKTexture, at coordinate: Coordinate) {
        let tileNode = self.tiles.tile(at: coordinate)
        tileNode?.texture = texture
    }
    
    /// Draw a single texture over specific coordinates.
    public func drawTexture(_ texture: SKTexture,
                            matrix: Matrix,
                            startingCoordinate: Coordinate) {
        
        let endingCoordinate = matrix.lastCoordinate(from: startingCoordinate)
        
        let coordinates = Coordinate.coordinates(from: self.matrix.firstCoordinate,
                                                 to: self.matrix.lastCoordinate,
                                                 in: self.matrix)
        
        for coordinate in coordinates {
            let isIncluding = isIncludingOtherCoordinates(coordinate,
                                                          startingCoordinate: startingCoordinate,
                                                          endingCoordinate: endingCoordinate)
            if isIncluding {
                drawTexture(texture, at: coordinate)
            }
        }
    }
    
    /// Draw multiple textures over specific coordinates
    public func drawMultipleTextures(_ textures: [SKTexture],
                                     matrix: Matrix,
                                     startingCoordinate: Coordinate) {
        
        let endingCoordinate = matrix.lastCoordinate(from: startingCoordinate)
        
        let coordinates = Coordinate.coordinates(from: self.matrix.firstCoordinate,
                                                 to: self.matrix.lastCoordinate,
                                                 in: self.matrix)
        
        let shapedCoordinates = coordinates.filter {
            isIncludingOtherCoordinates($0,
                                        startingCoordinate: startingCoordinate,
                                        endingCoordinate: endingCoordinate)
        }
        
        guard shapedCoordinates.count == textures.count else { return }
        
        for index in shapedCoordinates.indices {
            drawTexture(textures[index], at: shapedCoordinates[index])
        }
    }
    
    // MARK: - PRIVATE
    
    private func tiles(count: Int) -> [PKTileNode] {
        var tileNodes: [PKTileNode] = []
        for _ in 0..<count {
            let tileNode = PKTileNode()
            tileNode.size = squareSize
            tileNode.texture = SKTexture(imageNamed: "")
            tileNodes.append(tileNode)
        }
        return tileNodes
    }
    private func createMap() {
        var tileNodes = tiles(count: matrix.total)
        tileNodes.attributeCoordinates(splittedBy: matrix.column)
        assembly.createSpriteCollection(of: tileNodes,
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
