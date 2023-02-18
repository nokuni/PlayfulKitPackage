//
//  SKNodePhysicsBody.swift
//  
//
//  Created by Maertens Yann-Christophe on 18/02/23.
//

import SpriteKit

public extension SKNode {
    
    func applyPhysicsBody(size: CGSize, bitMask: PKBitMask = PKBitMask()) {
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.categoryBitMask = bitMask.category.rawValue
        self.physicsBody?.collisionBitMask = bitMask.collisionBitMask ?? PKBitMaskCategory.allSet.rawValue
        self.physicsBody?.contactTestBitMask = bitMask.contactBitMask ?? PKBitMaskCategory.allClear.rawValue
    }
}
