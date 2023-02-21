//
//  StringExtension.swift
//  
//
//  Created by Maertens Yann-Christophe on 18/02/23.
//

import Foundation

extension String {
    var expression: NSExpression {
        return NSExpression(format: self)
    }
    
    func intoUInt32(from dictionary: [Int: UInt32]) -> UInt32? {
        let number = self.expression.expressionValue(with: dictionary, context: nil) as? UInt32
        return number
    }

    func coordinate(in string: String) -> Coordinate {
        guard string.count == 2 else { return Coordinate.zero }
        guard Int(string) != nil else { return Coordinate.zero }
        guard let x = string.first?.wholeNumberValue else { return Coordinate.zero }
        guard let y = string.last?.wholeNumberValue else { return Coordinate.zero }
        let coordinate = Coordinate(x: x, y: y)
        return coordinate
    }
}
