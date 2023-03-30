//
//  String.swift
//  
//
//  Created by Maertens Yann-Christophe on 19/03/23.
//

import Utility_Toolbox

public extension String {
    
    var coordinate: Coordinate {
        guard self.count.isEven else { return .zero }
        guard let number = Int(self) else { return .zero}
        let numbers = number.digits.split()
        guard let x = numbers.firstPart.intValue else { return .zero }
        guard let y = numbers.lastPart.intValue else { return .zero }
        let result = Coordinate(x: x, y: y)
        return result
    }
    
    var matrix: Matrix {
        guard self.count.isEven else { return .zero }
        guard let number = Int(self) else { return .zero}
        let numbers = number.digits.split()
        guard let row = numbers.firstPart.intValue else { return .zero }
        guard let column = numbers.lastPart.intValue else { return .zero }
        let result = Matrix(row: row, column: column)
        return result
    }
}
