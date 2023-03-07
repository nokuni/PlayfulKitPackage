//
//  File.swift
//  
//
//  Created by Maertens Yann-Christophe on 06/03/23.
//

import SpriteKit

class CollisionManager {
    
    struct NodeBody {
        let body: SKPhysicsBody
        let bitmaskCategory: UInt32
    }
    
    /// Compare two physics bodies and return true if they are colliding, false if they are not.
    func isColliding(_ first: NodeBody, with second: NodeBody) -> Bool {
        return first.body.categoryBitMask == first.bitmaskCategory && second.body.categoryBitMask == second.bitmaskCategory
    }
}
