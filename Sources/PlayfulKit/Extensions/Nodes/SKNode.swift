//
//  SKNodePhysicsBody.swift
//  
//
//  Created by Maertens Yann-Christophe on 18/02/23.
//

import SpriteKit

public extension SKNode {
    
    /// Apply a physics body and its collisions to the node.
    func applyPhysicsBody(size: CGSize, collision: Collision = Collision()) {
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.categoryBitMask = collision.category.rawValue
        self.physicsBody?.collisionBitMask = collision.collisionBitMask ?? CollisionCategory.allSet.rawValue
        self.physicsBody?.contactTestBitMask = collision.contactBitMask ?? CollisionCategory.allClear.rawValue
    }
}
