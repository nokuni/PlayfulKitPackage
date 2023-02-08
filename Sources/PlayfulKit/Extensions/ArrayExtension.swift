//
//  ArrayExtension.swift
//  PlayfulKit
//
//  Created by Yann Christophe MAERTENS on 07/02/2023.
//

import SpriteKit

public extension Array where Element: SKNode {
    
    func getAll(named name: String) -> [SKNode] {
        let nodes = self.filter { $0.name?.contains(name) ?? false }
        return nodes
    }
    
    func removeAll(named name: String) {
        getAll(named: name).forEach { $0.removeFromParent() }
    }
    
    func isExisting(_ name: String) -> Bool {
        self.contains { $0.name == name }
    }
    
    func getCount(named name: String) -> Int {
        return getAll(named: name).count
    }
}
