//
//  Collision.swift
//  
//
//  Created by Maertens Yann-Christophe on 18/02/23.
//

import SpriteKit

/// Node collision.
public struct Collision {
    public init(category: CollisionCategory = .allSet,
                collision: [CollisionCategory] = [],
                contact: [CollisionCategory] = []) {
        self.category = category
        self.collision = collision
        self.contact = contact
    }
    public let category: CollisionCategory
    public let collision: [CollisionCategory]
    public let contact: [CollisionCategory]
    
    public var collisionBitMask: UInt32? {
        guard !collision.isEmpty else { return CollisionCategory.allSet.rawValue }
        return collision.withXOROperators()
    }
    public var contactBitMask: UInt32? {
        guard !contact.isEmpty else { return CollisionCategory.allClear.rawValue }
        return contact.withXOROperators()
    }
}
