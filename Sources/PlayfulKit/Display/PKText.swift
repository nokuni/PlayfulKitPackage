//
//  PKText.swift
//  PlayfulKit
//
//  Created by Maertens Yann-Christophe on 11/08/22.
//

import SpriteKit

public class PKText {
    
    public init() {
        timer?.invalidate()
    }
    
    public static var shared = PKText()
    
    public var timer: Timer?
    
    public struct TextImage {
        
        public init(image: String, size: CGSize, yPosition: CGFloat, indicator: String) {
            self.image = image
            self.size = size
            self.yPosition = yPosition
            self.indicator = indicator
        }
        
        var image: String
        var size: CGSize
        var yPosition: CGFloat
        var indicator: String
    }
    
    public struct AnimatedText {
        
        public init(text: String, images: [PKText.TextImage], letterSpacing: CGFloat, lineSpacing: CGFloat, lineCount: Int, fontName: String, fontColor: UIColor, fontSize: CGFloat, zPosition: CGFloat, position: CGPoint) {
            self.text = text
            self.images = images
            self.letterSpacing = letterSpacing
            self.lineSpacing = lineSpacing
            self.lineCount = lineCount
            self.fontName = fontName
            self.fontColor = fontColor
            self.fontSize = fontSize
            self.zPosition = zPosition
            self.position = position
        }
        
        var text: String
        var images: [TextImage]
        let letterSpacing: CGFloat
        let lineSpacing: CGFloat
        let lineCount: Int
        let fontName: String
        let fontColor: UIColor
        let fontSize: CGFloat
        let zPosition: CGFloat
        let position: CGPoint
    }
    
    public func getAttributedText(text: String, fontName: String, fontSize: CGFloat, textColor: UIColor, strokeColor: UIColor, strokeWidth: CGFloat) -> NSAttributedString {
        let strokeText: NSMutableAttributedString = NSMutableAttributedString(string: "MyDefaultText")
        
        let myFont: UIFont = UIFont(name: fontName, size: fontSize)!

        strokeText.mutableString.setString(text)
        strokeText.addAttribute(.font, value: myFont, range: NSMakeRange(0, strokeText.length))
        strokeText.addAttribute(.foregroundColor, value: textColor, range: NSMakeRange(0, strokeText.length))
        strokeText.addAttribute(.strokeColor, value: strokeColor, range: NSMakeRange(0, strokeText.length))
        strokeText.addAttribute(.strokeWidth, value: strokeWidth, range: NSMakeRange(0, strokeText.length))
        
        return strokeText
    }
    
    public func isAllTextShown(children: [SKNode], _ text: String) -> Bool {
        //let count = Array(sentences.joined()).count)
        return children.getCount(named: "Character") == (text.count + 1)
    }
    
    public func numberAnimationUpdate(update: (() -> Void)?, node: SKNode, interval: CGFloat, value: Int, goal: Int, actionAfter: (() -> Void)?) {
        let group = DispatchGroup()
        let animation = SKAction.sequence([
            SKAction.run {
                if value == goal { node.removeAllActions() } else { update?() }
            },
            SKAction.wait(forDuration: interval)
        ])
        group.enter()
        node.run(SKAction.repeat(animation, count: goal)) { group.leave() }
        group.notify(queue: .main) { actionAfter?() }
    }
    
    public func addTextCharacter(_ letter: Character, on node: SKNode, fontName: String, fontColor: UIColor, fontSize: CGFloat, zPosition: CGFloat, position: CGPoint) {
        let character = SKLabelNode(text: String(letter))
        character.name = "Character"
        character.fontSize = UIScreen.main.bounds.width * fontSize
        character.fontName = fontName
        character.fontColor = fontColor
        character.zPosition = zPosition
        character.position = position
        node.addChild(character)
    }
    
    public func addSymbol(_ image: String, on node: SKNode, size: CGSize, zPosition: CGFloat, position: CGPoint, yPosition: CGFloat) {
        let symbol = SKSpriteNode(imageNamed: image)
        symbol.name = "Text Symbol"
        symbol.texture?.filteringMode = .nearest
        symbol.size = size //CGSize(width: UIScreen.main.bounds.width * size, height: UIScreen.main.bounds.width * size)
        symbol.zPosition = zPosition
        symbol.position = CGPoint(x: position.x, y: position.y + yPosition)
        node.addChild(symbol)
    }
    
    public func writeText(_ animatedText: AnimatedText, node: SKNode, timeInterval: CGFloat, actionAfter: (() -> Void)?) {
        
        let multilinedText = getMultilinedText(animatedText.text, lineCount: animatedText.lineCount)
        
        // Index of text lines
        var lineIndex = 0
        
        // Index of characters in a text line
        var characterOffset = 0
        
        var imageIndex = 0
        
        // Starting position of the first character at the first line
        var tempPosition = animatedText.position
        
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { timer in
            
            if lineIndex == multilinedText.count {
                // Stop the text animation when all the text is displayed
                timer.invalidate()
                actionAfter?()
            } else if characterOffset >= multilinedText[lineIndex].count {
                // Go to the next line
                lineIndex += 1
                tempPosition = CGPoint(x: animatedText.position.x, y: tempPosition.y)
                tempPosition.y -= (UIScreen.main.bounds.height * animatedText.lineSpacing)
                characterOffset = 0
            }
            
            if lineIndex < multilinedText.count {
                
                let index = multilinedText[lineIndex].index(multilinedText[lineIndex].startIndex, offsetBy: characterOffset)
                
                if multilinedText[lineIndex][index] == "@" && !animatedText.images.isEmpty {
                    self.addSymbol(animatedText.images[imageIndex].image, on: node, size: animatedText.images[imageIndex].size, zPosition: animatedText.zPosition, position: tempPosition, yPosition: animatedText.images[imageIndex].yPosition)
                    imageIndex += 1
                } else {
                    // Add the letter
                    self.addTextCharacter(multilinedText[lineIndex][index], on: node, fontName: animatedText.fontName, fontColor: animatedText.fontColor, fontSize: animatedText.fontSize, zPosition: animatedText.zPosition, position: tempPosition)
                }
                
                // Move forward in the strings
                characterOffset += 1
                tempPosition.x += (UIScreen.main.bounds.width * animatedText.letterSpacing)
            }
        }
        
        timer?.fire()
    }
    
    public func removeText(from parent: SKNode) {
        timer?.invalidate()
        parent.enumerateChildNodes(withName: "Character") { node, _ in
            node.removeFromParent()
        }
    }
    
    public func getMultilinedText(_ text: String, lineCount: Int) -> [String] {
        var dialog = ""
        let separatedString = text.components(separatedBy: " ")
        var lineCountTemp = lineCount
        for string in separatedString {
            let stringToAdd = string + " "
            let canAddString = (dialog.count + stringToAdd.count) >= lineCountTemp
            if canAddString {
                dialog.append("\n")
                lineCountTemp += lineCount
            }
            dialog.append(stringToAdd)
        }
        return dialog.components(separatedBy: "\n")
    }
}
