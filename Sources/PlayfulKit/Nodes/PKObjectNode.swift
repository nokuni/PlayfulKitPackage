//
//  PKObjectNode.swift
//  
//
//  Created by Maertens Yann-Christophe on 19/02/23.
//

import SpriteKit

/// An object node.
public class PKObjectNode: SKSpriteNode {
    //public var logic = LogicBody(health: 1, damage: 0, isDestructible: false)
    public var coordinate = Coordinate.zero
    
    private var animations: [ObjectAnimation] = []
    
    // MARK: - ANIMATIONS
    
    public func addAnimation(_ animation: ObjectAnimation) {
        animations.append(animation)
    }
    
    public func addMultipleAnimation(_ animations: [ObjectAnimation]) {
        self.animations.append(contentsOf: animations)
    }
    
    /// Get the action animation from an animation state.
    public func animatedAction(with identifier: String,
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
    
    private func animationIndex(from identifier: String) -> Int? {
        guard let index = animations.firstIndex(where: { $0.identifier == identifier }) else {
            return nil
        }
        return index
    }
    
    private func animation(from identifier: String) -> ObjectAnimation? {
        guard let index = animationIndex(from: identifier) else { return nil }
        return animations[index]
    }
    
    // MARK: - LOGIC
    
    /// Remove the object with or without  an animation.
    /*public func destroy(isAnimated: Bool = false,
                        identifier: String = "",
                        filteringMode: SKTextureFilteringMode = .linear,
                        timeInterval: TimeInterval = 0.05) {
        guard isAnimated else { return removeFromParent() }
        guard animation(from: identifier) != nil else { return }
        let sequence = SKAction.sequence([
            animatedAction(with: identifier,
                           filteringMode: filteringMode,
                           timeInterval: timeInterval),
            SKAction.removeFromParent()
        ])
        run(sequence)
    }
    
    /// Remove the object with an animation after another animation.
    public func hitAndDestroy(identifier: String,
                              filteringMode: SKTextureFilteringMode = .linear,
                              hitTimeInterval: TimeInterval = 0.05,
                              deathTimeInterval: TimeInterval = 0.05) {
        guard animation(from: identifier) != nil else { return }
        guard animation(from: identifier) != nil else { return }
        let sequence = SKAction.sequence([
            animatedAction(with: .hit,
                           filteringMode: filteringMode,
                           timeInterval: hitTimeInterval),
            animatedAction(with: .deletion,
                           filteringMode: filteringMode,
                           timeInterval: deathTimeInterval),
            SKAction.removeFromParent()
        ])
        run(sequence)
    }*/
}
