//
//  PKObjectNode.swift
//  
//
//  Created by Maertens Yann-Christophe on 19/02/23.
//

import SpriteKit

public class PKObjectNode: SKSpriteNode {
    public var logic = PKLogicBody()
    public var coordinate: PKCoordinate?
    
    private var animations: [PKObjectAnimation] = [
        PKObjectAnimation(state: .idle),
        PKObjectAnimation(state: .walk),
        PKObjectAnimation(state: .run),
        PKObjectAnimation(state: .hit),
        PKObjectAnimation(state: .attack),
        PKObjectAnimation(state: .jump),
        PKObjectAnimation(state: .death),
    ]
    
    // MARK: - ANIMATIONS
    
    public func addFrames(_ frames: [String], on state: PKObjectAnimation.State) {
        if let index = animationIndex(from: state) {
            animations[index].frames = frames
        }
    }
    
    public func animate(with state: PKObjectAnimation.State,
                        filteringMode: SKTextureFilteringMode = .linear,
                        timeInterval: TimeInterval = 0.05,
                        repeatCount: Int = 0,
                        isRepeatingForever: Bool = false) {
        guard let animation = animation(from: state) else { return }
        guard !animation.frames.isEmpty else { return }
        let action = SKAction.animate(with: animation.frames,
                                      filteringMode: filteringMode,
                                      timePerFrame: timeInterval)
        switch true {
        case isRepeatingForever:
            run(SKAction.repeatForever(action))
        case repeatCount > 0:
            run(SKAction.repeat(action, count: repeatCount))
        default:
            run(action)
        }
    }
    
    private func animationIndex(from state: PKObjectAnimation.State) -> Int? {
        guard let index = animations.firstIndex(where: { $0.state == state }) else {
            return nil
        }
        return index
    }
    
    private func animation(from state: PKObjectAnimation.State) -> PKObjectAnimation? {
        guard let index = animationIndex(from: state) else { return nil }
        return animations[index]
    }
    
    // MARK: - LOGIC
    
    public func destroy(isAnimated: Bool,
                        filteringMode: SKTextureFilteringMode = .linear,
                        timeInterval: TimeInterval = 0.05) {
        guard isAnimated else { return removeFromParent() }
        let sequence = SKAction.sequence([
            SKAction.run {
                self.animate(with: .death,
                             filteringMode: filteringMode,
                             timeInterval: timeInterval)
            },
            SKAction.wait(forDuration: timeInterval),
            SKAction.removeFromParent()
        ])
        run(sequence)
    }
}
