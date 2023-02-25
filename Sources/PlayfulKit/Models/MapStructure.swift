//
//  MapStructure.swift
//  
//
//  Created by Maertens Yann-Christophe on 25/02/23.
//

import SpriteKit

/// A quadrilateral structure of textures
public struct MapStructure {
    public init(name: String? = nil,
                topLeft: SKTexture,
                topRight: SKTexture,
                bottomLeft: SKTexture,
                bottomRight: SKTexture,
                left: SKTexture,
                right: SKTexture,
                top: SKTexture,
                bottom: SKTexture,
                middle: SKTexture) {
        self.name = name
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
        self.left = left
        self.right = right
        self.top = top
        self.bottom = bottom
        self.middle = middle
    }
    
    public var name: String?
    public var topLeft: SKTexture
    public var topRight: SKTexture
    public var bottomLeft: SKTexture
    public var bottomRight: SKTexture
    public var left: SKTexture
    public var right: SKTexture
    public var top: SKTexture
    public var bottom: SKTexture
    public var middle: SKTexture
}
