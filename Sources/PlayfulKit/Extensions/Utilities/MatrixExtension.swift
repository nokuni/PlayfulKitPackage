//
//  File.swift
//  
//
//  Created by Yann Christophe MAERTENS on 20/02/2023.
//

import Foundation

public extension Matrix {

    /// The matrix whose row and column are both zero.
    static var zero: Matrix { return Matrix(row: 0, column: 0) }

    /// The first coordinate on a matrix.
    var firstCoordinate: Coordinate {
        Coordinate(x: 0, y: 0)
    }

    /// The last coordinate on a matrix.
    var lastCoordinate: Coordinate {
        Coordinate(x: self.row - 1, y: self.column - 1)
    }
}
