//
//  MapStructure.swift
//  
//
//  Created by Maertens Yann-Christophe on 25/02/23.
//

import SpriteKit

/// A quadrilateral structure of textures
public struct MapStructure: Codable {
    public init(name: String? = nil,
                topLeft: String,
                topRight: String,
                bottomLeft: String,
                bottomRight: String,
                left: String,
                right: String,
                top: String,
                bottom: String,
                middle: String) {
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
    public var topLeft: String
    public var topRight: String
    public var bottomLeft: String
    public var bottomRight: String
    public var left: String
    public var right: String
    public var top: String
    public var bottom: String
    public var middle: String
}
