//
//  SKTextureExtension.swift
//  PlayfulKit
//
//  Created by Yann Christophe MAERTENS on 08/02/2023.
//

import SpriteKit

public extension SKTexture {
    static func gradient(rect: CGRect, points: UIImage.Gradient.Points, colors: [UIColor]) -> SKTexture {
        let cgColors = colors.map { $0.cgColor }
        let image: UIImage = UIImage.Gradient.image(withBounds: rect, points: points, colors: cgColors)
        return SKTexture(image: image)
    }
}
