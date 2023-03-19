//
//  String.swift
//  
//
//  Created by Maertens Yann-Christophe on 19/03/23.
//

import Foundation

public extension String {
    var coordinate: Coordinate {
        guard self.count == 4 else { return .zero }
        guard let x = Int("\(digits[0])\(digits[1])") else { return .zero }
        guard let y = Int("\(digits[2])\(digits[3])") else { return .zero }
        let result = Coordinate(x: x, y: y)
        return result
    }
}
