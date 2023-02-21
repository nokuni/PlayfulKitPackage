//
//  ArrayUtilities.swift
//  PlayfulKit
//
//  Created by Yann Christophe MAERTENS on 07/02/2023.
//

import SpriteKit

public extension Array {
    /// Returns a splitted array with parts of the same size.
    func splitted(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
