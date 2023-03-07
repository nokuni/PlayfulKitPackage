//
//  File.swift
//  
//
//  Created by Maertens Yann-Christophe on 06/03/23.
//

import SpriteKit

public class CollisionManager {
    
    public init() { }
    
    public struct NodeBody {
        public init(body: SKPhysicsBody, bitmaskCategory: UInt32) {
            self.body = body
            self.bitmaskCategory = bitmaskCategory
        }
        
        public let body: SKPhysicsBody
        public let bitmaskCategory: UInt32
    }
    
    /// Compare two physics bodies and return true if they are colliding, false if they are not.
    public func isColliding(_ first: NodeBody, with second: NodeBody) -> Bool {
        return first.body.categoryBitMask == first.bitmaskCategory && second.body.categoryBitMask == second.bitmaskCategory
    }
}
