//
//  PKObjectNode.swift
//  
//
//  Created by Maertens Yann-Christophe on 19/02/23.
//

import SpriteKit

public class PKObjectNode: SKSpriteNode {
    public var logic = LogicBody()
    public var coordinate: Coordinate?
    
    private var animations: [ObjectAnimation] = [
        ObjectAnimation(state: .idle),
        ObjectAnimation(state: .walk),
        ObjectAnimation(state: .run),
        ObjectAnimation(state: .hit),
        ObjectAnimation(state: .attack),
        ObjectAnimation(state: .jump),
        ObjectAnimation(state: .death),
    ]
    
    // MARK: - ANIMATIONS
    
    public func addFrames(_ frames: [String], on state: ObjectAnimation.State) {
        if let index = animationIndex(from: state) {
            animations[index].frames = frames
        }
    }
    
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
    
    public func destroy(isAnimated: Bool,
                        filteringMode: SKTextureFilteringMode = .linear,
                        timeInterval: TimeInterval = 0.05) {
        guard isAnimated else { return removeFromParent() }
        let sequence = SKAction.sequence([
            animatedAction(with: .death,
                           filteringMode: filteringMode,
                           timeInterval: timeInterval),
            SKAction.removeFromParent()
        ])
        run(sequence)
    }
    
    public func hitAndDestroy(filteringMode: SKTextureFilteringMode = .linear,
                              hitTimeInterval: TimeInterval = 0.05,
                              deathTimeInterval: TimeInterval = 0.05) {
        let sequence = SKAction.sequence([
            animatedAction(with: .hit,
                           filteringMode: filteringMode,
                           timeInterval: hitTimeInterval),
            animatedAction(with: .death,
                           filteringMode: filteringMode,
                           timeInterval: deathTimeInterval),
            SKAction.removeFromParent()
        ])
        run(sequence)
    }
}
