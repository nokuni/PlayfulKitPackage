//
//  SKSceneExtension.swift
//  PlayfulKit
//
//  Created by Yann Christophe MAERTENS on 08/02/2023.
//

import SpriteKit

public extension SKScene {
    
    func children(named name: String) -> [SKNode] {
        var nodes: [SKNode] = []
        self.enumerateChildNodes(withName: name) { node, _ in
            nodes.append(node)
        }
        return nodes
    }
}
