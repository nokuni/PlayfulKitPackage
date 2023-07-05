//
//  ProgressBarNode.swift
//  PlayfulKit
//
//  Created by Maertens Yann-Christophe on 11/08/22.
//

import SpriteKit
import Utility_Toolbox

public class PKProgressBarNode: SKNode {
    
    public init(configuration: ShapeConfiguration) {
        self.configuration = configuration
        
        super.init()
        
        createBar()
        crop()
        createUnderBar()
    }
    public init(imageConfiguration: ImageConfiguration = .init()) {
        self.imageConfiguration = imageConfiguration
        
        super.init()
        
        createImageBar()
        imageCrop()
        createImageUnderBar()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var configuration: ShapeConfiguration?
    private var imageConfiguration: ImageConfiguration?
    
    private var cropNode = SKCropNode()
    private var barNode = SKSpriteNode()
    private var underBarNode = SKSpriteNode()
    
    /// A progress bar synthesized with colors.
    public struct ShapeConfiguration {
        public init(amount: CGFloat = 1,
                    size: CGSize,
                    color: UIColor = .blue,
                    underColor: UIColor = .black,
                    cornerRadius: CGFloat = 15) {
            self.amount = amount
            self.size = size
            self.color = color
            self.underColor =  underColor
            self.cornerRadius = cornerRadius
        }
        var amount: CGFloat
        var size: CGSize
        var color: UIColor
        var underColor: UIColor
        var cornerRadius: CGFloat
    }
    /// A progress bar synthesized with custom images.
    public struct ImageConfiguration {
        public init(amount: CGFloat = 1,
                    sprite: SKSpriteNode = SKSpriteNode(),
                    underSprite: SKSpriteNode = SKSpriteNode()) {
            self.amount = amount
            self.sprite = sprite
            self.underSprite = underSprite
        }
        var amount: CGFloat
        var sprite: SKSpriteNode
        var underSprite: SKSpriteNode
    }
    
    // MARK: - PUBLIC
    
    /// Sets an amount between 0 and 1 for the progress bar.
    public func set(to amount: CGFloat, duration: CGFloat) {
        let animation = scale(amount: amount, duration: duration)
        cropNode.maskNode!.run(animation)
    }
    
    /// Increases the current amount of the progress bar.
    public func increase(by amount: CGFloat, duration: CGFloat) {
        guard let maskNode = cropNode.maskNode else { return }
        let scaleAmount = maskNode.xScale + amount
        let animation = scale(amount: scaleAmount, duration: duration)
        if cropNode.maskNode!.xScale < 1 {
            cropNode.maskNode!.run(animation)
        }
    }
    
    /// Decreases the current amount of the progress bar.
    public func decrease(by amount: CGFloat, duration: CGFloat) {
        guard let maskNode = cropNode.maskNode else { return }
        let scaleAmount = maskNode.xScale - amount
        let animation = scale(amount: scaleAmount, duration: duration)
        if cropNode.maskNode!.xScale > 0 {
            cropNode.maskNode!.run(animation)
        }
    }
    
    /// Set the amount of the progress bar to 1.
    public func max(duration: CGFloat) {
        let amount: CGFloat = 1
        let animation = scale(amount: amount, duration: duration)
        cropNode.maskNode!.run(animation)
    }
    
    /// Set the amount of the progress bar to 0.
    public func min(duration: CGFloat) {
        let amount: CGFloat = 0
        let animation = scale(amount: amount, duration: duration)
        cropNode.maskNode!.run(animation)
    }
    
    /// Check if the amount of the progress bar is 0.
    public func isBarEmpty() -> Bool {
        guard let maskNode = cropNode.maskNode else { return false}
        return maskNode.xScale <= 0
    }
    
    /// Check if the amount of the progress bar is 1.
    public func isBarFull() -> Bool {
        guard let maskNode = cropNode.maskNode else { return false}
        return maskNode.xScale >= 1
    }
    
    // MARK: - PRIVATE
    
    private func scale(amount: CGFloat,
                       duration: CGFloat) -> SKAction {
        let scaleAnimation = SKAction.scaleX(to: amount, duration: duration)
        return scaleAnimation
    }
    
    private func createImageBar() {
        guard let imageConfiguration = imageConfiguration else { return }
        barNode = imageConfiguration.sprite
    }
    private func imageCrop() {
        guard let imageConfiguration = imageConfiguration else { return }
        cropNode.addChildSafely(barNode)
        cropNode.maskNode =
        SKSpriteNode(
            color: UIColor.white,
            size: CGSize(width: barNode.size.width * 2,
                         height: barNode.size.height * 2)
        )
        cropNode.maskNode?.xScale = imageConfiguration.amount
        cropNode.maskNode?.position =
        CGPoint(x: -barNode.size.width / 2,
                y: -barNode.size.height / 2)
        cropNode.zPosition = 0.1
        addChildSafely(cropNode)
    }
    private func createImageUnderBar() {
        guard let imageConfiguration = imageConfiguration else { return }
        underBarNode = imageConfiguration.underSprite
        addChildSafely(underBarNode)
    }
    
    private func createBar() {
        guard let configuration = configuration else { return }
        if let image = UIImage.rectangle(size: configuration.size,
                                         color: configuration.color,
                                         cornerRadius: configuration.cornerRadius) {
            let texture = SKTexture(image: image)
            barNode = SKSpriteNode(texture: texture)
        }
    }
    private func crop() {
        guard let configuration = configuration else { return }
        cropNode.addChildSafely(barNode)
        cropNode.maskNode =
        SKSpriteNode(
            color: UIColor.white,
            size: CGSize(width: barNode.size.width * 2,
                         height: barNode.size.height * 2)
        )
        cropNode.maskNode?.xScale = configuration.amount
        cropNode.maskNode?.position =
        CGPoint(x: -barNode.size.width / 2,
                y: -barNode.size.height / 2)
        cropNode.zPosition = 0.1
        addChildSafely(cropNode)
    }
    private func createUnderBar() {
        guard let configuration = configuration else { return }
        if let image = UIImage.rectangle(size: configuration.size,
                                         color: configuration.underColor,
                                         cornerRadius: configuration.cornerRadius) {
            let texture = SKTexture(image: image)
            underBarNode = SKSpriteNode(texture: texture)
            addChildSafely(underBarNode)
        }
    }
}
