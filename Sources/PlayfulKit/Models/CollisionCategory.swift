//
//  CollisionCategory.swift
//  
//
//  Created by Maertens Yann-Christophe on 18/02/23.
//

import Foundation

/// The category of a node collision.
public struct CollisionCategory: OptionSet {
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    
    public let rawValue: UInt32

    /// No collision.
    public static let allClear         = CollisionCategory(rawValue: .allClear)
    /// Collision with any nodes.
    public static let allSet           = CollisionCategory(rawValue: .allSet)
    /// Player collision.
    public static let player           = CollisionCategory(rawValue: 0x1 << 0)
    /// Player projectiles collision.
    public static let playerProjectile = CollisionCategory(rawValue: 0x1 << 1)
    /// Enemy collision.
    public static let enemy            = CollisionCategory(rawValue: 0x1 << 2)
    /// Enemy projectiles collision.
    public static let enemyProjectile  = CollisionCategory(rawValue: 0x1 << 3)
    /// Object collision.
    public static let object           = CollisionCategory(rawValue: 0x1 << 4)
    /// Structure collision.
    public static let structure        = CollisionCategory(rawValue: 0x1 << 5)
}
