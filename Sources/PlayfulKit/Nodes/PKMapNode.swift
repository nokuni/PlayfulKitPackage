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
    
    // MARK: - PUBLIC
    
    // Apply a texture on all the tiles of the map
    public func applyTexture(_ texture: SKTexture) {
        applyTexture(texture, on: self.tiles)
    }
    
    // Apply a texture on all the tiles in a specific row of the map
    public func applyTexture(_ texture: SKTexture, on row: Int) {
        let tilesAtRow = self.tiles.filter { $0.coordinate.x == row }
        applyTexture(texture, on: tilesAtRow)
    }
    
    // Apply a texture on all the tiles in multiples row of the map
    public func applyTexture(_ texture: SKTexture,
                             from startingRow: Int,
                             to endingRow: Int) {
        for row in startingRow..<endingRow {
            applyTexture(texture, on: row)
        }
    }
    
    // Apply a texture on one tiles at a specific coordinate
    public func applyTexture(_ texture: SKTexture, at coordinate: PKCoordinate) {
        let tileNode = self.tiles.tile(at: coordinate)
        tileNode?.texture = texture
    }
    
    // Apply a texture on all the tiles from a coordinate to another.
    public func applyTexture(_ texture: SKTexture,
                             from startingCoordinate: PKCoordinate,
                             to endingCoordinate: PKCoordinate) {
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
