//
//  PKCoordinate.swift
//  
//
//  Created by Maertens Yann-Christophe on 15/02/23.
//

import Foundation

public struct PKCoordinate: Equatable {
    public init(x: Int,y: Int) {
        self.x = x
        self.y = y
    }
    public var x: Int
    public var y: Int
}
