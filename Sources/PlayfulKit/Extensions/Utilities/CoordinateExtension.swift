//
//  CoordinateExtension.swift
//  
//
//  Created by Maertens Yann-Christophe on 19/02/23.
//

import Foundation

public extension Coordinate {
    var index: Int? {
        let string = "\(x)\(y)"
        let result = Int(string)
        return result
    }
    static var zero: Coordinate { return Coordinate(x: 0, y: 0) }
    mutating func advanceX(by amount: Int) {
        self.x += amount
    }
    mutating func advanceY(by amount: Int) {
        self.y += amount
    }
    static func coordinates(from startingCoordinate: Coordinate,
                            to endingCoordinate: Coordinate) -> [Coordinate] {
        guard let startIndex = startingCoordinate.index else { return [] }
        guard let endIndex = endingCoordinate.index else { return [] }
        var coordinates: [Coordinate] = []
        for _ in startIndex ..< endIndex {
            let stringIndex = startIndex.leadingZeros(amount: 2)
            let coordinate = stringIndex.coordinate(in: stringIndex)
            coordinates.append(coordinate)
        }
        return coordinates
    }
}
