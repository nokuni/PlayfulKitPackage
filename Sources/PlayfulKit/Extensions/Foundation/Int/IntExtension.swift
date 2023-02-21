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

    func rowCoordinates(column: Int) -> [Int] {
        var coordinates: [Coordinate] = []
        for index in 0..<column {
            let coordinate = Coordinate(x: self, y: index)
            coordinates.append(coordinate)
        }
        return coordinates.map { $0.x }
    }

    func columnCoordinates(row: Int) -> [Int] {
        var coordinates: [Coordinate] = []
        let indexRange = self ..< row
        let stringIndices = indexRange.map { $0.leadingZeros(amount: 2) }
        for string in stringIndices {
            coordinates.append(string.coordinate)
        }
        return coordinates.map { $0.y }
    }
}
