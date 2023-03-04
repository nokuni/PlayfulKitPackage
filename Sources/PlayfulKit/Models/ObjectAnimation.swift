//
//  ObjectAnimation.swift
//  
//
//  Created by Maertens Yann-Christophe on 19/02/23.
//

import SpriteKit

/// The animation of an object.
public struct ObjectAnimation {
    public init(identifier: String,
                frames: [String] = [],
                filteringMode: SKTextureFilteringMode = .linear,
                timeInterval: TimeInterval = 0.1) {
        self.identifier = identifier
        self.frames = frames
        self.filteringMode = filteringMode
        self.timeInterval = timeInterval
    }
    
    public let identifier: String
    public var frames: [String]
    public var filteringMode: SKTextureFilteringMode
    public var timeInterval: TimeInterval
}

//enum ObjectAnimationCategory {
//    case idle
//    case walk
//    case run
//    case hit
//    case attack
//    case jump
//    case deletion
//}

