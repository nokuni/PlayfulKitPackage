//
//  IntExtension.swift
//  
//
//  Created by Yann Christophe MAERTENS on 20/02/2023.
//

import Foundation

public extension Int {
    /// Returns a string of the number with an amount of leading zeros.
    func leadingZeros(amount: Int) -> String {
        let result = String(format: "%0\(amount)d", self)
        return result
    }

    func rowCoordinates(column: Int) -> [Coordinate] {
        var coordinates: [Coordinate] = []
        for index in 0...column {
            let coordinate = Coordinate(x: self, y: index)
            coordinates.append(coordinate)
        }
        return coordinates.map { $0 }
    }

    func columnCoordinates(row: Int) -> [Coordinate] {
        var coordinates: [Coordinate] = []
        for index in 0...row {
            let coordinate = Coordinate(x: index, y: self)
            coordinates.append(coordinate)
        }
        return coordinates.map { $0 }
    }
}
