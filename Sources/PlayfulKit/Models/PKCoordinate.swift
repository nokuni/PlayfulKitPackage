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
    var x: Int = 0
    var y: Int = 0
}
