//
//  PKAnimation.swift
//  PlayfulKit
//
//  Created by Maertens Yann-Christophe on 11/08/22.
//

import SpriteKit
import SwiftUI

public class PKAnimation {
    
    public init() { }
    
    public static let shared = PKAnimation()
    
    public func blinkScreen(scene: SKNode, blinkingNode: SKNode, timeInterval: TimeInterval, actionAfter: (() -> Void)?) {
        let group = DispatchGroup()
        let animationSequence = SKAction.sequence([
            SKAction.fadeOut(withDuration: timeInterval),
            SKAction.fadeIn(withDuration: timeInterval)
        ])
        scene.addChild(blinkingNode)
        group.enter()
        blinkingNode.run(animationSequence) { group.leave() }
        group.notify(queue: .main) {
            blinkingNode.removeFromParent()
            actionAfter?()
        }
    }
    
    public func shake(duration: Double, amplitudeX: CGFloat = 3, amplitudeY: CGFloat = 3) -> SKAction {
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
    
    public func vibrate(amplitude: VibrationAmplitude, camera: (node: SKCameraNode?, isCameraVibrating: Bool), duration: Double) {
        let shakingAnimation = shake(duration: duration, amplitudeX: amplitude.rawValue, amplitudeY: amplitude.rawValue)
        if camera.isCameraVibrating { camera.node!.run(shakingAnimation) }
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        amplitude.haptic
    }
    
    public func pulse(from firstScale: CGFloat, to secondScale: CGFloat, during duration: TimeInterval) -> SKAction {
        let pulseAnimation = SKAction.sequence([
            SKAction.fadeIn(withDuration: duration),
            SKAction.scale(to: firstScale, duration: duration),
            SKAction.fadeOut(withDuration: duration),
            SKAction.scale(to: secondScale, duration: duration)
        ])
        return pulseAnimation
    }
    
    public func scalePress(from: CGFloat, to: CGFloat, during duration: TimeInterval, repeating repeatCount: Int) -> SKAction {
        let sequence = SKAction.sequence([
            SKAction.scale(to: from, duration: duration),
            SKAction.scale(to: to, duration: duration),
        ])
        return SKAction.repeat(sequence, count: repeatCount)
    }
    
    public func animate(with images: [String], filteringMode: SKTextureFilteringMode = .linear, timePerFrame: TimeInterval = 0.5) -> SKAction {
        let textures = images.map { SKTexture(imageNamed: $0) }
        textures.forEach { $0.filteringMode = filteringMode }
        let animation = SKAction.animate(with: textures, timePerFrame: timePerFrame)
        return animation
    }
    
    public func start(actionBeforeAnimation: (() -> Void)?, with animation: SKAction, on node: SKNode, and actionAfterAnimation: (() -> Void)?) {
        let group = DispatchGroup()
        group.enter()
        actionBeforeAnimation?()
        node.run(animation) { group.leave() }
        group.notify(queue: .main) { actionAfterAnimation?() }
    }
}
