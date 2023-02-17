//
//  ArrayPKTileNode.swift
//  
//
//  Created by Maertens Yann-Christophe on 17/02/23.
//

import SpriteKit

public extension Array where Element: PKTileNode {
    
    mutating func coordinateTiles(splittedBy rows: Int) {
        var coordinate = PKCoordinate()
        let splittedTiles = self.splitted(into: rows)
        for row in splittedTiles.indices {
            for index in splittedTiles[row].indices {
                splittedTiles[row][index].coordinate = coordinate
                coordinate.y += 1
            }
            coordinate.x += 1
            coordinate.y = 0
        }
        let tiles = splittedTiles.joined().map { $0 }
        self = tiles
    }
    
    func tile(at coordinate: PKCoordinate) -> PKTileNode? {
        let tileNode = self.first(where: { $0.coordinate == coordinate })
        return tileNode
    }
}
