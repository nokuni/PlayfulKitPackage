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
}
