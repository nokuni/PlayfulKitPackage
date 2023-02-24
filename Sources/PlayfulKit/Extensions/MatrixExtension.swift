//
//  File.swift
//  
//
//  Created by Yann Christophe MAERTENS on 20/02/2023.
//

import Foundation

public extension Matrix {

    /// The matrix whose row and column are both zero.
    static var zero: Matrix {
        Matrix(row: 0, column: 0)
    }

    /// The last x coordinate.
    var maxX: Int {
        row - 1
    }

    /// The last y coordinate.
    var maxY: Int {
        column - 1
    }

    /// The first coordinate on a matrix.
    var firstCoordinate: Coordinate {
        Coordinate(x: 0, y: 0)
    }

    /// The last coordinate on a matrix.
    var lastCoordinate: Coordinate {
        Coordinate(x: maxX, y: maxY)
    }

    func lastCoordinate(from startingCoordinate: Coordinate) -> Coordinate {
        let x = (row + startingCoordinate.x) - 1
        let y = (column + startingCoordinate.y) - 1
        let coordinate = Coordinate(x: x, y: y)
        return coordinate
    }
}
