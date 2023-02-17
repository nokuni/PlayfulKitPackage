//
//  SKTextureUtilities.swift
//  
//
//  Created by Maertens Yann-Christophe on 17/02/23.
//

import SpriteKit

public extension SKTexture {
    // Get the name of the image texture
    var name: String? {
        let comps = description.components(separatedBy: "'")
        return comps.count > 1 ? comps[1] : nil
    }
}
