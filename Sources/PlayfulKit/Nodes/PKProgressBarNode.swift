//
//  ProgressBarNode.swift
//  PlayfulKit
//
//  Created by Maertens Yann-Christophe on 11/08/22.
//

import SpriteKit

public class PKProgressBarNode: SKNode {
    
    public var emptySprite: SKSpriteNode? = nil
    public var progressBar: SKCropNode
    public init(emptyImageName: String!, filledImageName : String, width: CGFloat, height: CGFloat) {
        progressBar = SKCropNode()
        super.init()
        let filledImage = SKSpriteNode(imageNamed: filledImageName)
        filledImage.size = CGSize(width: UIScreen.main.bounds.width * width, height: UIScreen.main.bounds.width * height)
        filledImage.texture?.filteringMode = .nearest
        progressBar.addChild(filledImage)
        progressBar.maskNode =
        SKSpriteNode(color: UIColor.white, size: CGSize(width: filledImage.size.width * 2, height: filledImage.size.height * 2))
        
        progressBar.maskNode?.position =
        CGPoint(x: -filledImage.size.width / 2,y: -filledImage.size.height / 2)
        
        progressBar.zPosition = 0.1
        self.addChild(progressBar)
        
        if emptyImageName != nil {
            emptySprite = SKSpriteNode.init(imageNamed: emptyImageName)
            emptySprite?.size = CGSize(width: UIScreen.main.bounds.width * width, height: UIScreen.main.bounds.width * height)
            emptySprite?.texture?.filteringMode = .nearest
            self.addChild(emptySprite!)
        }
    }
    
    public func getScaleAnimation(amount: CGFloat, duration: CGFloat) -> SKAction {
        let scaleAnimation = SKAction.scaleX(to: progressBar.maskNode!.xScale + amount, duration: duration)
        return scaleAnimation
    }
    
    public func decrease(_ amount: CGFloat, duration: CGFloat) {
        let animation = getScaleAnimation(amount: -amount, duration: duration)
        if progressBar.maskNode!.xScale > 0 {
            progressBar.maskNode!.run(animation)
            if progressBar.maskNode!.xScale < 0 { setToMin(duration: duration) }
        }
    }
    
    public func increase(_ amount: CGFloat, duration: CGFloat) {
        progressBar.maskNode!.xScale += amount
    }
    
    public func setToMax(duration: CGFloat) {
        let scaleAnimation = SKAction.scaleX(to: 1, duration: duration)
        progressBar.maskNode!.run(scaleAnimation)
    }
    
    public func setToMin(duration: CGFloat) {
        let scaleAnimation = SKAction.scaleX(to: 0, duration: duration)
        progressBar.maskNode!.run(scaleAnimation)
    }
    
    public func setTo(_ amount: CGFloat, duration: CGFloat) {
        let scaleAnimation = SKAction.scaleX(to: amount, duration: duration)
        progressBar.maskNode!.run(scaleAnimation)
    }
    
    public func isHealthBarEmpty() -> Bool {
        guard let maskNode = progressBar.maskNode else { return false}
        return maskNode.xScale <= 0
    }
    
    public func setXProgress(xProgress : CGFloat){
        var value = xProgress
        if xProgress < 0 { value = 0 }
        if xProgress > 1 { value = 1 }
        progressBar.maskNode?.xScale = value
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
