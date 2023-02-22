//
//  StringExtension.swift
//  
//
//  Created by Maertens Yann-Christophe on 18/02/23.
//

import Foundation

public extension String {
    
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
