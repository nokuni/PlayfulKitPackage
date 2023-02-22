//
//  PKMapNodeUtilities.swift
//  
//
//  Created by Maertens Yann-Christophe on 15/02/23.
//

import SpriteKit

public extension PKMapNode {
    
    var tiles: [PKTileNode] {
        return self.children.compactMap { $0 as? PKTileNode }
    }
    
    var objects: [PKObjectNode] {
        return self.children.compactMap { $0 as? PKObjectNode }
    }
    
    func tileNode(at coordinate: Coordinate) -> PKTileNode? {
        tiles.first(where: { $0.coordinate == coordinate })
    }
    
    func tilePosition(from coordinate: Coordinate) -> CGPoint? {
        let tile = tileNode(at: coordinate)
        return tile?.position
    }
    
    func rowCoordinates(_ row: Int) -> [Coordinate] {
        let tiles = tiles.filter { $0.coordinate.x == row }
        let coordinates = tiles.map { $0.coordinate }
        return coordinates
    }
    
    func columnCoordinates(_ column: Int) -> [Coordinate] {
        let tiles = tiles.filter { $0.coordinate.y == column }
        let coordinates = tiles.map { $0.coordinate }
        return coordinates
    }
}
