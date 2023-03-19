//
//  File.swift
//  
//
//  Created by Maertens Yann-Christophe on 26/02/23.
//

import SpriteKit

public extension Int {
    
    func intoSprites(with image: String,
                     filteringMode: SKTextureFilteringMode = .linear,
                     spacing: CGFloat = 1,
                     of size: CGSize,
                     at position: CGPoint,
                     on node: SKNode) {
        let assembly = AssemblyManager()
        var sprites = [SKSpriteNode]()
        for number in digits {
            let sprite = SKSpriteNode(imageNamed: "\(image)\(number)")
            sprite.texture?.filteringMode = filteringMode
            sprite.size = size
            sprites.append(sprite)
        }
        
        assembly.createSpriteList(of: sprites,
                                  at: position,
                                  in: node,
                                  axes: .horizontal,
                                  adjustement: .center,
                                  spacing: spacing)
    }
}
