//
//  CollisionCategory.swift
//  
//
//  Created by Maertens Yann-Christophe on 18/02/23.
//

import Foundation

public struct CollisionCategory: OptionSet {
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    
    public let rawValue: UInt32

    public static let allClear         = CollisionCategory([])
    public static let allSet           = CollisionCategory(rawValue: 0xFFFFFFFF)
    public static let player           = CollisionCategory(rawValue: 0x1 << 0)
    public static let playerProjectile = CollisionCategory(rawValue: 0x1 << 1)
    public static let enemy            = CollisionCategory(rawValue: 0x1 << 2)
    public static let enemyProjectile  = CollisionCategory(rawValue: 0x1 << 3)
    public static let object           = CollisionCategory(rawValue: 0x1 << 4)
    public static let structure        = CollisionCategory(rawValue: 0x1 << 5)
}
