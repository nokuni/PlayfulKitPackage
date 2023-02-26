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
    public func addSingleObject(_ object: PKObjectNode,
                                image: String,
                                filteringMode: SKTextureFilteringMode = .linear,
                                collision: Collision,
                                logic: LogicBody,
                                at coordinate: Coordinate) {
        guard let position = tilePosition(from: coordinate) else { return }
        object.size = squareSize
        object.texture = SKTexture(imageNamed: image)
        object.texture?.filteringMode = filteringMode
        object.applyPhysicsBody(size: object.size, collision: collision)
        object.logic = logic
        object.coordinate = coordinate
        object.position = position
        addChild(object)
    }
    
    /// Add a single object at a specific coordinate
    public func addDuplicableObject(image: String,
                                    filteringMode: SKTextureFilteringMode = .linear,
                                    collision: Collision,
                                    logic: LogicBody,
                                    at coordinate: Coordinate) {
        guard let position = tilePosition(from: coordinate) else { return }
        let object = PKObjectNode(imageNamed: image)
        object.size = squareSize
        object.texture?.filteringMode = filteringMode
        object.applyPhysicsBody(size: object.size, collision: collision)
        object.logic = logic
        object.coordinate = coordinate
        object.position = position
        addChild(object)
    }
    
    /// Add objects over specific coordinates.
    public func addObject(image: String,
                          filteringMode: SKTextureFilteringMode = .linear,
                          collision: Collision,
                          logic: LogicBody,
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
                addDuplicableObject(image: image,
                                    filteringMode: filteringMode,
                                    collision: collision,
                                    logic: logic,
                                    at: coordinate)
            }
        }
    }
    
    /// Add objects over a specific row.
    public func addObject(image: String,
                          filteringMode: SKTextureFilteringMode = .linear,
                          collision: Collision,
                          logic: LogicBody,
                          row: Int,
                          excluding columns: [Coordinate] = []) {
        let tilesOnRow = self.tiles.filter {
            $0.coordinate.x == row && !columns.contains($0.coordinate)
        }
        let coordinates = tilesOnRow.map { $0.coordinate }
        for coordinate in coordinates {
            addDuplicableObject(image: image,
                                filteringMode: filteringMode,
                                collision: collision,
                                logic: logic,
                                at: coordinate)
        }
    }
    
    /// Add objects over a specific column.
    public func addObject(image: String,
                          filteringMode: SKTextureFilteringMode = .linear,
                          collision: Collision,
                          logic: LogicBody,
                          column: Int,
                          excluding rows: [Coordinate] = []) {
        let tilesOnColumn = self.tiles.filter {
            ($0.coordinate.y == column) && !rows.contains($0.coordinate)
        }
        let coordinates = tilesOnColumn.map { $0.coordinate }
        for coordinate in coordinates {
            addDuplicableObject(image: image,
                                filteringMode: filteringMode,
                                collision: collision,
                                logic: logic,
                                at: coordinate)
        }
    }
    
    /// Add objects following a specific textured structure.
    public func addObject(structure: MapStructure,
                          filteringMode: SKTextureFilteringMode = .linear,
                          collision: Collision,
                          logic: LogicBody,
                          startingCoordinate: Coordinate = Coordinate.zero,
                          matrix: Matrix) {
        
        let endingCoordinate = matrix.lastCoordinate(from: startingCoordinate)
        
        let firstRow = startingCoordinate.x
        let lastRow = endingCoordinate.x
        
        let firstColumn = startingCoordinate.y
        let lastColumn = endingCoordinate.y
        
        // Fill all area with object with middle texture first
        addObject(image: structure.middle,
                  filteringMode: filteringMode,
                  collision: collision,
                  logic: logic,
                  matrix: matrix,
                  startingCoordinate: startingCoordinate
        )
        
        let topLeftCornerCoordinate = Coordinate(x: firstRow, y: firstColumn)
        let topRightCornerCoordinate = Coordinate(x: firstRow, y: lastColumn)
        let bottomLeftCornerCoordinate = Coordinate(x: lastRow, y: firstColumn)
        let bottomRightCornerCoordinate = Coordinate(x: lastRow, y: lastColumn)
        
        // Fill corners
        addDuplicableObject(image: structure.topLeft,
                            filteringMode: filteringMode,
                            collision: collision,
                            logic: logic,
                            at: topLeftCornerCoordinate)
        
        addDuplicableObject(image: structure.topRight,
                            filteringMode: filteringMode,
                            collision: collision,
                            logic: logic,
                            at: topRightCornerCoordinate)
        
        addDuplicableObject(image: structure.bottomLeft,
                            filteringMode: filteringMode,
                            collision: collision,
                            logic: logic,
                            at: bottomLeftCornerCoordinate)
        
        addDuplicableObject(image: structure.bottomRight,
                            filteringMode: filteringMode,
                            collision: collision,
                            logic: logic,
                            at: bottomRightCornerCoordinate)
        
        // Fill first column
        let firstColumnCoordinates = columnCoordinates(firstColumn)
        let excludedFirstColumns = firstColumnCoordinates.filter {
            ($0 == Coordinate(x: firstRow, y: $0.y)) ||
            ($0 == Coordinate(x: lastRow, y: $0.y)) ||
            $0.x > lastRow ||
            $0.x < firstRow
        }
        addObject(image: structure.left,
                  filteringMode: filteringMode,
                  collision: collision,
                  logic: logic,
                  column: firstColumn,
                  excluding: excludedFirstColumns)
        
        // Fill last column
        let lastColumnCoordinates = columnCoordinates(lastColumn)
        let excludedLastColumns = lastColumnCoordinates.filter {
            ($0 == Coordinate(x: firstRow, y: $0.y)) ||
            ($0 == Coordinate(x: lastRow, y: $0.y)) ||
            $0.x > lastRow ||
            $0.x < firstRow
        }
        addObject(image: structure.right,
                  filteringMode: filteringMode,
                  collision: collision,
                  logic: logic,
                  column: lastColumn,
                  excluding: excludedLastColumns)
        
        // Fill first row
        let firstRowCoordinates = rowCoordinates(firstRow)
        let excludedFirstRows = firstRowCoordinates.filter {
            ($0 == Coordinate(x: $0.x, y: firstColumn)) ||
            ($0 == Coordinate(x: $0.x, y: lastColumn)) ||
            $0.y > lastColumn ||
            $0.y < firstColumn
        }
        addObject(image: structure.top,
                  filteringMode: filteringMode,
                  collision: collision,
                  logic: logic,
                  row: firstRow,
                  excluding: excludedFirstRows)
        
        // Fill last row
        let lastRowCoordinates = rowCoordinates(lastRow)
        let excludedLastRows = lastRowCoordinates.filter {
            ($0 == Coordinate(x: $0.x, y: firstColumn)) ||
            ($0 == Coordinate(x: $0.x, y: lastColumn)) ||
            $0.y > lastColumn ||
            $0.y < firstColumn
        }
        addObject(image: structure.bottom,
                  filteringMode: filteringMode,
                  collision: collision,
                  logic: logic,
                  row: lastRow,
                  excluding: excludedLastRows)
    }
    
    /// Add object with multiples textures over specific coordinates
    public func addMultipleTexturedObject(_ object: PKObjectNode,
                                          images: [String],
                                          filteringMode: SKTextureFilteringMode = .linear,
                                          collision: Collision,
                                          logic: LogicBody,
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
        
        guard shapedCoordinates.count == images.count else { return }
        
        for index in shapedCoordinates.indices {
            addDuplicableObject(image: images[index],
                                filteringMode: filteringMode,
                                collision: collision,
                                logic: logic,
                                at: shapedCoordinates[index])
        }
    }
    
    // MARK: - TEXTURES
    
    /// Draw textures following a specific structure.
    public func drawTexture(structure: MapStructure,
                            filteringMode: SKTextureFilteringMode = .linear,
                            startingCoordinate: Coordinate = Coordinate.zero,
                            matrix: Matrix) {
        
        let endingCoordinate = matrix.lastCoordinate(from: startingCoordinate)
        
        let firstRow = startingCoordinate.x
        let lastRow = endingCoordinate.x
        
        let firstColumn = startingCoordinate.y
        let lastColumn = endingCoordinate.y
        
        // Fill all area with middle texture first
        drawTexture(structure.middle,
                    filteringMode: filteringMode,
                    matrix: matrix,
                    startingCoordinate: startingCoordinate
        )
        
        let topLeftCornerCoordinate = Coordinate(x: firstRow, y: firstColumn)
        let topRightCornerCoordinate = Coordinate(x: firstRow, y: lastColumn)
        let bottomLeftCornerCoordinate = Coordinate(x: lastRow, y: firstColumn)
        let bottomRightCornerCoordinate = Coordinate(x: lastRow, y: lastColumn)
        
        // Fill corners
        drawTexture(structure.topLeft,
                    filteringMode: filteringMode,
                    at: topLeftCornerCoordinate)
        drawTexture(structure.topRight,
                    filteringMode: filteringMode,
                    at: topRightCornerCoordinate)
        drawTexture(structure.bottomLeft,
                    filteringMode: filteringMode,
                    at: bottomLeftCornerCoordinate)
        drawTexture(structure.bottomRight,
                    filteringMode: filteringMode,
                    at: bottomRightCornerCoordinate)
        
        
        // Fill first column
        let firstColumnCoordinates = columnCoordinates(firstColumn)
        let excludedFirstColumns = firstColumnCoordinates.filter {
            ($0 == Coordinate(x: firstRow, y: $0.y)) ||
            ($0 == Coordinate(x: lastRow, y: $0.y)) ||
            $0.x > lastRow ||
            $0.x < firstRow
        }
        drawTexture(structure.left, filteringMode: filteringMode, column: firstColumn, excluding: excludedFirstColumns)
        
        // Fill last column
        let lastColumnCoordinates = columnCoordinates(lastColumn)
        let excludedLastColumns = lastColumnCoordinates.filter {
            ($0 == Coordinate(x: firstRow, y: $0.y)) ||
            ($0 == Coordinate(x: lastRow, y: $0.y)) ||
            $0.x > lastRow ||
            $0.x < firstRow
        }
        drawTexture(structure.right, filteringMode: filteringMode, column: lastColumn, excluding: excludedLastColumns)
        
        // Fill first row
        let firstRowCoordinates = rowCoordinates(firstRow)
        let excludedFirstRows = firstRowCoordinates.filter {
            ($0 == Coordinate(x: $0.x, y: firstColumn)) ||
            ($0 == Coordinate(x: $0.x, y: lastColumn)) ||
            $0.y > lastColumn ||
            $0.y < firstColumn
        }
        drawTexture(structure.top, filteringMode: filteringMode, row: firstRow, excluding: excludedFirstRows)
        
        // Fill last row
        let lastRowCoordinates = rowCoordinates(lastRow)
        let excludedLastRows = lastRowCoordinates.filter {
            ($0 == Coordinate(x: $0.x, y: firstColumn)) ||
            ($0 == Coordinate(x: $0.x, y: lastColumn)) ||
            $0.y > lastColumn ||
            $0.y < firstColumn
        }
        drawTexture(structure.bottom, filteringMode: filteringMode, row: lastRow, excluding: excludedLastRows)
        
    }
    
    /// Draw a single texture on all tiles.
    public func drawTexture(_ image: String, filteringMode: SKTextureFilteringMode = .linear) {
        drawTexture(image, filteringMode: filteringMode, on: tiles)
    }
    
    /// Draw a single texture over a specific row.
    public func drawTexture(_ image: String,
                            filteringMode: SKTextureFilteringMode = .linear,
                            row: Int,
                            excluding columns: [Coordinate] = []) {
        let tilesOnRow = self.tiles.filter {
            $0.coordinate.x == row && !columns.contains($0.coordinate)
        }
        drawTexture(image, filteringMode: filteringMode, on: tilesOnRow)
    }
    
    /// Draw a single texture over a specific column.
    public func drawTexture(_ image: String,
                            filteringMode: SKTextureFilteringMode = .linear,
                            column: Int,
                            excluding rows: [Coordinate] = []) {
        let tilesOnColumn = self.tiles.filter {
            ($0.coordinate.y == column) && !rows.contains($0.coordinate)
        }
        drawTexture(image, filteringMode: filteringMode, on: tilesOnColumn)
    }
    
    /// Draw a single texture on one tile at a specific coordinate.
    public func drawTexture(_ image: String, filteringMode: SKTextureFilteringMode = .linear, at coordinate: Coordinate) {
        let tileNode = self.tiles.tile(at: coordinate)
        tileNode?.texture = SKTexture(imageNamed: image)
        tileNode?.texture?.filteringMode = filteringMode
    }
    
    /// Draw a single texture over specific coordinates.
    public func drawTexture(_ image: String,
                            filteringMode: SKTextureFilteringMode = .linear,
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
                drawTexture(image, filteringMode: filteringMode, at: coordinate)
            }
        }
    }
    
    /// Draw multiple textures over specific coordinates
    public func drawMultipleTextures(_ images: [String],
                                     filteringMode: SKTextureFilteringMode = .linear,
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
        
        guard shapedCoordinates.count == images.count else { return }
        
        for index in shapedCoordinates.indices {
            drawTexture(images[index], filteringMode: filteringMode, at: shapedCoordinates[index])
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
    private func drawTexture(_ image: String,
                             filteringMode: SKTextureFilteringMode = .linear,
                             on tiles: [PKTileNode]) {
        tiles.forEach {
            $0.texture = SKTexture(imageNamed: image)
            $0.texture?.filteringMode = filteringMode
        }
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
