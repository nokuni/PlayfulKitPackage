//
//  String.swift
//  
//
//  Created by Maertens Yann-Christophe on 19/03/23.
//

import Utility_Toolbox

public extension String {
    
    var coordinate: Coordinate {
        guard let number = Int(self) else { return .zero}
        guard number.isEven else { return .zero }
        let numbers = number.digits.split()
        guard let x = numbers.firstPart.numericValue else { return .zero }
        guard let y = numbers.lastPart.numericValue else { return .zero }
        let result = Coordinate(x: x, y: y)
        return result
    }
    
    var matrix: Matrix {
        guard let number = Int(self) else { return .zero}
        guard number.isEven else { return .zero }
        let numbers = number.digits.split()
        guard let row = numbers.firstPart.numericValue else { return .zero }
        guard let column = numbers.lastPart.numericValue else { return .zero }
        let result = Matrix(row: row, column: column)
        return result
    }
}
