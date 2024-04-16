//
//  Array.swift
//  
//
//  Created by Maertens Yann-Christophe on 17/02/23.
//

import SpriteKit
import UtilityToolbox

public extension Array where Element: PKTileNode {

    /// Attributes coordinates to PKTileNode elements.
    mutating func attributeCoordinates(splittedBy columns: Int) throws {
        guard columns > 0 else { throw PKMapNodeError.matrixAtZero.rawValue }
        var coordinate = Coordinate.zero
        let splittedTiles = self.splitted(into: columns)
        for column in splittedTiles.indices {
            for index in splittedTiles[column].indices {
                splittedTiles[column][index].coordinate = coordinate
                coordinate.y += 1
            }
            coordinate.x += 1
            coordinate.y = 0
        }
        let tiles = splittedTiles.joined().map { $0 }
        self = tiles
    }

    /// Returns a PKTileNode at a specific coordinate.
    func tile(at coordinate: Coordinate) -> PKTileNode? {
        let tileNode = self.first(where: { $0.coordinate == coordinate })
        return tileNode
    }
}
