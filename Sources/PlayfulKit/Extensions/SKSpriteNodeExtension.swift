//
//  SKSpriteNodeExtension.swift
//  PlayfulKit
//
//  Created by Yann Christophe MAERTENS on 08/02/2023.
//

import SpriteKit

public extension SKSpriteNode {
    struct Gradient {
        var rect: CGRect
        var points: UIImage.Gradient.Points
        var colors: [UIColor]
    }
    convenience init(gradient: Gradient) {
        self.init(
            texture: SKTexture.gradient(rect: gradient.rect,
                                        points: gradient.points,
                                        colors: gradient.colors)
        )
    }
}
