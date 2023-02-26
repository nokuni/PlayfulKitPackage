//
//  ObjectAnimation.swift
//  
//
//  Created by Maertens Yann-Christophe on 19/02/23.
//

import Foundation

/// The animation of an object.
public struct ObjectAnimation {
    public init(identifier: String,
                frames: [String]) {
        self.identifier = identifier
        self.frames = frames
    }
    
    public let identifier: String
    public var frames: [String]
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

