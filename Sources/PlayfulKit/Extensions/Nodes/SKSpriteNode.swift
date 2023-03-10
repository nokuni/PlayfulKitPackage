//
//  SKSpriteNode.swift
//  
//
//  Created by Maertens Yann-Christophe on 10/03/23.
//

import SpriteKit

extension SKSpriteNode {
    
    /// Apply a physics body and its collisions to the node.
    func applyPhysicsBody(size: CGSize,
                          collision: Collision = Collision(),
                          isPixelPerfect: Bool = false) {
        self.physicsBody = texture != nil && isPixelPerfect ?
        SKPhysicsBody(texture: texture!, size: size) : SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.categoryBitMask = collision.category.rawValue
        self.physicsBody?.collisionBitMask = collision.collisionBitMask ?? CollisionCategory.allSet.rawValue
        self.physicsBody?.contactTestBitMask = collision.contactBitMask ?? CollisionCategory.allClear.rawValue
    }
}
