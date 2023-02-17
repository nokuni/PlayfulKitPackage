//
//  PKCoordinate.swift
//  
//
//  Created by Maertens Yann-Christophe on 15/02/23.
//

import Foundation

public struct PKCoordinate: Equatable {
    public init(
        x: Int = 0,
        y: Int = 0) {
            self.x = x
            self.y = y
        }
    public var x: Int = 0
    public var y: Int = 0
}
