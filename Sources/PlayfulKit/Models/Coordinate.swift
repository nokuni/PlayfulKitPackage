//
//  PKCoordinate.swift
//  
//
//  Created by Maertens Yann-Christophe on 15/02/23.
//

import Foundation

/// The coordinate x and y.
public struct Coordinate: Equatable {
    public init(x: Int,y: Int) {
        self.x = x
        self.y = y
    }
    public var x: Int
    public var y: Int
}
