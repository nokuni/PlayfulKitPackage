//
//  SKNodePhysicsBody.swift
//  
//
//  Created by Maertens Yann-Christophe on 18/02/23.
//

import SpriteKit

public extension SKNode {
    
    enum BitMaskCategory: UInt32 {
        case allClear         = 0x00000000
        case allSet           = 0xFFFFFFFF
        case player           = 2
        case playerProjectile = 4
        case enemy            = 6
        case enemyProjectile  = 8
        case object           = 10
        case wall             = 12
        case ground           = 14
    }
    struct BitMask {
        public init(category: BitMaskCategory = .allSet,
                    collision: [BitMaskCategory] = [],
                    contact: [BitMaskCategory] = []) {
            self.category = category
            self.collision = collision
            self.contact = contact
        }
        public let category: BitMaskCategory
        public let collision: [BitMaskCategory]
        public let contact: [BitMaskCategory]
        
        public var collisionBitMask: UInt32? {
            guard collision.isEmpty else { return BitMaskCategory.allSet.rawValue }
            return collision.withXOROperators()
        }
        public var contactBitMask: UInt32? {
            guard contact.isEmpty else { return BitMaskCategory.allClear.rawValue }
            return contact.withXOROperators()
        }
    }
    
    func applyPhysicsBody(size: CGSize, bitMask: BitMask = BitMask()) {
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.categoryBitMask = bitMask.category.rawValue
        self.physicsBody?.collisionBitMask = bitMask.collisionBitMask ?? BitMaskCategory.allSet.rawValue
        self.physicsBody?.contactTestBitMask = bitMask.contactBitMask ?? BitMaskCategory.allClear.rawValue
    }
}
