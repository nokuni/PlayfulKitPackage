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
    
    func tileNode(with coordinate: PKCoordinate) -> PKTileNode? {
        tiles.first(where: { $0.coordinate == coordinate })
    }
}
