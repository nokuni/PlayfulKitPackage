//
//  LogicBody.swift
//  
//
//  Created by Maertens Yann-Christophe on 19/02/23.
//

import Foundation

/// The logic of an object.
public struct LogicBody {
    public init(health: Int = 1,
                healthLost: Int = 0,
                damage: Int = 0,
                isDestructible: Bool = false) {
        self.health = health
        self.healthLost = healthLost
        self.damage = damage
        self.isDestructible = isDestructible
    }
    
    public var health: Int
    public var healthLost: Int
    public var damage: Int
    public var isDestructible: Bool
}
