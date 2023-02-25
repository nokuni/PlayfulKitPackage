//
//  PKTypewriterNode.swift
//  
//
//  Created by Maertens Yann-Christophe on 15/02/23.
//

import SpriteKit
import Utility_Toolbox

/// A writing text node.
public class PKTypewriterNode: SKLabelNode {
    
    public init(container: SKNode,
                parameter: TextManager.Paramater,
                timeInterval: TimeInterval = 0.05) {
        self.container = container
        self.parameter = parameter
        self.timeInterval = timeInterval
        super.init()
        setupWriting()
        write()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let textManager = TextManager()
    
    public var container: SKNode?
    public var parameter: TextManager.Paramater
    public var timeInterval: TimeInterval
    
    private var currentCharacterIndex: Int = 0
    private var timer: Timer?
    
    // MARK: - PUBLIC
    
    /// Stop the writing text.
    public func stop() { timer?.invalidate() }
    
    /// Check if the text has finished writing.
    public func hasFinished() -> Bool {
        currentCharacterIndex == parameter.content.count
    }
    
    // MARK: - PRIVATE
    private func setupWriting() {
        guard let container = container else { return }
        if let attributedText = textManager.attributedText(parameter: parameter) {
            self.attributedText = attributedText
        }
        lineBreakMode = NSLineBreakMode.byWordWrapping
        numberOfLines = 0
        preferredMaxLayoutWidth = container.frame.width - (parameter.padding * 2)
        horizontalAlignmentMode = .left
        verticalAlignmentMode = .top
        position = container.cornerPosition(corner: .topLeft, node: self, padding: parameter.padding, hasAlignment: parameter.hasAlignment)
    }
    
    private var isWriting: Bool {
        currentCharacterIndex < parameter.content.count
    }
    
    private func updateText() {
        switch true {
        case isWriting:
            currentCharacterIndex += 1
            let currentText = String(parameter.content.prefix(currentCharacterIndex))
            var newParameter = parameter
            newParameter.content = currentText
            attributedText = textManager.attributedText(parameter: newParameter)
        default:
            stop()
        }
    }
    
    private func write() {
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.updateText()
        }
        timer?.fire()
    }
}
