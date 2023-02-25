//
//  CoordinateExtension.swift
//  
//
//  Created by Maertens Yann-Christophe on 19/02/23.
//

import Foundation

public extension Coordinate {
    
    /// The coordinate whose x and y are both zero.
    static var zero: Coordinate { Coordinate(x: 0, y: 0) }

    private mutating func advance(matrix: Matrix) {
        if y < matrix.maxY {
            y += 1
        } else {
            y = 0
            x += 1
        }
    }

    /// Returns the coordinates from a starting point to an ending point in a a specific matrix.
    static func coordinates(from startingCoordinate: Coordinate,
                            to endingCoordinate: Coordinate,
                            in matrix: Matrix) -> [Coordinate] {
        var coordinates: [Coordinate] = []
        var currentCoordinate = startingCoordinate

        repeat {
            coordinates.append(currentCoordinate)
            currentCoordinate.advance(matrix: matrix)
        } while currentCoordinate != endingCoordinate

        return coordinates
    }
}
