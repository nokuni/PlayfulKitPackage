//
//  StringExtension.swift
//  
//
//  Created by Maertens Yann-Christophe on 18/02/23.
//

import Foundation

public extension String {

    private var expression: NSExpression {
        return NSExpression(format: self)
    }

    /// Returns an UInt32 from the string.
    func intoUInt32(from dictionary: [Int: UInt32]) -> UInt32? {
        let number = self.expression.expressionValue(with: dictionary, context: nil) as? UInt32
        return number
    }

    /// The coordinate in the string.
    var coordinate: Coordinate {
        guard self.count == 2 else { return Coordinate.zero }
        guard Int(self) != nil else { return Coordinate.zero }
        guard let x = self.first?.wholeNumberValue else { return Coordinate.zero }
        guard let y = self.last?.wholeNumberValue else { return Coordinate.zero }
        let coordinate = Coordinate(x: x, y: y)
        return coordinate
    }
}
