//
//  PKObjectNode.swift
//  
//
//  Created by Maertens Yann-Christophe on 19/02/23.
//

import SpriteKit

/// An object node.
public class PKObjectNode: SKSpriteNode {
    public var logic = LogicBody()
    public var coordinate = Coordinate.zero
    
    private var animations: [ObjectAnimation] = [
        ObjectAnimation(state: .idle),
        ObjectAnimation(state: .walk),
        ObjectAnimation(state: .run),
        ObjectAnimation(state: .hit),
        ObjectAnimation(state: .attack),
        ObjectAnimation(state: .jump),
        ObjectAnimation(state: .deletion),
    ]
    
    // MARK: - ANIMATIONS

    /// Add frames on an animation state.
    public func addFrames(_ frames: [String], on state: ObjectAnimation.State) {
        if let index = animationIndex(from: state) {
            animations[index].frames = frames
        }
    }

    /// Get the action animation from an animation state.
    public func animatedAction(with state: ObjectAnimation.State,
                               filteringMode: SKTextureFilteringMode = .linear,
                               timeInterval: TimeInterval = 0.05,
                               repeatCount: Int = 0,
                               isRepeatingForever: Bool = false) -> SKAction {
        guard let animation = animation(from: state) else { return SKAction() }
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

    private func animationIndex(from state: ObjectAnimation.State) -> Int? {
        guard let index = animations.firstIndex(where: { $0.state == state }) else {
            return nil
        }
        return index
    }
    
    private func animation(from state: ObjectAnimation.State) -> ObjectAnimation? {
        guard let index = animationIndex(from: state) else { return nil }
        return animations[index]
    }
    
    // MARK: - LOGIC

    /// Remove the object with or without  a deletion animation.
    public func destroy(isAnimated: Bool,
                        filteringMode: SKTextureFilteringMode = .linear,
                        timeInterval: TimeInterval = 0.05) {
        guard isAnimated else { return removeFromParent() }
        guard animation(from: .deletion) != nil else { return }
        let sequence = SKAction.sequence([
            animatedAction(with: .deletion,
                           filteringMode: filteringMode,
                           timeInterval: timeInterval),
            SKAction.removeFromParent()
        ])
        run(sequence)
    }

    /// Remove the object with a deletion animation after an hit animation.
    public func hitAndDestroy(filteringMode: SKTextureFilteringMode = .linear,
                              hitTimeInterval: TimeInterval = 0.05,
                              deathTimeInterval: TimeInterval = 0.05) {
        guard animation(from: .hit) != nil else { return }
        guard animation(from: .deletion) != nil else { return }
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
    }
}
