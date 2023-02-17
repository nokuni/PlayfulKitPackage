//
//  PKScribeNode.swift
//  
//
//  Created by Maertens Yann-Christophe on 15/02/23.
//

import SpriteKit

public class PKScribeNode: SKLabelNode {
    
    public init(parameter: PKText.Paramater,
                timeInterval: TimeInterval = 0.05) {
        self.parameter = parameter
        self.timeInterval = timeInterval
        super.init()
        setupScribe()
        write()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let pkText = PKText()
    
    public var parameter: PKText.Paramater
    public var timeInterval: TimeInterval
    private var currentCharacterIndex: Int = 0
    private var timer: Timer?
    
    // MARK: - PUBLIC
    
    // Stop the writing text.
    public func stop() { timer?.invalidate() }
    
    // Check if the text has finished writing.
    public func hasFinished() -> Bool {
        currentCharacterIndex == parameter.content.count
    }
    
    // MARK: - PRIVATE
    private func setupScribe() {
        guard let parent = parent else { return }
        if let attributedText = pkText.attributedText(parameter: parameter) {
            self.attributedText = attributedText
        }
        lineBreakMode = NSLineBreakMode.byWordWrapping
        numberOfLines = 0
        preferredMaxLayoutWidth = parent.frame.width - (parameter.padding * 2)
        horizontalAlignmentMode = .left
        verticalAlignmentMode = .top
        position = parent.corner(corner: .topLeft, node: self, padding: parameter.padding, hasAlignment: true)
    }
    private func updateText() {
        if currentCharacterIndex < parameter.content.count {
            currentCharacterIndex += 1
            let currentText = String(parameter.content.prefix(currentCharacterIndex))
            parameter.content = currentText
            attributedText = pkText.attributedText(parameter: parameter)
            print(parameter.content)
            print(attributedText?.string)
        }
    }
    private func write() {
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            print("Text Updated")
            self.updateText()
        }
        timer?.fire()
    }
}
