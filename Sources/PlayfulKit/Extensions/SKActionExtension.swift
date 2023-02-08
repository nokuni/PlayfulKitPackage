//
//  SKActionExtension.swift
//  PlayfulKit
//
//  Created by Yann Christophe MAERTENS on 08/02/2023.
//

import SpriteKit

public extension SKAction {
    static func setTexture(_ texture: SKTexture, with filteringMode: SKTextureFilteringMode) -> SKAction {
        let sequence = SKAction.sequence([
            SKAction.setTexture(texture),
            SKAction.run { texture.filteringMode = filteringMode }
        ])
        return sequence
    }
}
