//
//  PKBitMask.swift
//  
//
//  Created by Maertens Yann-Christophe on 18/02/23.
//

import SpriteKit

public struct PKBitMask {
    public init(category: PKBitMaskCategory = .allSet,
                collision: [PKBitMaskCategory] = [],
                contact: [PKBitMaskCategory] = []) {
        self.category = category
        self.collision = collision
        self.contact = contact
    }
    public let category: PKBitMaskCategory
    public let collision: [PKBitMaskCategory]
    public let contact: [PKBitMaskCategory]
    
    public var collisionBitMask: UInt32? {
        guard collision.isEmpty else { return PKBitMaskCategory.allSet.rawValue }
        return collision.withXOROperators()
    }
    public var contactBitMask: UInt32? {
        guard contact.isEmpty else { return PKBitMaskCategory.allClear.rawValue }
        return contact.withXOROperators()
    }
}
