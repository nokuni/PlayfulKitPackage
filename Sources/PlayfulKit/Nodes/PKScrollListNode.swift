//
//  PKScrollListNode.swift
//  PlayfulKit
//
//  Created by Maertens Yann-Christophe on 30/10/22.
//

import SpriteKit

// MARK: - Scrolling list protocol
public protocol ScrollListDelegate {
    func selectRowNode(node: SKSpriteNode)
}

// MARK: - Scrolling list alignment modes
public enum ScrollListHorizontalAlignmentMode {
    case Center
    case Left
    case Right
}

public class PKScrollListNode: SKSpriteNode {
    
    // MARK: - Properties
    
    public let scrollNode: SKNode
    private var rows = [SKSpriteNode]()
    private var touchY: CGFloat = 0
    private let cropNode: SKCropNode
    public var horizontalAlignmentMode: ScrollListHorizontalAlignmentMode = .Center
    private var verticalMargin: CGFloat = 5
    private var scrollingListHeight: CGFloat = 0
    private var scrollResistance: CGFloat = 0
    private var scrollMin: CGFloat
    private var scrollMax: CGFloat
    public var isTouching: Bool = false
    
    public var delegate: ScrollListDelegate?
    
    // MARK: - Init
    
    public init(size: CGSize) {
        scrollNode = SKNode()
        scrollNode.physicsBody = SKPhysicsBody(rectangleOf: size)
        scrollNode.physicsBody?.affectedByGravity = false
        scrollNode.physicsBody?.linearDamping = 1
        cropNode = SKCropNode()
        scrollMin = size.height / 2
        scrollMax = size.height / -2
        
        super.init(texture: nil, color: UIColor.purple, size: size)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setup() {
        // Enable touches on the screen
        isUserInteractionEnabled = true
        
        // Set up the Y position of the scroll node
        scrollNode.position.y = scrollMin
        
        // Apply a mask to the scroll node.
        let mask = SKSpriteNode(color: UIColor.orange, size: size)
        cropNode.maskNode = mask
        addChild(cropNode)
        cropNode.addChild(scrollNode)
    }
    
    // MARK: - Touch
    
    public var previousY: CGFloat = 0
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        isTouching = true
        // stopScrollFromMoving()
        touchY = location.y
        previousY = scrollNode.position.y
    }
    
    var testCount = 0
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        
        var y = location.y - touchY + previousY
        
        applyScrollResistance()
        
        if y < scrollMin {
            y = scrollMin
        } else if y > (scrollingListHeight + UIScreen.main.bounds.height * 0.2) {
            y = scrollingListHeight + UIScreen.main.bounds.height * 0.2
        }
        
        if rows.count > 6 {
            scrollNode.position.y = y + scrollResistance
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        let dy = abs(location.y - touchY)
        
        // addScrollFlowAnimation()
        
        rubberBandEffect()
        
        isTouching = false
        
        if dy > 10 { return }
        
        for touchedNode in touchedNodes {
            if let delegate = delegate,
               let rowNode = touchedNode as? SKSpriteNode {
                if location.y > (-UIScreen.main.bounds.height * 0.252) && location.y < (UIScreen.main.bounds.height * 0.2478) {
                    delegate.selectRowNode(node: rowNode)
                }
            }
        }
    }
    
    // Add an impulse to the scroll at the end of the scroll gesture. (Does not work perfectly)
    private func addScrollFlowAnimation() {
        let minScroll = size.height / 2
        let maxScroll = scrollingListHeight - (size.height * 0.67)
        
        let isScrollingUpToGoDown = touchY < 0 && touchY > -100 && scrollNode.position.y > minScroll
        let isScrollingDownToGoUp = scrollNode.position.y < maxScroll
        
        if isScrollingUpToGoDown {
            let continuationAnimation = SKAction.applyImpulse(CGVector(dx: 0, dy: touchY * (-50)), duration: 0.01)
            scrollNode.run(continuationAnimation)
        } else if isScrollingDownToGoUp {
            let continuationAnimation = SKAction.applyImpulse(CGVector(dx: 0, dy: -touchY * 50), duration: 0.01)
            scrollNode.run(continuationAnimation)
        }
    }
    
    private func stopScrollFromMoving() {
        scrollNode.removeAllActions()
        scrollNode.physicsBody?.velocity = CGVector.zero
    }
    
    // Apply the rubber band effect on the scroll. When the scroll goes out of bounds, it returns to the minimal or maximum bound allowed.
    public func rubberBandEffect() {
        let minScroll = size.height / 2
        let maxScroll = scrollingListHeight - (size.height * 0.67)
        
        if scrollNode.position.y < minScroll {
            scrollMin = minScroll
            let animation = SKAction.sequence([
                SKAction.moveTo(y: scrollMin, duration: 0.2),
                SKAction.run {
                    self.scrollResistance = 0
                    self.scrollMin = -minScroll
                    self.scrollNode.physicsBody?.velocity = CGVector.zero
                }
            ])
            scrollNode.run(animation)
        }
        else if scrollNode.position.y > maxScroll {
            scrollMax = maxScroll
            let animation = SKAction.sequence([
                SKAction.moveTo(y: maxScroll, duration: 0.2),
                SKAction.run {
                    self.scrollResistance = 0
                    self.scrollMax = maxScroll
                    self.scrollNode.physicsBody?.velocity = CGVector.zero
                }
            ])
            scrollNode.run(animation)
        }
    }
    
    // Apply a resistance when the scroll is going more and more out of bounds.
    private func applyScrollResistance() {
        let minScroll = size.height / 2
        let maxScroll = scrollingListHeight - (size.height * 0.67)
        
        if scrollNode.position.y <= minScroll {
            scrollResistance += 2.5
        }
        else if scrollNode.position.y >= maxScroll {
            scrollResistance -= 2.5
        }
    }
    
    // Check, when the user is not touching the screen, if the scroll is going out of bounds to apply the rubber band effect
    public func checkBoundsToApplyRubberBandEffect() {
        if !isTouching { rubberBandEffect() }
    }
    
    
    // MARK: - Utility Methods
    
    // Append a row on the scroll list
    public func addNode(node: SKSpriteNode) {
        scrollNode.addChild(node)
        rows.append(node)
        setupRows()
    }
    
    // Remove a row on the scroll list
    public func removeNode(node: SKSpriteNode, index: Int) {
        node.removeFromParent()
        rows.remove(at: index)
    }
    
    // Insert a row on the scroll list
    public func insertNode(node: SKSpriteNode, at index: Int) {
        scrollNode.addChild(node)
        rows.insert(node, at: index)
        setupRows()
    }
    
    // Remove all rows on the scroll lists
    public func removeNodes() {
        scrollNode.removeAllChildren()
        rows.removeAll()
        setupRows()
    }
    
    // Draw the rows for the scroll list
    private func setupRows() {
        var totalY: CGFloat = 0
        for row in rows {
            positionRowHorizontal(row: row)
            row.position.y = totalY - row.size.height / 2
            totalY -= row.size.height + verticalMargin
        }
        scrollingListHeight = -totalY + rows.last!.size.height + verticalMargin
        setScrollLimits()
    }
    
    // Limit minimal and maximum height of the scroll
    private func setScrollLimits() {
        scrollMin = -size.height / 2
        scrollMax = scrollingListHeight - 1000 // - scrollingListHeight // + scrollMin
    }
    
    private func positionRowHorizontal(row: SKSpriteNode) {
        switch horizontalAlignmentMode {
        case .Center:
            row.position.x = 0
        case .Left:
            row.position.x = size.width / -2 + row.size.width / 2
        case .Right:
            row.position.x = size.width / 2 - row.size.width / 2
        }
    }
}
