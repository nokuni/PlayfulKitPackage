//
//  SKNodeExtension.swift
//  PlayfulKit
//
//  Created by Yann Christophe MAERTENS on 07/02/2023.
//

import SpriteKit

public extension SKNode {
    func removeAll(named: String) {
        self.enumerateChildNodes(withName: named) { node, _ in node.removeFromParent() }
    }
    
    func isExisting(_ name: String) -> Bool {
        self.childNode(withName: name) != nil
    }
}
