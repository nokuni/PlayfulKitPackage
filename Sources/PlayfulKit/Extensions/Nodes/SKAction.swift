//
//  SKAction.swift
//  PlayfulKit
//
//  Created by Yann Christophe MAERTENS on 08/02/2023.
//

import SpriteKit

public extension SKAction {
    
    static var empty: SKAction {
        let action = SKAction.run { }
        return action
    }
    
    static func setTexture(_ texture: SKTexture,
                           with filteringMode: SKTextureFilteringMode = .linear) -> SKAction {
        let sequence = SKAction.sequence([
            SKAction.setTexture(texture),
            SKAction.run { texture.filteringMode = filteringMode }
        ])
        return sequence
    }
    
    static func shake(duration: Double = 0.5,
                      amplitudeX: CGFloat = 3,
                      amplitudeY: CGFloat = 3) -> SKAction {
        let numberOfShakes = duration / 0.015 / 2.0
        var actionsArray:[SKAction] = []
        for _ in 1...Int(numberOfShakes) {
            let dx = CGFloat(arc4random_uniform(UInt32(amplitudeX))) - CGFloat(amplitudeX / 2)
            let dy = CGFloat(arc4random_uniform(UInt32(amplitudeY))) - CGFloat(amplitudeY / 2)
            let forward = SKAction.moveBy(x: dx, y:dy, duration: 0.015)
            let reverse = forward.reversed()
            actionsArray.append(forward)
            actionsArray.append(reverse)
        }
        return SKAction.sequence(actionsArray)
    }
    
    static func animate(with objectAnimation: ObjectAnimation) -> SKAction {
        let textures = objectAnimation.frames.map { SKTexture(imageNamed: $0) }
        textures.forEach { $0.filteringMode = objectAnimation.filteringMode }
        let animation = SKAction.animate(with: textures, timePerFrame: objectAnimation.timeInterval)
        return animation
    }
    
    /// Fade out and in a node.
    static func fadeOutAndIn(fadeOutDuration: TimeInterval = 0.5,
                             fadeInDuration: TimeInterval = 0.5,
                             repeating repeatCount: Int = 1,
                             isRepeatingForever: Bool = false) -> SKAction {
        let sequence = SKAction.sequence([
            SKAction.fadeOut(withDuration: fadeOutDuration),
            SKAction.fadeIn(withDuration: fadeInDuration)
        ])
        return isRepeatingForever ?
        SKAction.repeatForever(sequence) :
        SKAction.repeat(sequence, count: repeatCount)
    }
    
    /// Scale up and down a node.
    static func scaleUpAndDown(from firstScale: CGFloat,
                               with scaleUpDuration: TimeInterval = 0.5,
                               to secondScale: CGFloat,
                               with scaleDownDuration: TimeInterval = 0.5,
                               during duration: TimeInterval,
                               repeating repeatCount: Int = 1,
                               isRepeatingForever: Bool = false) -> SKAction {
        let sequence = SKAction.sequence([
            SKAction.scale(to: firstScale, duration: scaleUpDuration),
            SKAction.scale(to: secondScale, duration: scaleDownDuration),
        ])
        return isRepeatingForever ?
        SKAction.repeatForever(sequence) :
        SKAction.repeat(sequence, count: repeatCount)
    }
    
    /// Move forth and back a node.
    static func moveForthAndBack(startPoint: CGPoint,
                                 endPoint: CGPoint,
                                 startDuration: TimeInterval = 0.5,
                                 endDuration: TimeInterval = 0.5) -> SKAction {
        let move = SKAction.sequence([
            SKAction.move(to: endPoint, duration: startDuration),
            SKAction.move(to: startPoint, duration: endDuration)
        ])
        return move
    }
}
