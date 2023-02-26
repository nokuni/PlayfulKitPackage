//
//  LogicBody.swift
//  
//
//  Created by Maertens Yann-Christophe on 19/02/23.
//

import Foundation

/// The logic of an object.
public struct LogicBody {
    public var health: Int = 1
    public var healthLost: Int = 0
    public var damage: Int = 0
    public var isDestructible: Bool = false
}
