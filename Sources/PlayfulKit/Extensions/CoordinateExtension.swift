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
    /// The coordinate whose x and y are both zero.
    static var zero: Coordinate { Coordinate(x: 0, y: 0) }
    
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
        for index in startIndex ..< endIndex {
            let stringIndex = index.leadingZeros(amount: 3)
            let coordinate = stringIndex.coordinate
            coordinates.append(coordinate)
        }
        return coordinates
    }
}
