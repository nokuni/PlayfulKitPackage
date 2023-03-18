//
//  PKTimerNode.swift
//  PlayfulKit
//
//  Created by Maertens Yann-Christophe on 11/08/22.
//

import SpriteKit

final public class PKTimerNode: SKNode {
    
    public init(label: SKLabelNode? = nil,
                configuration: TimerConfiguration = TimerConfiguration()) {
        self.label = label
        self.configuration = configuration
        super.init()
        initialCountdown = configuration.countdown
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public struct TimerConfiguration {
        public init(countdown: Double = 10,
                    counter: Double = 1,
                    timeInterval: TimeInterval = 1,
                    actionOnLaunch: (() -> Void)? = nil,
                    actionOnGoing: (() -> Void)? = nil,
                    actionOnEnd: (() -> Void)? = nil,
                    isRepeating: Bool = false) {
            self.countdown = countdown
            self.counter = counter
            self.timeInterval = timeInterval
            self.actionOnLaunch = actionOnLaunch
            self.actionOnGoing = actionOnGoing
            self.actionOnEnd = actionOnEnd
            self.isRepeating = isRepeating
        }
        
        public var countdown: Double
        public var counter: Double
        public var timeInterval: TimeInterval
        public var actionOnLaunch: (() -> Void)?
        public var actionOnGoing: (() -> Void)?
        public var actionOnEnd: (() -> Void)?
        public var isRepeating: Bool
    }
    
    public var label: SKLabelNode?
    public var configuration = TimerConfiguration()
    
    private var initialCountdown: Double = 0
    
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
    /// Reset the timer countdown and stop it.
    public func resetAndStop() {
        configuration.countdown = initialCountdown
        cancel()
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
        label?.text = timerText
    }
    private func countdown() {
        switch true {
        case configuration.countdown > 0:
            configuration.countdown -= configuration.counter
            configuration.actionOnGoing?()
        case configuration.isRepeating:
            configuration.actionOnEnd?()
            reset()
        default:
            configuration.actionOnEnd?()
            cancel()
        }
    }
}
