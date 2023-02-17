//
//  ArrayUtilities.swift
//  PlayfulKit
//
//  Created by Yann Christophe MAERTENS on 07/02/2023.
//

import SpriteKit

public extension Array {
    func splitted(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
