//
//  SKNodeUtilities.swift
//  PlayfulKit
//
//  Created by Yann Christophe MAERTENS on 07/02/2023.
//

import SpriteKit

public extension SKNode {
    
    func childNodes(named name: String) -> [SKNode] {
        let nodes = self.children.filter { $0.name?.contains(name) ?? false }
        return nodes
    }
    
    func removeAllChildNodes(named name: String) {
        childNodes(named: name).forEach { $0.removeFromParent() }
    }
    
    func isExistingChildNode(named name: String) -> Bool {
        self.childNode(withName: name) != nil
    }
    
    func childNodesCount(named name: String) -> Int {
        let nodes = childNodes(named: name)
        return nodes.count
    }
}
