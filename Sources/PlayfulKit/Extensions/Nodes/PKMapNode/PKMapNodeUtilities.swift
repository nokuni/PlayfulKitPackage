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
    
    func tileNode(at coordinate: PKCoordinate) -> PKTileNode? {
        tiles.first(where: { $0.coordinate == coordinate })
    }
    
    func tilePosition(from coordinate: PKCoordinate) -> CGPoint? {
        let tile = tileNode(at: coordinate)
        return tile?.position
    }
}
