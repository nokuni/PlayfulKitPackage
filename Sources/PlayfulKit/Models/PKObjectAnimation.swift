//
//  PKObjectAnimation.swift
//  
//
//  Created by Maertens Yann-Christophe on 19/02/23.
//

import Foundation

public struct PKObjectAnimation {
    public init(state: State,
                frames: [String] = []) {
        self.state = state
        self.frames = frames
    }
    
    public let state: State
    public var frames: [String]
    
    public enum State {
        case idle
        case walk
        case run
        case hit
        case attack
        case jump
        case death
    }
}
