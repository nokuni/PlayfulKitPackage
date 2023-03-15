//
//  PKTimerNode.swift
//  PlayfulKit
//
//  Created by Maertens Yann-Christophe on 11/08/22.
//

import SpriteKit

final public class PKTimerNode: SKNode {
    
    public init(label: SKLabelNode) {
        self.label = label
        super.init()
        initialCountdown = configuration.countdown
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public struct TimerConfiguration {
        public init(countdown: Int = 10,
                    timeInterval: TimeInterval = 1,
                    actionOnLaunch: (() -> Void)? = nil,
                    actionOnGoing: (() -> Void)? = nil,
                    actionOnEnd: (() -> Void)? = nil) {
            self.countdown = countdown
            self.timeInterval = timeInterval
            self.actionOnLaunch = actionOnLaunch
            self.actionOnGoing = actionOnGoing
            self.actionOnEnd = actionOnEnd
        }
        
        public var countdown: Int
        public var timeInterval: TimeInterval
        public var actionOnLaunch: (() -> Void)?
        public var actionOnGoing: (() -> Void)?
        public var actionOnEnd: (() -> Void)?
    }
    
    public var label: SKLabelNode
    public var configuration = TimerConfiguration()
    
    private var initialCountdown: Int = 0
    
    // MARK: - PUBLIC
    
    /// Start the timer.
    public func start() {
        let timer = SKAction.repeatForever(updateAction)
        run(timer)
    }
    /// Cancel the timer.
    public func cancel() {
        removeAllActions()
    }
    /// Reset the timer countdown.
    public func reset() {
        configuration.countdown = initialCountdown
    }
    
    // MARK: - PRIVATE
    
    private var updateAction: SKAction {
        let sequence = SKAction.sequence([
            SKAction.wait(forDuration: configuration.timeInterval),
            SKAction.run {
                self.countdown()
                self.updateLabel()
            }
        ])
        return sequence
    }
    private var timerText: String {
        "\(configuration.countdown)"
    }
    private func updateLabel() {
        label.text = timerText
    }
    private func countdown() {
        switch true {
        case configuration.countdown > 0:
            configuration.countdown -= 1
            configuration.actionOnGoing?()
        default:
            configuration.actionOnEnd?()
            reset()
        }
    }
}
