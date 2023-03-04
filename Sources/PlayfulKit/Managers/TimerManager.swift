//
//  TimerManager.swift
//  PlayfulKit
//
//  Created by Maertens Yann-Christophe on 11/08/22.
//

import SpriteKit

final public class TimerManager: SKNode {
    
    public var staticCountdown: Int
    public var onGoingCountdown: Int
    
    public init(timeInterval: TimeInterval,
                action: (() -> Void)?,
                staticCountdown: Int,
                onGoingCountdown: Int,
                countingAction: (() -> Void)?,
                resetAction: (() -> Void)?) {
        self.staticCountdown = staticCountdown
        self.onGoingCountdown = onGoingCountdown
        super.init()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func start(timeInterval: TimeInterval,
                      action: (() -> Void)?,
                      countingAction: (() -> Void)?,
                      resetAction: (() -> Void)?) {
        let sequenceAnimation = SKAction.sequence([
            SKAction.wait(forDuration: timeInterval),
            SKAction.run {
                action?()
                self.countdown(countingAction: countingAction, resetAction: resetAction)
            }
        ])
        let timer = SKAction.repeatForever(sequenceAnimation)
        self.run(timer)
    }
    
    public func countdown(countingAction: (() -> Void)?, resetAction: (() -> Void)?) {
        switch true {
        case onGoingCountdown > 0:
            onGoingCountdown -= 1
            countingAction?()
        default:
            resetAction?()
            onGoingCountdown = staticCountdown
        }
    }
}
