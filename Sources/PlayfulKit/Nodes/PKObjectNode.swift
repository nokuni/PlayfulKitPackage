//
//  PKObjectNode.swift
//  
//
//  Created by Maertens Yann-Christophe on 19/02/23.
//

import SpriteKit

/// An object node.
public class PKObjectNode: SKSpriteNode {
    public var coordinate = Coordinate.zero
    public var animations: [ObjectAnimation] = []
}

// MARK: - ANIMATIONS
public extension PKObjectNode {
    
    func addAnimation(_ animation: ObjectAnimation) {
        animations.append(animation)
    }
    
    func addMultipleAnimation(_ animations: [ObjectAnimation]) {
        self.animations.append(contentsOf: animations)
    }
    
    /// Get the action animation from an animation state.
    func animatedAction(with identifier: String,
                        filteringMode: SKTextureFilteringMode = .linear,
                        timeInterval: TimeInterval = 0.05,
                        repeatCount: Int = 0,
                        isRepeatingForever: Bool = false) -> SKAction {
        guard let animation = animation(from: identifier) else { return SKAction() }
        guard !animation.frames.isEmpty else { return SKAction() }
        let action = SKAction.animate(with: animation.frames,
                                      filteringMode: filteringMode,
                                      timePerFrame: timeInterval)
        switch true {
        case isRepeatingForever:
            return SKAction.repeatForever(action)
        case repeatCount > 0:
            return SKAction.repeat(action, count: repeatCount)
        default:
            return action
        }
    }
    
    func animation(from identifier: String) -> ObjectAnimation? {
        guard let index = animationIndex(from: identifier) else { return nil }
        return animations[index]
    }
    
    private func animationIndex(from identifier: String) -> Int? {
        guard let index = animations.firstIndex(where: { $0.identifier == identifier }) else {
            return nil
        }
        return index
    }
}
