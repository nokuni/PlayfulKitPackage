//
//  PKTypewriterNode.swift
//  
//
//  Created by Maertens Yann-Christophe on 15/02/23.
//

import SpriteKit
import UtilityToolbox

/// A writing text node.
public class PKTypewriterNode: SKLabelNode {
    
    public init(container: SKNode,
                parameter: TextManager.Paramater,
                timeInterval: TimeInterval = 0.05,
                startCompletion: (() -> Void)? = nil,
                whileCompletion: (() -> Void)? = nil,
                endCompletion: (() -> Void)? = nil) {
        self.container = container
        self.parameter = parameter
        self.timeInterval = timeInterval
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let textManager = TextManager()
    
    public var container: SKNode?
    public var parameter: TextManager.Paramater
    public var timeInterval: TimeInterval
    public var startCompletion: (() -> Void)?
    public var whileCompletion: (() -> Void)?
    public var endCompletion: (() -> Void)?
    
    private var currentCharacterIndex: Int = 0
    private var currentImageIndex: Int = 0
    private var timer: Timer?
    
    // MARK: - PUBLIC
    
    /// Stop the writing text.
    public func stop() {
        endCompletion?()
        timer?.invalidate()
    }

    public func start() {
        startCompletion?()
        timer?.fire()
    }
    
    /// Check if the text has finished writing.
    public func hasFinished() -> Bool {
        currentCharacterIndex == parameter.content.count
    }
    
    /// Display all the text and stop the writing.
    public func displayAllText() {
        stop()
        attributedText = textManager.attributedText(parameter: parameter)
        currentCharacterIndex = parameter.content.count
    }
    
    // MARK: - PRIVATE
    private func setup() {
        guard let container = container else { return }
        if let attributedText = textManager.attributedText(parameter: parameter) {
            self.attributedText = attributedText
        }
        lineBreakMode = NSLineBreakMode.byWordWrapping
        numberOfLines = 0
        preferredMaxLayoutWidth = container.frame.width - (parameter.padding.leading + parameter.padding.trailing)
        horizontalAlignmentMode = parameter.horizontalAlignmentMode
        verticalAlignmentMode = parameter.verticalAlignmentMode
        zPosition = container.zPosition + 1
        position = container.cornerPosition(corner: .topLeft, padding: parameter.padding)
        
        configureTimer()
    }
    
    private var isWriting: Bool {
        currentCharacterIndex < parameter.content.count
    }
    
    private func write() {
        switch true {
        case isWriting:
            updateText()
        default:
            stop()
        }
    }

    private func updateText() {
        currentCharacterIndex += 1
        let currentText = String(parameter.content.prefix(currentCharacterIndex))
        var newParameter = parameter
        newParameter.content = currentText
        attributedText = textManager.attributedText(parameter: newParameter)
    }
    
    private func configureTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] timer in
            self?.whileCompletion?()
            self?.write()
        }
    }
}
