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
        
        try? createMap()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var squareSize: CGSize
    public var matrix: Matrix
    public var origin: CGPoint
    
    private let assembly = AssemblyManager()
    
    // MARK: - OBJECTS
    
    public func addUniqueObject(_ object: PKObjectNode,
                                at coordinate: Coordinate) {
        guard let position = tilePosition(from: coordinate) else { return }
        object.size = squareSize
        object.coordinate = coordinate
        object.position = position
        addChildSafely(object)
    }
    
    /// Add a single object at a specific coordinate
    public func addObject(_ object: PKObjectNode,
                          texture: SKTexture,
                          size: CGSize,
                          logic: LogicBody = LogicBody(),
                          drops: [Any] = [],
                          animations: [ObjectAnimation] = [],
                          at coordinate: Coordinate) {
        guard let position = tilePosition(from: coordinate) else { return }
        if let newObject = object.copy() as? PKObjectNode {
            newObject.size = size
            newObject.texture = texture
            newObject.coordinate = coordinate
            newObject.logic = logic
            newObject.drops = drops
            newObject.animations = animations
            newObject.position = position
            addChildSafely(newObject)
        }
    }
    
    /// Add objects over specific coordinates.
    public func addObject(_ object: PKObjectNode,
                          texture: SKTexture,
                          size: CGSize,
                          logic: LogicBody = LogicBody(),
                          animations: [ObjectAnimation] = [],
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
                    addObject(newObject,
                              texture: texture,
                              size: size,
                              logic: logic,
                              animations: animations,
                              at: coordinate)
                }
            }
        }
    }
    
    /// Add objects over a specific row.
    public func addObject(_ object: PKObjectNode,
                          texture: SKTexture,
                          filteringMode: SKTextureFilteringMode = .linear,
                          size: CGSize,
                          logic: LogicBody = LogicBody(),
                          animations: [ObjectAnimation] = [],
                          row: Int,
                          excluding columns: [Coordinate] = []) {
        let tilesOnRow = self.tiles.filter {
            $0.coordinate.x == row && !columns.contains($0.coordinate)
        }
        let coordinates = tilesOnRow.map { $0.coordinate }
        for coordinate in coordinates {
            if let newObject = object.copy() as? PKObjectNode {
                addObject(newObject,
                          texture: texture,
                          size: size,
                          logic: logic,
                          animations: animations,
                          at: coordinate)
            }
        }
    }
    
    /// Add objects over a specific column.
    public func addObject(_ object: PKObjectNode,
                          texture: SKTexture,
                          filteringMode: SKTextureFilteringMode = .linear,
                          size: CGSize,
                          logic: LogicBody = LogicBody(),
                          animations: [ObjectAnimation] = [],
                          column: Int,
                          excluding rows: [Coordinate] = []) {
        let tilesOnColumn = self.tiles.filter {
            ($0.coordinate.y == column) && !rows.contains($0.coordinate)
        }
        let coordinates = tilesOnColumn.map { $0.coordinate }
        for coordinate in coordinates {
            if let newObject = object.copy() as? PKObjectNode {
                addObject(newObject,
                          texture: texture,
                          size: size,
                          logic: logic,
                          animations: animations,
                          at: coordinate)
            }
        }
    }
    
    /// Add objects following a specific textured structure.
    public func addObject(_ object: PKObjectNode,
                          structure: MapStructure,
                          size: CGSize,
                          logic: LogicBody = LogicBody(),
                          animations: [ObjectAnimation] = [],
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
                  size: size,
                  logic: logic,
                  animations: animations,
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
                  size: size,
                  logic: logic,
                  animations: animations,
                  at: topLeftCornerCoordinate)
        addObject(object,
                  texture: structure.topRight,
                  size: size,
                  logic: logic,
                  animations: animations,
                  at: topRightCornerCoordinate)
        addObject(object,
                  texture: structure.bottomLeft,
                  size: size,
                  logic: logic,
                  animations: animations,
                  at: bottomLeftCornerCoordinate)
        addObject(object,
                  texture: structure.bottomRight,
                  size: size,
                  logic: logic,
                  animations: animations,
                  at: bottomRightCornerCoordinate)
        
        // Fill first column
        let firstColumnCoordinates = columnCoordinates(firstColumn)
        let excludedFirstColumns = firstColumnCoordinates.filter {
            ($0 == Coordinate(x: firstRow, y: $0.y)) ||
            ($0 == Coordinate(x: lastRow, y: $0.y)) ||
            $0.x > lastRow ||
            $0.x < firstRow
        }
        addObject(object,
                  texture: structure.left,
                  size: size,
                  logic: logic,
                  animations: animations,
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
        addObject(object,
                  texture: structure.right,
                  size: size,
                  logic: logic,
                  animations: animations,
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
        addObject(object,
                  texture: structure.top,
                  size: size,
                  logic: logic,
                  animations: animations,
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
        addObject(object,
                  texture: structure.bottom,
                  size: size,
                  logic: logic,
                  animations: animations,
                  row: lastRow,
                  excluding: excludedLastRows)
    }
    
    /// Add object with multiples textures over specific coordinates
    public func addMultipleTexturedObject(_ object: PKObjectNode,
                                          textures: [SKTexture],
                                          filteringMode: SKTextureFilteringMode = .linear,
                                          size: CGSize,
                                          logic: LogicBody = LogicBody(),
                                          animations: [ObjectAnimation] = [],
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
            addObject(object,
                      texture: textures[index],
                      size: size,
                      logic: logic,
                      animations: animations,
                      at: shapedCoordinates[index])
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
    public func drawTexture(_ texture: SKTexture,
                            row: Int,
                            excluding columns: [Coordinate] = []) {
        let tilesOnRow = self.tiles.filter {
            $0.coordinate.x == row && !columns.contains($0.coordinate)
        }
        drawTexture(texture, on: tilesOnRow)
    }
    
    /// Draw a single texture over a specific column.
    public func drawTexture(_ texture: SKTexture,
                            column: Int,
                            excluding rows: [Coordinate] = []) {
        let tilesOnColumn = self.tiles.filter {
            ($0.coordinate.y == column) && !rows.contains($0.coordinate)
        }
        drawTexture(texture, on: tilesOnColumn)
    }
    
    /// Draw a single texture on one tile at a specific coordinate.
    public func drawTexture(_ texture: SKTexture,
                            at coordinate: Coordinate) {
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
    
    private func createMap() throws {
        var tileNodes = tiles(count: matrix.total)
        do { try tileNodes.attributeCoordinates(splittedBy: matrix.column) } catch {
            throw PKMapNodeError.matrixAtZero.rawValue
        }
        assembly.createNodeCollection(of: tileNodes,
                                      at: origin,
                                      in: self,
                                      parameter: .init(columns: matrix.column))
    }
    private func drawTexture(_ texture: SKTexture, on tiles: [PKTileNode]) {
        tiles.forEach {
            $0.texture = texture
            $0.texture?.preload { }
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
