//
//  SlotMachineNode.swift
//  PlayfulKit
//
//  Created by Maertens Yann-Christophe on 18/08/22.
//

import SpriteKit
import SwiftUI

public class PKSlotMachineNode: SKNode {
    
    public enum SlotStopCategory {
        case leading
        case trailing
        case random
    }
    
    private struct SlotLine {
        var node = SKShapeNode()
        var symbols: [SlotSymbol]
        var animationSpeed: CGFloat
        var isRolling: Bool = true
    }
    private struct SlotSymbol {
        var overlayNode = SKShapeNode()
        var image: String
    }
    
    private var slotSymbols = [SlotSymbol]()
    private var slotLines = [SlotLine]()
    private var visibleImages = [String]()
    private var isSlotsAnimationFinished = false
    private var isSlotMachineRollingOn = false
    private var lineStoppedIndices = [Int]()
    private var pulledSymbols = [String]()
    
    public var slotLineToStop: Int = 0
    public var size: CGSize
    public var rollingSpeed: CGFloat = 0.1
    public var numberOfSlotColumns: Int
    public var slotImages: [String]
    public var slotStopCategory: SlotStopCategory = .leading
    public var imageSize: CGSize = CGSize(width: UIScreen.main.bounds.height * 0.1, height: UIScreen.main.bounds.height * 0.1)
    public var isGameOver: Bool = false
    public var isGameWon: Bool = false
    
    public init(size: CGSize, numberOfSlotColumns: Int, slotImages: [String], rollingSpeed: CGFloat, slotStopCategory: SlotStopCategory, imageSize: CGSize) {
        self.size = size
        self.numberOfSlotColumns = numberOfSlotColumns
        self.slotImages = slotImages
        self.rollingSpeed = rollingSpeed
        self.imageSize = imageSize
        super.init()
        
        setUpSlotMachine(size, slotStopCategory: slotStopCategory)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PUBLIC
    
    public func resetSlotMachine() {
        removeAllChildren()
        slotLineToStop = 0
        isGameOver = false
        visibleImages.removeAll()
        pulledSymbols.removeAll()
        lineStoppedIndices.removeAll()
        var randomImage: String { slotImages.randomElement()! }
        slotSymbols = Array(repeating: SlotSymbol(image: randomImage), count: 3)
        slotLines = Array(repeating: SlotLine(symbols: [], animationSpeed: rollingSpeed), count: numberOfSlotColumns)
        createAllSlots()
    }
    
    // Start the machine slot
    public func startMachineSlot() {
        resetSlotMachine()
        rerollAllSlots()
    }
    // Stop slot lines 1 by 1 depending on the stop category
    public func stopSlotLine() {
        switch slotStopCategory {
        case .leading:
            if slotLineToStop < numberOfSlotColumns {
                slotLines[slotLineToStop].isRolling = false
                lineStoppedIndices.append(slotLineToStop)
                if let slotElementNode = slotLines[slotLineToStop].node.children.getAll(named: "Slot Element")[1] as? SKSpriteNode {
                    pulledSymbols.append(slotElementNode.texture!.name!)
                }
                slotLineToStop += 1
                if slotLineToStop >= numberOfSlotColumns {
                    isGameOver = true
                    isGameWon = isMachineSlotWon()
                }
            }
        case .trailing:
            if slotLineToStop > 0 {
                let lastIndex = slotLineToStop - 1
                slotLines[lastIndex].isRolling = false
                lineStoppedIndices.append(slotLineToStop)
                slotLineToStop -= 1
            }
        case .random:
            if !lineStoppedIndices.contains(slotLineToStop) {
                slotLines[slotLineToStop].isRolling = false
                lineStoppedIndices.append(slotLineToStop)
                let missingSlotIndices = Array(0..<numberOfSlotColumns).filter { !lineStoppedIndices.contains($0) }
                if let missingSlotIndex = missingSlotIndices.randomElement() {
                    slotLineToStop = missingSlotIndex
                }
            }
        }
    }
    
    public func isMachineSlotWon() -> Bool {
        if Set(pulledSymbols).count == 1 {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - PRIVATE
    
    private func setUpSlotMachine(_ size: CGSize, slotStopCategory: SlotStopCategory) {
        self.scene?.size = size
        setUpStopSlotCategory(slotStopCategory)
        var randomImage: String { slotImages.randomElement()! }
        slotSymbols = Array(repeating: SlotSymbol(image: randomImage), count: 3)
        slotLines = Array(repeating: SlotLine(symbols: [], animationSpeed: rollingSpeed), count: numberOfSlotColumns)
        createAllSlots()
    }
    
    // Define the way on how to stop slot lines
    private func setUpStopSlotCategory(_ slotStopCategory: SlotStopCategory) {
        self.slotStopCategory = slotStopCategory
        switch slotStopCategory {
        case .leading:
            slotLineToStop = 0
        case .trailing:
            slotLineToStop = numberOfSlotColumns
        case .random:
            slotLineToStop = Int.random(in: 0..<numberOfSlotColumns)
        }
    }
    
    private func createOverlayNode(parent: SKShapeNode, position: CGPoint, index: Int) {
        var overlayZPosition: CGFloat = 0
        
        if index == 1 {
            overlayZPosition = 0
        } else {
            overlayZPosition = 2
        }
        
        let overlaySize = CGSize(width: parent.frame.size.width, height: parent.frame.size.height * (1/3))
        let overlayNode = SKShapeNode(rectOf: overlaySize)
        overlayNode.fillColor = index == 1 ? .white : UIColor(Color(red: 208/255, green: 165/255, blue: 65/255))
        overlayNode.strokeColor = index == 1 ? .black : UIColor(Color(red: 208/255, green: 165/255, blue: 65/255))
        overlayNode.lineWidth = index == 1 ? (UIDevice.isOnPad ? 20 : 7) : 1
        overlayNode.zPosition = overlayZPosition
        overlayNode.position = position
        parent.addChild(overlayNode)
    }
    private func createSymbolImage(parent: SKShapeNode, position: CGPoint, slotLineIndex: Int, index: Int) {
        
        let randomImage = slotImages.randomElement()!
        
        var selectedImage: String = randomImage
        
        if !visibleImages.isEmpty {
            if index == 1 {
                if visibleImages.count < numberOfSlotColumns {
                    visibleImages.append(randomImage)
                }
                selectedImage = visibleImages[slotLineIndex]
            }
        }
        
        if lineStoppedIndices.contains(slotLineIndex) {
            selectedImage = pulledSymbols[slotLineIndex]
        }
        
        let slotImageNode = SKSpriteNode(imageNamed: selectedImage)
        slotImageNode.name = "Slot Element \(index)"
        slotImageNode.texture?.filteringMode = .nearest
        slotImageNode.size = imageSize
        slotImageNode.setScale(1)
        slotImageNode.zPosition = 1
        slotImageNode.position = position
        parent.addChild(slotImageNode)
    }
    
    // Create a symbol on one part of the slot line
    private func createSlotSymbol(parent: SKShapeNode, position: CGPoint, slotLineIndex: Int, slotSymbolIndex: Int) {
        
        createOverlayNode(parent: parent, position: position, index: slotSymbolIndex)
        
        createSymbolImage(parent: parent, position: position, slotLineIndex: slotLineIndex, index: slotSymbolIndex)
    }
    
    private func createAllSlots() {
        //let slotSize = CGSize(width: CGSize.screen.width * (1/CGFloat(numberOfSlotColumns)), height: CGSize.screen.height)
        let slotSize = CGSize(width: size.width * (1/CGFloat(numberOfSlotColumns)), height: size.height)
        var cellPosition = CGPoint(x: UIScreen.main.bounds.minX + (slotSize.width / 2), y: slotSize.height / 2)
        //var cellPosition = CGPoint(x: frame.minX + (slotSize.width / 2), y: slotSize.height / 2)
        
        for slotLineIndex in slotLines.indices {
            
            slotLines[slotLineIndex].node = SKShapeNode(rectOf: slotSize)
            slotLines[slotLineIndex].node.name = "Slot Cell \(slotLineIndex)"
            slotLines[slotLineIndex].node.fillColor = slotLineIndex == 1 ? .white : UIColor(Color(red: 208/255, green: 165/255, blue: 65/255))
            slotLines[slotLineIndex].node.strokeColor = slotLineIndex == 1 ? .white : UIColor(Color(red: 208/255, green: 165/255, blue: 65/255))
            slotLines[slotLineIndex].node.position = cellPosition
            addChild(slotLines[slotLineIndex].node)
            cellPosition.x += slotSize.width
            
            var slotElementPosition = CGPoint(x: UIScreen.main.bounds.minX, y: slotLines[slotLineIndex].node.frame.size.height * (1/3))

            for slotSymbolIndex in slotSymbols.indices {
                createSlotSymbol(parent: slotLines[slotLineIndex].node, position: slotElementPosition, slotLineIndex: slotLineIndex, slotSymbolIndex: slotSymbolIndex)
                slotElementPosition.y -= (slotLines[slotLineIndex].node.frame.size.height * (1/3))
            }
        }
    }
    
    // Reroll the next symbols
    private func rerollAllSlots() {
        let slots = children.getAll(named: "Slot Cell")
        slots.forEach { $0.removeFromParent() }
        isSlotsAnimationFinished = true
        createAllSlots()
        moveAllSlotSymbols()
    }
    
    private func getRollingAnimation(slotCell: SKShapeNode, animationSpeed: CGFloat) -> SKAction {
        SKAction.sequence([
            SKAction.moveBy(x: 0, y: -slotCell.frame.size.height * (1/CGFloat(numberOfSlotColumns)), duration: animationSpeed),
            SKAction.run {
                self.isSlotsAnimationFinished = false
            }
        ])
    }
    
    // Move a single symbol down
    private func moveSingleSlotSymbol(slotCell: SKShapeNode, index: Int, animationSpeed: CGFloat) {
        let group = DispatchGroup()
        if let slotElement = slotCell.childNode(withName: "Slot Element \(index)") as? SKSpriteNode,
           let textureName = slotElement.texture?.name {
            if index == 0 {
                visibleImages.append(textureName)
            }
            let animation = getRollingAnimation(slotCell: slotCell, animationSpeed: animationSpeed)
            group.enter()
            slotElement.run(animation) {
                group.leave()
            }
            group.notify(queue: .main) {
                if !self.isSlotsAnimationFinished && animationSpeed < 1 {
                    self.rerollAllSlots()
                }
            }
        }
    }
    
    private func moveSymbols(slotLine: SKShapeNode, slotLineIndex: Int, slotSymbolIndex: Int) {
        if !slotLines[slotLineIndex].isRolling { slotLines[slotLineIndex].animationSpeed += 1
        } else {
            moveSingleSlotSymbol(slotCell: slotLine, index: slotSymbolIndex, animationSpeed: slotLines[slotLineIndex].animationSpeed)
        }
    }
    
    // Move all the next symbols to the center
    private func moveAllSlotSymbols() {
        isSlotMachineRollingOn = true
        visibleImages.removeAll()
        for slotLineIndex in slotLines.indices {
            //visibleImages.remove(on: slotLineIndex)
            if let slotLine = childNode(withName: "Slot Cell \(slotLineIndex)") as? SKShapeNode {
                for slotSymbolIndex in slotSymbols.indices {
                    if slotSymbolIndex != 2 {
                        moveSymbols(slotLine: slotLine, slotLineIndex: slotLineIndex, slotSymbolIndex: slotSymbolIndex)
                    }
                }
            }
        }
    }
}

extension SKTexture {
    // Get the name of the image texture
    public var name: String? {
        let comps = description.components(separatedBy: "'")
        return comps.count > 1 ? comps[1] : nil
    }
}

extension Array {
    public mutating func remove(on index: Int) {
        guard index > self.count else { return }
        self.remove(at: index)
    }
}

extension UIDevice {
    static let isOnPhone = UIDevice.current.userInterfaceIdiom == .phone
    static let isOnPad = UIDevice.current.userInterfaceIdiom == .pad
}
