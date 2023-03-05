//
//  String.swift
//  
//
//  Created by Maertens Yann-Christophe on 05/03/23.
//

import Foundation

extension String {
    var coordinate: Coordinate {
        guard self.count == 4 else { return .zero }
        let array = Array(self)
        guard let x = Int("\(array[0])\(array[1])") else { return .zero }
        guard let y = Int("\(array[2])\(array[3])") else { return .zero }
        let result = Coordinate(x: x, y: y)
        return result
    }
}
